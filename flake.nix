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
      blesh = callPackage ./blesh/blesh.nix {};
      st = callPackage ./st/st.nix {};
    };

    overlays = {
      tmux-plugins = import ./tmux-plugins.nix {tmuxPlugins = pkgs.tmuxPlugins;};
    };

    nixosModules = {
      # Home Manager modules
      home-blesh = import ./blesh/home-blesh.nix; 
      home-st = import ./st/home-st.nix;
      home-surf = import ./surf/home-surf.nix;
      autocutsel = import ./autocutsel.nix;
      scripts = import ./scripts.nix;

      # NixOS modules
      do-on-request = import ./do-on-request.nix;
      auto-rsync = import ./auto-rsync.nix;
      neuron-module = import ./neuron-module.nix;
    };
  };

}
