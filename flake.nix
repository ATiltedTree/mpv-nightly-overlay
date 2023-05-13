{
  description = "MPV nightly flake";

  inputs = {
    systems.url = "github:nix-systems/default";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    mpv-src = {
      url = "github:mpv-player/mpv";
      flake = false;
    };
    libplacebo-src = {
      url = "github:haasn/libplacebo";
      flake = false;
    };
    
  };

  outputs = { self, systems, nixpkgs, mpv-src, libplacebo-src }:
    let
      eachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      packages = eachSystem (system: rec {
        libplacebo = nixpkgs.legacyPackages.${system}.libplacebo.overrideAttrs(old: {
          version = "9999";

          src = libplacebo-src;
        });
      
        mpv-unwrapped = (nixpkgs.legacyPackages.${system}.mpv-unwrapped.override {inherit libplacebo;}).overrideAttrs(old: {
          version = "9999";
        
          src = mpv-src;

          patches = [
            ./mpv-cycle.patch
          ];
        });
      });
    };
}
