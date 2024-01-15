# Assign fixed IPv4 addresses to containers

:warning: The approach documented here has changed in 2023, previously
`/etc/ethers` was used to deal with fixed assignments :warning:

The `dnsmasq` shipping with `lxc` seems to be very picky (unable?) to respect
`/etc/ethers`, so unlike what was documented here before, we are using a
different approach based on a *dnsmasq-specific* hosts file to ensure containers
will always be assigned the **same IPv4 address**.

## Enable the DHCP config file option for LXC

Verify the line below is enabled in `/etc/default/lxc-net`:

```bash
LXC_DHCP_CONFILE=/etc/lxc/dnsmasq.conf
```

## Set a DHCP `hosts` file for the LXC `dnsmasq`

In the file configured above (`/etc/lxc/dnsmasq.conf`), make sure the entry
`dhcp-hostsfile` is present like this:

```text
dhcp-hostsfile=/etc/lxc/dnsmasq-hosts.conf
```

:repeat: If any of the two files above were changed, restart the `lxc-net`
service!

```bash
systemctl restart lxc-net.service
```

## Assembling / updating `dnsmasq-hosts.conf` and `/etc/hosts`

For simplicity there is a Python script scanning for existing containers and
trying to resolve the name for each of them to an IPv4 address.

Simply run `assemble-lxc-dnsmasq-hosts.py` (consider symlinking it to
`/etc/_admin/bin/` or similar) and replace the corresponding contents of
`/etc/lxc/dnsmasq-hosts.conf` and `/etc/hosts` according to the output.

## Checking known dnsmasq DHCP leases

DHCP leases are stored per interface (`lxcbr0` by default for LXC) in
`/var/lib/misc/dnsmasq.lxcbr0.leases` - to make dnsmasq forget about them simply
stop `lxc-net.service`, remove the entire file or individual lines from it and
then start `lxc-net.service` again.
