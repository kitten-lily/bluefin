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
    sudo authselect enable-feature with-pam-u2f
