{ pkgs ? import <nixpkgs> {} }:

pkgs.callPackage ./st.nix {}
