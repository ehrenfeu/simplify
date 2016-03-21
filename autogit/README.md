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
git clone http://github.com/ehrenfeu/simplify.git
```

Next, initialize the repo for the directory tree you'd like to track (/etc in
this case), make sure only root can access the repository (so you don't
accidentially leak the files to a regular user), add the ignores and configure
git for the root user:

```bash
cd /etc
cp -v /opt/simplify/autogit/gitignore.etc .gitignore
git init
chmod go-rx .git
git add .
git config --global user.name "root (${HOSTNAME})" 
git config --global user.email "root@${HOSTNAME}" 
git commit -a -m "initial import of /etc on host '${HOSTNAME}'" 
```

Finally, install and configure the cronjob that auto-commits all changes
(adjust the cronjob-file to configure who will receive notification emails,
where to find the "autogit" script and how often to run it):

```bash
cd /etc/cron.d/
cp -v /opt/simplify/autogit/cronjob.autogit-etc autogit-etc
vim autogit-etc
git add autogit-etc
git commit -m "add cronjob" 
```

**Optionally** (but recommended) configure a remote repository to auto-push the
changes. As mentioned, **DO NOT USE** a public service like github here, as
this will compromise highly sensitive data:
```bash
git remote add origin git-repo-hosting-machine:etc-${HOSTNAME}.git
git push --all
```

