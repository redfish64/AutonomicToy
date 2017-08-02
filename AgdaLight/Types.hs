module Types where

import Data.Text
import Data.Map.Strict

data File = File
  {
    contents :: Text
  }

data DirData = DirData
  {
    refs :: [ Obj ],
    revRefs :: [ Obj ]
  }

data Directory = Directory
  {
    objToDD :: Map Obj DirData
  }

data Sym = Sym
  {
    name :: Text,
    mod :: Text --module
  }

data FileRange = FileRange
  {
    srow :: Int,
    scol :: Int,
    erow :: Int,
    ecol :: Int
  }

data Obj = S Sym | FR FileRange 

class ALMonad v where
  
