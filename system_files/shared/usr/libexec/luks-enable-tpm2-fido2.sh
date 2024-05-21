#!/usr/bin/env bash
## setup auto-unlock LUKS2 encrypted root with FIDO2 backup on Fedora/Silverblue/maybe others
set -u

[ "$UID" -eq 0 ] || { echo "This script must be run as root."; exit 1;}

## Inspect crypttab to find disk info, should look like this
#sudo cat /etc/crypttab
#luks-912462a2-39ce-abcd-1234-89c6c0304cb4 UUID=912462a2-39ce-abcd-1234-89c6c0304cb4 none discard
DISK_UUID=$(sudo awk '{ print $2 }' /etc/crypttab | cut -d= -f2)
CRYPT_DISK="/dev/disk/by-uuid/$DISK_UUID"

## Backup the crypttab
if [ -f /etc/crypttab.known-good ]; then
  echo "Our backup already exists at /etc/crypttab.known-good\nExiting..."
  [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi
cp -a /etc/crypttab /etc/crypttab.known-good

## modify the crypttab
grep tpm2-device /etc/crypttab > /dev/null
if [ 0 -eq $? ]; then
  echo "TPM2 already present in /etc/crypttab. Exiting..."
  [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi
sed -i "s/discard/discard,tpm2-device=auto,fido2-device=auto/" /etc/crypttab

cryptsetup luksDump $CRYPT_DISK | grep systemd-tpm2 > /dev/null
if [ 0 -eq $? ]; then
  KEYSLOT=$(cryptsetup luksDump $CRYPT_DISK|grep -A23 systemd-tpm2|grep Keyslot|awk '{print $2}')
  echo "TPM2 already present in LUKS Keyslot $KEYSLOT of $CRYPT_DISK. Exiting..."
  [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi

## Run crypt enroll
echo "Enrolling unlock requires your existing LUKS2 unlock password"
echo
systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 $CRYPT_DISK
systemd-cryptenroll --fido2-device=auto --fido2-with-user-presence=yes --fido2-with-client-pin=yes  $CRYPT_DISK

## Update initramfs to respect tpm2 unlock
rpm-ostree initramfs |grep tpm2 > /dev/null
if [ 0 -eq $? ]; then
  echo "TPM2 already present in rpm-ostree initramfs config."
  rpm-ostree initramfs
  echo
  echo "Re-running initramfs to pickup changes above."
fi
rpm-ostree initramfs --enable --arg=--force-add --arg=tpm2-tss --arg=--force-add --arg=fido2

## Now reboot
echo
echo "TPM2 LUKS auto-unlock configured. Reboot now."


# References:
#  https://www.reddit.com/r/Fedora/comments/uo4ufq/any_way_to_get_systemdcryptenroll_working_on/
#  https://0pointer.net/blog/unlocking-luks2-volumes-with-tpm2-fido2-pkcs11-security-hardware-on-systemd-248.html