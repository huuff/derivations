#{
  #scripts = import ./scripts.nix;
  #autocutsel = import ./autocutsel.nix;
  #blesh = import ./blesh/blesh.nix;
  #blesh-module = import ./blesh/home-blesh.nix;
#}
(import (
  let
    lock = builtins.fromJSON (builtins.readFile ./flake.lock);
  in fetchTarball {
    url = "https://github.com/edolstra/flake-compat/archive/${lock.nodes.flake-compat.locked.rev}.tar.gz";
    sha256 = lock.nodes.flake-compat.locked.narHash; }
) {
  src =  ./.;
}).defaultNix
