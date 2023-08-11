{ inputs, config, pkgs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      # Import your home-manager configuration
      techtino = {
        gtk.enable = true;
        gtk.theme.name = "adw-gtk3";
        gtk.theme.package = pkgs.adw-gtk3;
        dconf.settings = {
          "org/gnome/desktop/wm/preferences" = {
            button-layout = "appmenu:minimize,maximize,close";
          };
          "org/gnome/desktop/wm/keybindings" = {
            close = "<Super>q";
          };
          "org/gnome/desktop/peripherals/touchpad" = {
            click-method = "areas";
          };
          "org/gnome/tweaks" = {
            show-extensions-notice = "false";
          };
	  "org/gnome/settings-daemon/plugins/media-keys" = {
	    www = "<Super>Return";
	  };
	  "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
            binding = "<Shift><Super>Return";
	    command = "kgx";
	    name = "Launch Terminal";
	  };
        };
        # Install basic gnome extensions, these are disabled and are user enableable for now only
        home.packages = with pkgs.gnomeExtensions; [
          gsconnect
          appindicator
          forge
        ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    gnome3.gnome-tweaks
    gnome-extension-manager
  ];


}
