Merge in changes from distribution packages
===========================================

To update the upstream branch bash files using the debian packages the
following commands can be used:

```bash
# 1) fetch the package
wget http://de.archive.ubuntu.com/ubuntu/pool/main/b/bash/bash_4.3-14ubuntu1_amd64.deb

# 2) extract it
ar x bash*.deb data.tar.xz

# 3) remove the deb
rm bash*.deb

# 4) extract /etc from the data tarball
tar xJf data.tar.xz ./etc/skel/

# 5) move the "skel" files accordingly
find etc/ -type f  | xargs rename -v -f 's,etc/skel/\.,,'

# 6) clean up
tree -a etc/
rm -r etc/ data.tar.xz
```
