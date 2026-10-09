let G = ../generate.dhall

in  G.package "games-app"
      [ G.executable "games" { srcDir = "app", mainIs = "Main.hs", deps = ["game-robot", "tictactoe-game"] } ]
