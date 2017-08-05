module WhiteBoard.Core where

import WhiteBoard.Types
import Data.TCache


-- | Adds objects that will remain in the system until later deleted
-- using removeAnchorObjects Any other object will only exist as long
-- as another objects action method stores it. So, anchor objects are
-- special, that way.
addAnchorObjects :: WBObj x => WhiteBoard -> [x] -> IO ()
addAnchorObjects wb items =  undefined
  atomically $ do
    wbd <- readDBRef wb
    return ()
  --   mapM updateItem items
  -- where
  --   updateItem :: WBObj x => x -> STM ()
  --   updateItem o =
  --     do
  --       so <- readDBRef (key o)
  --       if (so == o) then return () else
  --         writeDBRef (DBRef o) o
          
    
                         

modifyObject :: WBObj x => ((Maybe x) -> x) -> WBMonad ()
modifyObject = undefined

storeObject :: WBObj x => x -> WBMonad ()
storeObject = undefined --TODO 1.5 keys should be based on object type, so Error {key="foo"} shoudl be different from Sym {key="foo"}

logMsg :: Show x => x -> WBMonad ()
logMsg = undefined
