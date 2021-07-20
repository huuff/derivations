{
  description = "A random assortment of Nix packages, NixOS and Home Manager modules that are useful for me";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, utils, flake-compat, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system;};
  in with pkgs;
  {
    packages.${system} = {
      blesh = callPackage ./packages/blesh.nix {};
      st = callPackage ./packages/st.nix {};
    };

    overlays = {
      tmux-plugins = import ./overlays/tmux-plugins.nix;
      st = import ./overlays/st-overlay.nix;
      surfPatches = import ./overlays/surf-patches.nix;
    };

    nixosModules = {
      # Home Manager modules
      home-blesh = import ./home-manager-modules/home-blesh.nix; 
      home-st = import ./home-manager-modules/home-st.nix;
      home-surf = import ./surf/home-surf.nix;
      autocutsel = import ./home-manager-modules/autocutsel.nix;
      scripts = import ./home-manager-modules/scripts.nix;
      maven = import ./home-manager-modules/maven.nix;
      mycli = import ./home-manager-modules/mycli.nix;
      thefuck = import ./home-manager-modules/thefuck.nix;

      # NixOS modules
      do-on-request = import ./nixos-modules/do-on-request.nix;
      auto-rsync = import ./nixos-modules/auto-rsync.nix;
      neuron-module = import ./nixos-modules/neuron-module.nix;
    };
  };

}
