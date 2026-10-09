module Core.Robot
    ( Robot, mkHuman, mkRandom, play
    ) where

import System.Random

import Core.Game

data Robot g = Robot
    { name   :: String
    , choose :: g -> IO (Move g, Robot g) }

instance Show (Robot g) where show r = show (name r)

mkHuman :: Game g => String -> Robot g
mkHuman name = robot where
    robot = Robot name choose
    choose g = do
        putStr "Your move? "; hFlush stdout
        let invalid = putStrLn "That move is invalid." >> choose g
        raw <- getLine
        maybe invalid pure do
            m <- parseMove g raw
            _ <- lookup m (nextMoves g)
            Just (m, robot)

mkRandom :: Game g => String -> IO (Robot g)
mkRandom name = newStdGen <&> mk where
    mk gen = Robot name (choose gen)
    choose gen g = do
        let mm = nextMoves g
        let (i,gen') = uniformR (0,length mm-1) gen
        let (m,_) = mm !! i
        pure (m, mk gen')

play :: Game g => g -> Robot g -> Robot g -> IO (Result g)
play g x o = out (Right g) >> loop x o g where
    out step = putStrLn (showStep g step) >> pure step
    loop x o g = do
        (m, x') <- choose x g
        let err = printf "ERROR: %s chose invalid move %s" (name x) (showMove g m)
        lookup m (nextMoves g) & maybe (err >> loop x o g) \s -> do
            printf "%s chooses %s.\n" (name x) (showMove g m)
            out s
            s & either pure (loop o x')
