#!/usr/bin/env bash
# Generate en_SE locale

set -oue pipefail

rpm-ostree install glibc-locale-source
wget -q -O- https://github.com/u296/en_SE/releases/download/v0.2.0/en_SE-v0.2.0.tar.gz | sudo tar xz -C /usr/share/i18n/locales/
sudo localedef -i en_SE -f UTF-8 en_SE.UTF-8
rpm-ostree override remove glibc-locale-source

cat > /usr/lib/systemd/system/lilyos-en_se.service <<EOF
[Unit]
Description=Set en_SE locale as default
After=rpm-ostreed.service
Before=systemd-user-sessions.service

[Service]
Type=oneshot
ExecStart=/usr/bin/env bash -c 'echo -e "LANG=en_SE.UTF-8\nLC_ALL=en_SE.UTF-8" > /etc/locale.conf'
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl enable lilyos-en_se.service