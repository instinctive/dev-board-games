{-# LANGUAGE TypeFamilies #-}

module Game.TicTacToe.Instance (initGame) where

import Game.Core.Game
import qualified Game.TicTacToe as Impl

newtype TTTGame = TTTGame { unWrap :: Impl.Turn }

instance Game TTTGame where
    type Move   TTTGame = Int
    type Result TTTGame = Impl.Done
    nextMoves (TTTGame g) = second (fmap TTTGame) <$> Impl.nextMoves g
    parseMove _ x = readMaybe @Int x
    showMove  _ m = show m
    showStep  _ s = Impl.showStep (unWrap <$> s)

initGame = TTTGame Impl.initGame
