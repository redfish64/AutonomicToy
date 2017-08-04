module WhiteBoard.Core where

import WhiteBoard.Types


openWhiteBoard :: FilePath -> IO WhiteBoard
openWhiteBoard fp =
  do
    acid <- openLocalStateFrom fp (WhiteBoardData)
    return $ WhiteBoard acid


addAnchorObjects :: WBObj x => WhiteBoard -> [x] -> IO ()
addAnchorObjects = undefined

storeObject :: WBObj x => x -> WBMonad ()
storeObject = undefined

logMsg :: Show x => x -> WBMonad ()
logMsg = undefined
