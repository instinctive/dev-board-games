let G = ../generate.dhall

in  G.package "game-class"
      [ G.library { srcDir = "src", modules = ["Game.Core.Game"], deps = [] : List Text } ]
