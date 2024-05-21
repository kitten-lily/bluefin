#!/usr/bin/bash

set -ouex pipefail

if [[ "${BASE_IMAGE_NAME}" = "base" ]]; then
    # Set up display manager
    systemctl enable cosmic-greeter.service
fi
