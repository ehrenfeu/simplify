Purpose
=======
Additional filter rules for [logcheck](http://fix.me) that can live in peaceful
co-existence with the ones provided by your distribution by adding a `-local`
suffix to their name. This way they don't clash with new versions from your
package management systems and it's easy to identify which filters have been
added locally.

Usage
=====
To use the additional filter rules in this directory, just create symlinks from
within `/etc/logcheck/ignore.d.server/`, e.g. by using these commands:

<code>
cd /etc/logcheck/ignore.d.server/
ln -s /opt/simplify/logcheck/ignore.d.server/ntp-local
</code>

Make sure the files are readable by logcheck, you can test this by running
`logcheck-test` on individual files, like for example:

<code>
sudo -u logcheck logcheck-test -s -r /opt/simplify/logcheck/ignore.d.server/ntp-local
</code>
