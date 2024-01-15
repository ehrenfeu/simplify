#!/usr/bin/env python3

import os
import socket

mappings = []
basedir = "/scratch/containers"

print(f"\nChecking for containers in [{basedir}]...\n")
for container in os.listdir(basedir):
   try:
       ip_addr = socket.gethostbyname(container)
   except:
       print(f">>> Cannot resolve [{container}], skipping.")
       continue
   mappings.append({
       "ip_addr": ip_addr,
       "container": container
   })

# sort mappings by the last octet of the IPv4 address:
mappings.sort(key=lambda k: int(k["ip_addr"].split(".")[3]))

print("\n" + "-" * 72)
print("# new content for /etc/lxc/dnsmasq-hosts.conf")
print("-" * 72)

for mapping in mappings:
   print(f"{mapping['container']},{mapping['ip_addr']}")


print("\n\n" + "-" * 72)
print("# new content for /etc/hosts")
print("-" * 72)

for mapping in mappings:
   print(f"{mapping['ip_addr']}\t{mapping['container']}   {mapping['container']}.lxcnet")

print("\n")
