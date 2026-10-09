games/
├── cabal.project
├── shell.nix
├── generate.dhall                     -- shared cabal stanza + render functions
├── generate-cabal.sh                  -- regenerates .cabal from .dhall files
├── game-class/
│   ├── game-class.cabal
│   ├── game-class.dhall
│   └── src/Game/Core/Game.hs          -- class Game
├── game-robot/
│   ├── game-robot.cabal
│   ├── game-robot.dhall
│   └── src/Game/Core/Robot.hs         -- Robot type (player implementations)
├── tictactoe/
│   ├── tictactoe.cabal
│   ├── tictactoe.dhall
│   └── src/Game/TicTacToe.hs          -- pure implementation, no class dep
├── tictactoe-game/
│   ├── tictactoe-game.cabal
│   ├── tictactoe-game.dhall
│   └── src/Game/TicTacToe/Instance.hs -- newtype + instance
└── games-app/                         -- the executable
    ├── games-app.cabal
    ├── games-app.dhall
    └── app/Main.hs

Cabal files are generated from dhall. Edit the .dhall file, not the .cabal
file, then run `generate-cabal.sh` (or `dhall text --file <pkg>/<pkg>.dhall > <pkg>/<pkg>.cabal`).
