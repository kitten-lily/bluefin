# vim: set ft=make :
########################
### lily-auth.just
########################
## Standardized verbs
# configure- = configure something that is pre-installed on the image
# install-   = install something, no uninstall or configuration provided
# setup-     = install something and also provide configuration and/or uninstallation options
# toggle-    = turn something on/off, logic can be automatic or manual selection
# fix-       = apply fix/patch/workaround for something
# foo        = no verb is used for shortcuts or something deemed important enough to use a super memorable name

# Configure fido2/u2f and enable authentication with it
configure-u2f-auth:
    #!/usr/bin/env bash
    set -euo pipefail
    mkdir -p ~/.config/Yubico
    pamu2fcfg > ~/.config/Yubico/u2f_keys

# Enable unlocking the system encryption with a fido2 key
configure-luks-fido2:
    sudo /usr/libexec/luks-enable-fido2.sh

# Enable unlocking the system encryption with both a tpm2 and fido2 as a fallback
configure-luks-tpm2-fido2:
    sudo /usr/libexec/luks-enable-tpm2-fido2.sh
