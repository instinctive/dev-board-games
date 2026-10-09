let G = ../generate.dhall

in  G.package "game-robot"
      [ G.library { srcDir = "src", modules = ["Game.Core.Robot"], deps = ["game-class", "random"] } ]
