# Custom NixOS Flake for personal machines
This is my personal nixos flake which is used for reproducibly (and automatically) setting up my systems exactly as I want.

For each host configuration, you would include the common configs, as well as the config per device type (such as hardware options per device, like enabling bluetooth/wifi and power management etc). Any custom config per machines are stored in the custom directory, and can be trivially included. For instance for my laptop I have a custom script to disable it's nvidia gpu, but this isn't included in device-type/laptop because future laptops may not have nvidia gpus.

This also handles specific config per desktop environment, for instance kde plasma configuration via plasma-manager, and hyprland configs. This makes it trivial to switch desktop environment and override conflicting settings per desktop.
