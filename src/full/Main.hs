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
import Control.Monad.Reader
import System.IO

main :: IO ()
main =
  do
    argsStr <- getArgs
    _test argsStr
    return ()

_test :: [String] -> IO (WBConf ALKey ALObj)
_test argsStr =
  do
    contentsArray <- mapM I.readFile argsStr
    wbc <- createWBConf myActionFunc
    let objsToAdd = (zip (fmap ALFileKey argsStr)
                       (fmap (\(fn,fc) -> ALFile fn fc) (zip argsStr contentsArray)))

    putStrLn $ "objsToAdd: "++(show objsToAdd)

    startWhiteBoard wbc

    runWBMonad wbc $ addAnchorObjects objsToAdd
    finishWhiteBoard wbc

    return wbc
    

