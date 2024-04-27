#!/bin/sh

set -oeux pipefail

# alternatives cannot create symlinks on its own during a container build
ln -sf /usr/bin/ld.bfd /etc/alternatives/ld && ln -sf /etc/alternatives/ld /usr/bin/ld

# Run vscode under wayland
sed -i 's/--new/--ozone-platform-hint=auto --new/' /usr/share/applications/code.desktop