{ inputs, config, pkgs, ... }:
let
  swayConfig = pkgs.writeText "greetd-sway-config" ''
    # `-l` activates layer-shell mode. Notice that `swaymsg exit` will run after gtkgreet.
    exec dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK
    exec "${pkgs.greetd.gtkgreet}/bin/gtkgreet -l; swaymsg exit"
    bindsym Mod4+shift+e exec swaynag \
      -t warning \
      -m 'What do you want to do?' \
      -b 'Poweroff' 'systemctl poweroff' \
      -b 'Reboot' 'systemctl reboot'
  '';
in
{
    programs.hyprland.enable = true;
    
    environment.sessionVariables = {
        NIXOS_OZONE_WL="1";
    };
    security.pam.services.swaylock = {};

    environment.systemPackages = with pkgs; [
        (waybar.overrideAttrs (oldAttrs: {
            mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
            })
        )
	kitty
	mako
    swww
	swaylock-effects
	swayidle
	rofi-wayland
	brightnessctl
    ];

    services.greetd = {
        enable = true;
        settings = {
        default_session = {
            command = "${pkgs.sway}/bin/sway --config ${swayConfig}";
        };
        };
    };

    environment.etc."greetd/environments".text = ''
      Hyprland
    '';

    home-manager = {

        extraSpecialArgs = { inherit inputs; };
        sharedModules = [ inputs.hyprland.homeManagerModules.default ];

        users = {
            # Import your home-manager configuration
            techtino = {
                gtk.enable = true;
                gtk.theme.name = "adw-gtk3-dark";
                gtk.theme.package = pkgs.adw-gtk3;

                home.pointerCursor = {
                    package = pkgs.gnome.adwaita-icon-theme;
                    name = "Adwaita";
                    size = 38;
                };
            };
        };
    };
}

