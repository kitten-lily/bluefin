#!/usr/bin/bash

set -ouex pipefail

wget https://proton.me/download/mail/linux/ProtonMail-desktop-beta.rpm -O /tmp/ProtonMail-desktop-beta.rpm
rpm-ostree install /tmp/ProtonMail-desktop-beta.rpm

wget https://proton.me/download/PassDesktop/linux/x64/version.json -O - | jq '[.Releases[] | select(.CategoryName == "Stable")][0].File[] | select(.Identifier == ".rpm (Fedora/RHEL)")' > /tmp/protonpass.json
wget -O /tmp/protonpass.rpm "$(jq -r '.Url' /tmp/protonpass.json)"
echo "$(jq -r '.Sha512CheckSum' /tmp/protonpass.json) /tmp/protonpass.rpm" | sha512sum --check --status
rpm-ostree install /tmp/protonpass.rpm

. /tmp/build/install-1password.sh