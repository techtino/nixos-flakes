{
  description = "Your new nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";

    plasma-manager.url = "github:pjones/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.home-manager.follows = "home-manager";

    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs, sops-nix, home-manager,  ... }@inputs:
  let
    inherit (self) outputs;
    system = "x86_64-linux";
  in
  rec
  {
    nixosConfigurations = {
      techtino-vm = nixpkgs.lib.nixosSystem {
        inherit system;
	      specialArgs = { inherit inputs outputs; };
        modules = [
          ./common
          ./desktop-environment/kde
          ./device-type/vm
          sops-nix.nixosModules.sops
        ];
      };
      techtino-laptop = nixpkgs.lib.nixosSystem {
        inherit system;
	      specialArgs = { inherit inputs outputs; };
        modules = [
          ./common
          ./desktop-environment/hyprland
          ./device-type/laptop
          sops-nix.nixosModules.sops
          ./custom/disable-nvidia.nix
        ];
      };
    };
  };
}
