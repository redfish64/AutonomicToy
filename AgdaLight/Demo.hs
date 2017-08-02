{-# LANGUAGE OverloadedStrings #-}
module Demo where

import Prelude as P
import Data.Text
import Data.Text.IO as I
import System.Environment (getArgs)

main :: IO ()
main =
  do
    wb <- openWhiteBoard "whiteboard.data/"
    argsStr <- getArgs
    contentsArray <- mapM I.readFile argsStr
    addAnchorObjects wb (P.zipWith File argsStr contentsArray) 

openWhiteBoard :: FilePath -> IO WhiteBoard
openWhiteBoard = undefined


addAnchorObjects :: WBObj x => WhiteBoard -> [x] -> IO ()
addAnchorObjects = undefined

data File = File {
  fp :: FilePath,
  contents :: Text
  } deriving (Show)

instance WBObj File where
  key x = [pack . fp $ x]
  action o = (parseFile (contents o))

data WBMonad x

instance Functor WBMonad where
  --fmap :: Functor f => (a -> b) -> f a -> f b
  fmap = undefined

instance Applicative WBMonad where
  pure = undefined
  (<*>) = undefined
  
instance Monad WBMonad where
  (>>=) = undefined
  
data WhiteBoard

parseFile :: Text -> WBMonad ()
parseFile txt = do
  case parseSyntax txt of
    Left errors -> mapM storeObject errors
    Right syms -> mapM storeObject syms
  return ()


storeObject :: WBObj x => x -> WBMonad ()
storeObject = undefined

parseSyntax :: Text -> Either [Error] [Sym]
parseSyntax = undefined

logMsg :: Show x => x -> WBMonad ()
logMsg = undefined

data Error = Error {
  msg :: Text
  } deriving (Show)

instance WBObj Error where
  key e = ["Error",msg e]
  action e = showToUser e

showToUser :: (WBObj x, Show x) => x -> WBMonad ()
showToUser x = logMsg (show x)

data Sym

instance WBObj Sym where
  key = undefined
  action = undefined

class WBObj v where
  key :: v -> [Text]
  action :: v -> WBMonad ()
