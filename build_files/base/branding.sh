#!/usr/bin/bash

set -ouex pipefail

# Branding for Bluefin/Aurora
if test "$BASE_IMAGE_NAME" = "silverblue"; then
    sed -i '/^PRETTY_NAME/s/Silverblue/Bluefin/' /usr/lib/os-release
elif test "$BASE_IMAGE_NAME" = "kinoite"; then
    sed -i '/^PRETTY_NAME/s/Kinoite/Aurora/' /usr/lib/os-release
    sed -i 's/Bluefin/Aurora/g' /usr/etc/yafti.yml
    sed -i 's/Aurora (Beta)/Aurora \- Bluefin\-KDE (Alpha)/' /usr/etc/yafti.yml
    sed -i 's/Bluefin/Aurora/' /usr/libexec/ublue-flatpak-manager
elif test "$BASE_IMAGE_NAME" = "base"; then
    sed -i '/^PRETTY_NAME/s/Forty/Starlit/' /usr/lib/os-release
    sed -i 's/Bluefin/Starlit/g' /usr/etc/yafti.yml
    sed -i 's/Starlit (Beta)/Starlit \- Bluefin\-COSMIC (Alpha)/' /usr/etc/yafti.yml
    sed -i 's/Bluefin/Starlit/' /usr/libexec/ublue-flatpak-manager
fi

# Watermark for Plymouth
cp /usr/share/plymouth/themes/spinner/{"$BASE_IMAGE_NAME"-,}watermark.png
