# ArchConfig

My personal ArchLinux + Niri configuration for ASUS Vivobook 16.
<img width="1920" height="1200" alt="image" src="https://github.com/user-attachments/assets/f59a54e8-70b9-4c1f-b1d3-6e6db13833c7" />


## Installation

```bash
git clone git@github.com:niko091/ArchConfig.git ~/Projects/ArchConfig
cd ~/Projects/ArchConfig
./install.sh
```

## Touchpad gestures

Pinch inward with four fingers to toggle the DankMaterialShell application
launcher. Niri continues to handle its built-in swipe gestures.

To install or reapply the gesture on an existing setup:

```bash
bash ~/Projects/ArchConfig/setup-gestures.sh
```

This installs libinput-tools and libinput-gestures 2.80 (pinned upstream source),
grants the active local session access to touchpads via udev, and enables the
user service. It does not require membership in the input group.

Diagnostics: `journalctl --user -u libinput-gestures.service -b`.
Disable: `systemctl --user disable --now libinput-gestures.service`.
