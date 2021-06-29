{
  description = "A random assortment of Nix packages, NixOS and Home Manager modules that are useful for me";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    utils.url = "github:numtide/flake-utils";
    flake-compat.url = "github:edolstra/flake-compat";
  };

  outputs = { self, nixpkgs, utils, flake-compat, ... }:
  utils.lib.eachDefaultSystem (system:
  let
    pkgs = import nixpkgs { inherit system;};
  in
  {
    packages = {
      blesh = pkgs.callPackage ./blesh/blesh.nix {};
      st = pkgs.callPackage ./st/st.nix { patches = [];};
    };

    overlays = {
      st-patches = pkgs.callPackage ./st/st-patches.nix {};
      surf-patches = pkgs.callPackage ./surf/surf-patches-overlay.nix {};
    };

    nixosModules = {
      home-blesh = pkgs.callPackage ./blesh/home-blesh.nix {}; 
      home-st = pkgs.callPackage ./st/home-st.nix {};
      home-surf = pkgs.callPackage ./surf/home-surf {};
      autocutsel = pkgs.callPackage ./autocutsel.nix {};
      do-on-request = pkgs.callPackage ./do-on-request.nix {};
      scripts = pkgs.callPackage ./scripts.nix {};
    };
  });

}
