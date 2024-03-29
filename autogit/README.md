Auto-tracking changes in a directory
====================================

Simple shell script to automatically track changes in a directory tree.

The script was written and successfully tested on many hosts to track changes
in /etc - please be aware that pushing the repo to a public git hosting service
will reveal **highly sensitive** security information about the installation,
so it is strongly discouraged to do this! Use a private git server or don't
push the repository to a remote host (it will still work locally).

Setup
-----

First, clone the repository containing this script. The proposed location is
/opt (otherwise you have to adjust the cronjob, see below):

```bash
cd /opt
git clone https://github.com/ehrenfeu/simplify.git
```

Next, initialize the repo for the directory tree you'd like to track (/etc in
this case), make sure only root can access the repository (so you don't
accidentially leak the files to a regular user), add the ignores and configure
git for the root user:

```bash
# configure the git default branch name system-wide:
git config --global init.defaultBranch main

# first make sure to be independent of different /etc/hostname conventions
# (e.g. Debian has the host's name only there, CentOS has the FQDN instead):
SHORTNAME=${HOSTNAME%%\.*}
REPONAME="autogit-etc-${SHORTNAME}"
mkdir -pv /var/autogit
export GIT_DIR=/var/autogit/${REPONAME}.git
export GIT_WORK_TREE=/etc
git init
chmod go-rx $GIT_DIR
ls -la $GIT_DIR

cd $GIT_WORK_TREE
cp -v /opt/simplify/autogit/gitignore.etc .gitignore
git add .
git config --global user.name "root (${SHORTNAME})"
git config --global user.email "root@${SHORTNAME}"
git commit -a -m "Initial import of /etc on host '${SHORTNAME}'."
```

**Optionally** (but recommended) configure a remote repository to auto-push the
changes. As mentioned, **DO NOT USE** a public service like github here, as
this will compromise highly sensitive data:
```bash
GIT_SSH_HOST="git.your-domain.xy"
GIT_SSH_USER="git"
GIT_SSH_PORT=22072
GIT_SERVICE_USER="ag-etc-${SHORTNAME}"
KEYNAME="$HOME/.ssh/id_ed25519.autogit-etc-${SHORTNAME}"

# generate the ssh-key used for pushing:
ssh-keygen -N '' -ted25519 -f $KEYNAME

# add the git server to the ssh config, make it use the generated ssh key:
echo "
Host $GIT_SSH_HOST
  User $GIT_SSH_USER
  Port $GIT_SSH_PORT
  IdentityFile $KEYNAME" >> $HOME/.ssh/config

# print the public key, so it can be added to the gitlab user:
echo -e "\nPublic key for repository >>> $REPONAME <<<\n" && cat $KEYNAME.pub && echo

# add the remote git server:
git remote add origin $GIT_SSH_USER@$GIT_SSH_HOST:$GIT_SERVICE_USER/${REPONAME}.git
git remote -v

# initial push to "master":
git push --all

# set the action git push should take if no refspec is given (push current
# branch to same name on remote):
git config --global push.default current

# push "production" and set it as upstream:
git push --set-upstream
```

Finally, install and configure the cronjob that auto-commits all changes
(adjust the cronjob-file to configure who will receive notification emails,
where to find the "autogit" script and how often to run it):

```bash
# tell autogit-commit.sh about GIT_DIR:
echo $GIT_DIR > $GIT_WORK_TREE/.autogit_dir

cd /etc/cron.d/
cp -v /opt/simplify/autogit/cronjob.autogit-etc autogit-etc
vim autogit-etc
git add autogit-etc
git commit -m "Add cronjob."
```
