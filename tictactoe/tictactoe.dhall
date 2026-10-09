let G = ../generate.dhall

in  G.package "tictactoe"
      [ G.library { srcDir = "src", modules = ["Game.TicTacToe"], deps = ["array", "split"] } ]
