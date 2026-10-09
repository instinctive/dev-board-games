let G = ../generate.dhall

in  G.package "tictactoe-game"
      [ G.library { srcDir = "src", modules = ["Game.TicTacToe.Instance"], deps = ["game-class", "tictactoe"] } ]
