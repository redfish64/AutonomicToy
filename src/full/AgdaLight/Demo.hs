module AgdaLight.Demo where

import WhiteBoard
import AgdaLight.Types
import qualified Data.Text as T
import qualified Data.Text.IO as I
import Control.Monad.Reader

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


myActionFunc :: ALIMonad ()
myActionFunc = do
  (k,o) <- ask
  case k of
    (ALFileKey _) -> return ()
