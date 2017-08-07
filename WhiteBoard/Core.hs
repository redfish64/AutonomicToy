module WhiteBoard.Core(createWBConf,addAnchorObjects,storeObject,loadObject,startWhiteBoard,finishWhiteBoard) where

import WhiteBoard.Types as WT
import Data.TCache
import Data.Typeable
import Data.TCache
import Data.TCache.DefaultPersistence
import Data.Sequence as S(Seq,empty, (><),fromList)
import Control.Monad.Reader
import qualified Data.ByteString.Lazy.Char8 as BL(pack,unpack,ByteString(..))
import qualified Data.ByteString as B(pack,unpack,ByteString(..))

--TODO 3 choosable file directory?
-- | Opens a whiteboard. If the whiteboard doesn't exist already, it will be created empty.
createWBConf :: (Keyable k) => (k -> WBMonad k ()) -> IO (WBConf k)
createWBConf keyToActionFunc = 
  atomically $
  do
    ref <- newDBRef (WhiteBoard { queue = S.empty })
    return $ WBConf { keyToAction = keyToActionFunc,
                    wbRef = ref }



-- | Adds objects that will remain in the system until later deleted
-- using removeAnchorObjects Any other object will only exist as long
-- as another objects action method stores it. So, anchor objects are
-- special, that way.
addAnchorObjects :: (Keyable kt) => [(kt,BL.ByteString)] -> WBMonad kt ()
addAnchorObjects kv =
  let ko = fmap (\(k,v) -> (k,Valid v)) kv
  in
    do
      wbr <- getWBRef
      lift $ atomically $
        do
          --save off the items
          updatedKeys <- saveItems ko
          addDirtyItems wbr updatedKeys
  where
    --saves a list of items, returning the keys of the objects that are dirty
    saveItems :: (Keyable kt) => [(kt, Obj)] -> STM [kt]
    saveItems items = foldM
      (\l i -> 
         do
           mom <- saveItem i
           case mom of
             Nothing -> return l
             Just om -> return $ (WT.key om) : l
      ) [] items
    --saves an individual item. Returns true if dirty
    saveItem :: (Keyable kt) => (kt, Obj) -> STM (Maybe (ObjMeta kt))
    saveItem (k, o) =
      do
        let ref = getDBRef (show k)-- :: DBRef (ObjMeta kt))

        --look for an existing object
        mmo <- readDBRef ref -- :: STM (Maybe (ObjMeta kt)))
        case mmo of
          --object doesn't exist so create a new one and save it
          Nothing -> 
            fmap Just (writeObj ref (ObjMeta {WT.key=k, obj=o,
                                              referersKeys = [],
                                              referers = Nothing,
                                              storedObjsKeys = [],
                                              storedObjs = Nothing}))
                                             
          Just om@(ObjMeta { obj=existingObj }) -> 
            if existingObj == o
            then return Nothing  -- object hasn't changed, so not dirty
            else
              fmap Just $ writeObj ref (updateObjMetaForObj om o)  --object has changed, so update and save it
            
    writeObj :: (Keyable kt) => DBRef (ObjMeta kt) -> (ObjMeta kt) -> STM (ObjMeta kt)
    writeObj ref om =
      do
        writeDBRef ref om
        return om
        

    updateObjMetaForObj :: ObjMeta kt -> Obj -> ObjMeta kt
    updateObjMetaForObj om o = om { obj = o }
                     

getWBRef :: WBMonad kt (DBRef (WhiteBoard kt))
getWBRef = ask >>= return . wbRef

readDBRef' :: (Indexable x, Typeable x, Serializable x) => DBRef x -> STM x
readDBRef' dbr =
  do
    (Just v) <- readDBRef dbr
    return v
    
  

addDirtyItems :: (Keyable kt) => DBRef (WhiteBoard kt) -> [kt] -> STM ()
addDirtyItems wbr items =
  do
    wb <- readDBRef' wbr
    writeDBRef wbr $ wb { queue = (queue wb) >< fromList items }
    -- mapM newDBRef items
    -- addToDirtyQueue wbd items
    -- return ()


-- addToDirtyQueue :: (Serializable k, Eq k, Typeable k) => WhiteBoardData k -> [ObjMeta k] -> IO ()
-- modifyObject :: ((Maybe x) -> x) -> WBMonad ()
-- modifyObject = undefined


storeObject :: ObjMeta k -> WBMonad k ()
storeObject = undefined

loadObject :: k -> WBMonad k ()
loadObject = undefined

-- TODO PERF 3 we need to think about cache and how to deal with removal
-- the below "defaultCheck" will clear items from the cache once they exceed cache size
-- it will clean all elements that haven't been referenced in half the frequency
--TODO 2 make frequency and cacheSize parameters (or in WBConf)
-- | starts the whiteboard background threads
startWhiteBoard :: (Keyable k) => WBConf k -> IO ()
startWhiteBoard wbc = do
  syncWrite (Asyncronous {frecuency = 5, check = defaultCheck, cacheSize=100})
  

-- | saves the cache to the database
finishWhiteBoard :: IO ()
finishWhiteBoard = syncCache

-- | thread for running tasks in the dirty queue
dirtyQueueThread :: (Keyable k) => WBMonad k ()
dirtyQueueThread = undefined

    
  
