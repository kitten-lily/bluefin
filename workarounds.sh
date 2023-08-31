#!/bin/sh

set -oeux pipefail

# alternatives cannot create symlinks on its own during a container build
ln -sf /usr/bin/ld.bfd /etc/alternatives/ld && ln -sf /etc/alternatives/ld /usr/bin/ld

# Create symlinks for /opt to fix 1Password
echo "-- Creating symlinks to fix packages that install to /opt --"
# Create symlink for /opt to /var/opt since it is not created in the image yet
mkdir -p "/var/opt"
ln -s "/var/opt"  "/opt"
# Create symlink for 1Password
mkdir -p "/usr/lib/opt/1Password"
ln -s "../../usr/lib/opt/1Password" "/var/opt/1Password"
echo "Created symlinks for 1Password"
echo "---"
