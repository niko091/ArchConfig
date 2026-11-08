#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "Run this helper as root." >&2
    exit 1
fi

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
pacman -S --needed --noconfirm libinput-tools python-dbus python-gobject
install -Dm644 "$script_dir/70-touchpad-gestures.rules" /etc/udev/rules.d/70-touchpad-gestures.rules
udevadm control --reload-rules
udevadm trigger --subsystem-match=input --property-match=ID_INPUT_TOUCHPAD=1 --action=change
udevadm settle
