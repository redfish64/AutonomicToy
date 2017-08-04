{-# LANGUAGE ExistentialQuantification #-}

import Data.Text
import Data.Map.Strict
import Data.Acid
import Data.Typeable

data Elem = forall e. C e => Elem e

type HMap = Map Int Elemmodule WhiteBoard.Types where

data WBMonad x

instance Functor WBMonad where
  --fmap :: Functor f => (a -> b) -> f a -> f b
  fmap = undefined

instance Applicative WBMonad where
  pure = undefined
  (<*>) = undefined
  
instance Monad WBMonad where
  (>>=) = undefined
  
data WhiteBoard = WhiteBoard {
  acid :: AcidState WhiteBoardData
  }


data WhiteBoardData = WhiteBoardData {
  idToObj :: Map Key (WBObj x)
  --queue of work
  } deriving (Typeable)


type Key = Text  
  
class Typeable v => WBObj v where
  key :: v -> Key
  action :: v -> WBMonad ()
