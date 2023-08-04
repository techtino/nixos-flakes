{ inputs, config, pkgs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.defaultSession = "plasmawayland";
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      # Import your home-manager configuration
      techtino = {
        home.stateVersion = "23.11";
	programs = {
            neovim = {
              enable = true;
              viAlias = true;
              vimAlias = true;
              vimdiffAlias = true;
           };
        };
      };
    };
  };
}
