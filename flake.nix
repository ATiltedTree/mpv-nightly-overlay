{
  description = "MPV nightly flake";

  inputs = {
    mpv-src = {
      url = "github:mpv-player/mpv";
      flake = false;
    };
    libplacebo-src = {
      url = "github:haasn/libplacebo";
      flake = false;
    };
    
  };

  outputs = { self, mpv-src, libplacebo-src }: let
    packageFor = pkgs: (pkgs.mpv-unwrapped.override {
      libplacebo = pkgs.libplacebo.overrideAttrs(old: {
        version = "9999";

        src = libplacebo-src;
      });
    }).overrideAttrs(old: {
      version = "9999";

      src = mpv-src;

      patches = [
        ./mpv-cycle.patch
      ];
    });
  in {
    overlays.default = final: prev: {
      mpv-unwrapped = packageFor prev;
    };
  };
}
