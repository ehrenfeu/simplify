Simple Profile Switcher
=======================

A convenience interface to do quick adjustments to your profile in case of
changing scenarios.

Assuming you're having ```~/bin/``` in your ```PATH```, you can do this to
install this tool:
```
cd $HOME
ln -s usr/packages/simplify/myprofiles/settings .myprofile-settings
cd $HOME/bin
for file in $(ls ../.myprofile-settings/) ; do
    ln -s ../usr/packages/simplify/myprofiles/myprofiles.sh myprofile_$file
done
```

After this, you can activate the settings from a specific profile like this:
```
myprofile_trackpoint
```
