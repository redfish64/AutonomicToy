{-# LANGUAGE OverloadedStrings #-}
module Main where

import WhiteBoard.Types as WT
import WhiteBoard.Core as C
import Prelude
import qualified Data.Text as T
import qualified Data.Text.IO as I
import System.Environment (getArgs)
import qualified Data.ByteString.Lazy.Char8 as BL(pack,unpack,ByteString(..))
import Data.TCache.Defs(Serializable(..))
import Control.Concurrent

main :: IO ()
main =
  do
    argsStr <- getArgs
    contentsArray <- mapM I.readFile argsStr
    wbc <- createWBConf keyToActionFunc
    startWhiteBoard wbc
    runWBMonad wbc $ addAnchorObjects (zip (fmap KFile argsStr)
                                       (fmap File contentsArray))
    finishWhiteBoard

data File = File {
  contents :: T.Text
  } deriving (Show, Read, Eq)

instance Serializable File where
  serialize= BL.pack . show
  deserialize= read . BL.unpack

instance WBObj File 

data Key = KFile FilePath deriving (Show, Read, Eq)

instance Serializable Key where
  serialize= BL.pack . show
  deserialize= read . BL.unpack
  
instance Keyable Key where

keyToActionFunc :: Key -> WBMonad Key ()
keyToActionFunc (KFile _) = return ()


-- instance WBObj File where
--   key x = [pack . fp $ x]
--   action o = (parseFile (contents o))

-- parseFile :: Text -> WBMonad ()
-- parseFile txt = do
--   case parseSyntax txt of
--     Left errors -> mapM storeObject errors
--     Right syms -> mapM storeObject syms
--   return ()


-- parseSyntax :: Text -> Either [Error] [Sym]
-- parseSyntax = --undefined
--   return Left [Error "foo"]


-- data Sym

-- instance WBObj Sym where
--   key = undefined
--   action = undefined

