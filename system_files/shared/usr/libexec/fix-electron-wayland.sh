#!/usr/bin/bash

# Make some electron flatpak apps run in wayland mode.
function fix_electron_wayland () {
  desktop_file="/var/lib/flatpak/app/$1/current/active/export/share/applications/$1.desktop"
  if [[ -f $desktop_file ]]; then
    sed -i "s/$2/$3/" $desktop_file 
  fi
}
fix_electron_wayland "com.axosoft.GitKraken" "GitKraken @@u" "GitKraken --ozone-platform-hint=auto --enable-features=WaylandWindowDecorations @@u"
