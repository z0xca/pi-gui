{
  description = "Nix packaging for the pi-gui desktop app";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      systems = [ "x86_64-linux" ];
    in
    {
      packages = nixpkgs.lib.genAttrs systems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          pi-gui = pkgs.callPackage ./package.nix { };
        in
        {
          inherit pi-gui;
          default = pi-gui;
        }
      );
    };
}
