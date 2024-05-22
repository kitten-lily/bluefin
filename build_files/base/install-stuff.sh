#!/usr/bin/bash

set -ouex pipefail

wget https://proton.me/download/mail/linux/ProtonMail-desktop-beta.rpm -O /tmp/ProtonMail-desktop-beta.rpm
rpm-ostree install /tmp/ProtonMail-desktop-beta.rpm

. /tmp/build/install-1password.sh