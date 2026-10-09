let
  # Pin nixpkgs to a specific release commit that is guaranteed to be cached
  #
  #     $ nix-instantiate --eval -E '(import <nixpkgs> {}).lib.version'
  #     "26.05.11045.774debe7a0d1"
  #
  # The last part after the '.' is the commit hash.
  nixpkgsRev = "774debe7a0d1"; # or a specific 40-character commit hash
  pkgs = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/${nixpkgsRev}.tar.gz") {};

  myHaskellPackages = pkgs.haskellPackages.extend (
    pkgs.haskell.lib.compose.packageSourceOverrides {
      game-class     = ./game-class;
      game-robot     = ./game-robot;
      tictactoe      = ./tictactoe;
      tictactoe-game = ./tictactoe-game;
      games-app      = ./games-app;
    }
  );

in
myHaskellPackages.shellFor {
  packages = p: [
    p.game-class
    p.game-robot
    p.tictactoe
    p.tictactoe-game
    p.games-app
  ];

  # Set withHoogle to false temporarily if documentation generation causes rebuilds
  withHoogle = false;

  buildInputs = [
    pkgs.cabal-install
    pkgs.ghcid
    # myHaskellPackages.haskell-language-server
  ];

  # Instruct cabal to use Nix's package environment automatically
  shellHook = ''
    export CABAL_DIR="$PWD/.cabal"
  '';
}
