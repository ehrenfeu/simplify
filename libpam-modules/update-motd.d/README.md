Usage
=====

At the time of writing, this is a Debian/Ubuntu specific extension to PAM that
allows for dynamic creation of the MOTD (see the [Debian
wiki](http://wiki.debian.org/motd) for more information).

To use it, create the directory `/etc/update-motd.d` (on Ubuntu it is usually
already existing) and copy the desired scripts there. They will be run in order
(using the system's `LC_COLLATE` setting) during interactive logon and the
messages get printed to the console.
