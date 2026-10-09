module TTTImpl where

import Data.Array
import Data.List.Split (chunksOf)

data Player = X | O deriving (Eq,Show)

data Result = Win Player | Draw deriving Show

type Board = Array Int (Maybe Player)

data Game a = Game Board a deriving Show

type Turn = Game Player
type Done = Game Result
type Step = Either Done Turn

opp X = O
opp O = X

initGame = Game bd X where
    bd = listArray (1,9) (replicate 9 Nothing)

nextMoves (Game bd p) =
    [ (i, updateGame p (bd // [(i, Just p)]) )
    | (i, Nothing) <- assocs bd ]

updateGame p bd
    | any (all ((==Just p).(bd!))) threes = Left  $ Game bd (Win p)
    | all isJust (elems bd)               = Left  $ Game bd Draw
    | otherwise                           = Right $ Game bd (opp p)

threes = rows <> cols <> diags
rows = [[1..3],[4..6],[7..9]]
cols = transpose rows
diags = [[1,5,9],[3,5,7]]

showStep :: Step -> String
showStep = either showDone showTurn where
    showDone (Game bd r) = showBoard bd <> showResult r
    showTurn (Game bd p) = showBoard bd <> showPlayer p

showBoard bd = unlines $ intersperse "---+---+---"
  [ intercalate "|" (cell <$> row)
  | row <- chunksOf 3 (assocs bd) ]

cell (i,Nothing) = printf " %d " i
cell (i,Just p)  = printf " %s " (show p)

showPlayer p = printf "It is %s's turn." (show p)

showResult (Win p) = printf "%s has won!" (show p)
showResult Draw = "The game is a draw."
