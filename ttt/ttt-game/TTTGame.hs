{-# LANGUAGE TypeFamilies #-}

module TTTGame (initGame) where

import Core.Game
import qualified TTTImpl as Impl

newtype TTTGame = TTTGame { unWrap :: Impl.Turn }

instance Game TTTGame where
    type Move   TTTGame = Int
    type Result TTTGame = Impl.Done
    nextMoves (TTTGame g) = second (fmap TTTGame) <$> Impl.nextMoves g
    parseMove _ x = readMaybe @Int x
    showMove  _ m = show m
    showStep  _ s = Impl.showStep (unWrap <$> s)

initGame = TTTGame Impl.initGame
