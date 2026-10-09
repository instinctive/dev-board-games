module Main where

import Core.Robot
import TTTGame

main = do
    args <- getArgs
    case args of
        [one,two] -> do
            x <- mkRobot one
            o <- mkRobot two
            void $ play initGame x o
        _ -> usage

usage = do
    putStrLn "usage: ttt name[/r] name[/r]"

mkRobot name
    | null prefix || suffix /= "/r" = pure (mkHuman name)
    | otherwise = mkRandom prefix
  where
    prefix = takeWhile (/='/') name
    suffix = dropWhile (/='/') name

