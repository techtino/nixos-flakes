{
  description = "Your new nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";
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
    };
  };
}
