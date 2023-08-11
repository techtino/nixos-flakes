{ inputs, config, pkgs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.defaultSession = "plasmawayland";
  home-manager = {
    sharedModules = [ inputs.plasma-manager.homeManagerModules.plasma-manager ];
    extraSpecialArgs = { inherit inputs; };
    users = {
      # Import your home-manager configuration
      techtino = {
        home.stateVersion = "23.11";
	programs.plasma = {
          enable = true;
	  # Some high-level settings:
          workspace.clickItemTo = "select";

          hotkeys.commands."Launch Konsole" = {
            key = "Meta+Shift+Space";
            command = "konsole";
          };
	  configFile = {
	    "plasmashellrc"."PlasmaViews.Panel 2"."floating" = 1;
	    "kwinrc"."TabBox"."LayoutName" = "thumbnail_grid";
	    "ksmserverrc"."General"."confirmLogout" = false;
            "kcminputrc"."Libinput.1267.12419.ETD2303:00 04F3:3083 Touchpad"."NaturalScroll" = true;
            "kcminputrc"."Libinput.1267.12419.ETD2303:00 04F3:3083 Touchpad"."TapToClick" = true;
	  };
	};
	gtk.enable = true;
        gtk.theme.name = "Breeze";
      };
    };
  };
  environment.systemPackages = with pkgs; [
    libsForQt5.discover
  ];
}
