{-# LANGUAGE TypeFamilies #-}

module Core.Game
    ( Game, Move, Result, Step
    , nextMoves, parseMove, showMove, showStep
    ) where

type Step g = Either (Result g) g

class Eq (Move g) => Game g where
    type Move g
    type Result g
    nextMoves :: g -> [(Move g, Step g)]
    parseMove :: g -> String -> Maybe (Move g)
    showMove  :: g -> Move g -> String
    showStep  :: g -> Step g -> String
