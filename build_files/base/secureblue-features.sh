#!/usr/bin/bash

set -ouex pipefail

# Per-network MAC randomization
wget https://raw.githubusercontent.com/secureblue/secureblue/live/config/files/usr/etc/NetworkManager/conf.d/rand_mac.conf -O /usr/etc/NetworkManager/conf.d/rand_mac.conf

# Lock down firewall
wget https://raw.githubusercontent.com/secureblue/secureblue/live/config/files/usr/etc/firewalld/zones/FedoraWorkstation.xml -O /usr/etc/firewalld/zones/FedoraWorkstation.xml

# Configure chronyd to use Network Time Security (NTS)
wget https://raw.githubusercontent.com/secureblue/secureblue/live/config/files/usr/etc/chrony.conf -O /usr/etc/chrony.conf
wget https://raw.githubusercontent.com/secureblue/secureblue/live/config/files/usr/etc/sysconfig/chronyd -O /usr/etc/sysconfig/chronyd

# sudo timeout to 1min instead of 0min
wget https://raw.githubusercontent.com/secureblue/secureblue/live/config/files/usr/etc/sudoers.d/timeout -O /usr/etc/sudoers.d/timeout

# Disable passwordless sudo for rpm-ostree install
wget https://raw.githubusercontent.com/secureblue/secureblue/live/config/files/usr/share/polkit-1/rules.d/org.projectatomic.rpmostree1.rules -O /usr/share/polkit-1/rules.d/org.projectatomic.rpmostree1.rules
