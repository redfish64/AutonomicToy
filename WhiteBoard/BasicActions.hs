module WhiteBoard.BasicActions where

import WhiteBoard.Types

-- actions and types for common scenarios

showToUser :: (WBObj x, Show x) => x -> WBMonad ()
showToUser x = logMsg (show x)

data Error = Error {
  msg :: Text
  } deriving (Show)

instance WBObj Error where
  key e = ["Error",msg e]
  action e = showToUser e


