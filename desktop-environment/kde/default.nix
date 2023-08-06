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
	};
      };
    };
  };
}
