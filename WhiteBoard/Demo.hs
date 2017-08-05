{-# LANGUAGE OverloadedStrings #-}
module WhiteBoard.Demo where

import WhiteBoard.Types as WT
import WhiteBoard.BasicActions
import Prelude as P
import Data.Text
import Data.Text.IO as I
import System.Environment (getArgs)

main :: IO ()
main =
  do
    wb <- openWhiteBoard 
    argsStr <- getArgs
    contentsArray <- mapM I.readFile argsStr
    addAnchorObjects wb (P.zipWith File argsStr contentsArray) 

data File = File {
  fp :: FilePath,
  contents :: Text
  } deriving (Show)

instance WBObj File where
  key x = [pack . fp $ x]
  action o = (parseFile (contents o))

parseFile :: Text -> WBMonad ()
parseFile txt = do
  case parseSyntax txt of
    Left errors -> mapM storeObject errors
    Right syms -> mapM storeObject syms
  return ()


parseSyntax :: Text -> Either [Error] [Sym]
parseSyntax = --undefined
  return Left [Error "foo"]


data Sym

instance WBObj Sym where
  key = undefined
  action = undefined

