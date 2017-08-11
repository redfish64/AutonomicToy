{-# LANGUAGE OverloadedStrings #-}
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
import WhiteBoard.Monitor
import Control.Concurrent.Chan.Unagi 
import Control.Monad.Loops
import Data.IORef
import Control.Concurrent.MVar
import Control.Concurrent (forkIO,threadDelay, ThreadId(..))
import Control.Monad.State

--TODO 3 choosable file directory?
-- | Opens a whiteboard. If the whiteboard doesn't exist already, it will be created empty.
createWBConf :: (Keyable k, WBObj o) => (WBIMonad k o ()) -> IO (WBConf k o)
createWBConf actionFunc =
  do
    wIR <- newIORef 0
    (ic,oc) <- newChan
    m <- newEmptyMVar
    atomically $
      do
        return $ WBConf { numWorkingThreads = 5, timeBetweenCommitsSecs = 60,
                          actionFunc = actionFunc,
                          inChan = ic, outChan = oc,
                          schedulerChannel = m}



-- | Adds objects that will remain in the system until later deleted
-- using removeAnchorObjects Any other object will only exist as long
-- as another objects action method stores it. So, anchor objects are
-- special, that way.
addAnchorObjects :: (WBObj obj, Keyable k) => [(k,obj)] -> WBMonad k obj ()
addAnchorObjects kv =
  -- TODO 1.5 we need to look at dealing with updating an anchor object when
  -- it already exists (error out), or when it is being refered to by other objects
  --  (put them in the dirty queue)
  let kp = fmap (\(k,v) -> (k,PValid v)) kv
  in
    do
      wbc <- ask
      updatedKeys <- lift $ atomically $
          --save off the items to the db
          saveItems kp
      --notify the scheduler to add the items to the dirty queue for processing
      lift $ addDirtyItems wbc updatedKeys
  where
    --saves a list of items, returning the keys of the objects that are dirty
    saveItems :: (WBObj obj, Keyable k) => [(k, Payload obj)] -> STM [k]
    saveItems items = foldM
      (\l i -> 
         do
           mom <- saveItem i
           case mom of
             Nothing -> return l
             Just om -> return $ (WT.key om) : l
      ) [] items
    --saves an individual item. Returns true if dirty
    saveItem :: (WBObj obj, Keyable k) => (k, Payload obj) -> STM (Maybe (ObjMeta k obj))
    saveItem (k, p) =
      do
        --TODO PERF 3 we may want to use a special method here so we get an abbr
        -- (faster) value for the key
        --TODO PERF 4 we may also want to consider modifying TCache to accept binary
        --keys rather than just strings
        let ref = getDBRef (show k) -- :: DBRef (ObjMeta kt))

        --look for an existing object
        mmo <- readDBRef ref -- :: STM (Maybe (ObjMeta kt)))
        case mmo of
          --object doesn't exist so create a new one and save it
          Nothing -> 
            fmap Just (writeObj ref (ObjMeta {WT.key=k, payload=p,
                                              refererKeys = [],
                                              referers = Nothing,
                                              storedObjKeys = [],
                                              storedObjs = Nothing}))
                                             
          Just om@(ObjMeta { payload=existingPayload }) -> 
            if existingPayload == p
            then return Nothing  -- object hasn't changed, so not dirty
            else
              fmap Just $ writeObj ref (updateObjMetaForPayload om p)  --object has changed, so update and save it

        --FIXME HACK
        return Nothing
            
    writeObj :: (WBObj o, Keyable k) => DBRef (ObjMeta k o) -> (ObjMeta k o) -> STM (ObjMeta k o)
    writeObj ref om =
      do
        writeDBRef ref om
        return om
        

    updateObjMetaForPayload :: ObjMeta k obj -> Payload obj -> ObjMeta k obj
    updateObjMetaForPayload om p = om { payload = p }


readDBRef' :: (Indexable x, Typeable x, Serializable x) => DBRef x -> STM x
readDBRef' dbr =
  do
    (Just v) <- readDBRef dbr
    return v
    

--TODO PERF 4 we may want to dump STM. There is no real need for it, because if we get
--a wrong answer, it doesn't matter, because we'd be given the correct elements and marked
--dirty later
  
-- Tells the scheduler thread there are dirty items. The scheduler thread will either add
-- them to the dirty queue 
addDirtyItems :: (Keyable k, WBObj o) => WBConf k o -> [k] -> IO ()
addDirtyItems wbc items = putMVar (schedulerChannel wbc) $ AddDirtyItems items
    
    -- mapM newDBRef items
    -- addToDirtyQueue wbd items
    -- return ()


-- addToDirtyQueue :: (Serializable k, Eq k, Typeable k) => WhiteBoardData k -> [ObjMeta k] -> IO ()
-- modifyObject :: ((Maybe x) -> x) -> WBMonad ()
-- modifyObject = undefined


getExistingOrEmptyObject :: (Keyable k, WBObj o) => k -> STM (ObjMeta k o)
getExistingOrEmptyObject k =
  do
    --get the existing object.. if it doesn't exist, create an empty one
    let eor = getDBRef (show k)
    meo <- readDBRef eor
    return $ maybe (ObjMeta {
                               WT.key = k,
                               payload = PEmpty,
                               refererKeys = [],
                               referers = Just [],
                               storedObjKeys = [],
                               storedObjs = Just []
                               }
                  ) 
              id meo

addToReferers :: (Keyable k, WBObj o) => k -> ObjMeta k o -> ObjMeta k o -> ObjMeta k o
addToReferers key obj om =
        om {
            refererKeys = key : (refererKeys om),
            referers = fmap (obj :) (referers om) 
            } -- (the happy line)

  

-- | used by keyToAction in WBConf to store an object. Key and object of stored object
--   is passed in and the result of the store is returned
storeObject :: (Keyable k, WBObj o) => k -> o -> WBIMonad k o StoreResult
storeObject k o =
  do
    (storerKey, storerObj) <- ask

    (shouldAddDirtyItems, eo) <- liftIO $ atomically $ do
      eo <- getExistingOrEmptyObject k
      --update object for this store action
      let no =
            (case (payload eo) of
                PEmpty -> eo { payload = PValid o }
                PMultipleStorers x -> eo { payload = PMultipleStorers (x+1) }
                PValid _ -> eo { payload = PMultipleStorers 2 })

      -- add storer as a referer. We do this because if there is some
      -- error such as multiple storers, each storer must be returned
      -- an error. So, whenever a new storer is added or one taken
      -- away, the other storers need to be rerun
      let no' = addToReferers storerKey storerObj no 

      return (isPayloadChangeSignificant (payload no') (payload eo), eo)

    if shouldAddDirtyItems then
      do
        wbc <- lift $ ask
        liftIO $ addDirtyItems wbc (refererKeys eo) -- note we use 'eo'(existing object) here
         -- because we don't want to rerun the current storer
      else return ()

    return $ getStoreResultForPayload (payload eo)
   where
      isPayloadChangeSignificant :: (Eq o) => Payload o -> Payload o -> Bool
      isPayloadChangeSignificant (PValid x) (PValid y) = x /= y
      isPayloadChangeSignificant (PValid _) _ = True
      isPayloadChangeSignificant (PMultipleStorers _) (PMultipleStorers _) = False
      isPayloadChangeSignificant (PMultipleStorers _) _ = True
      isPayloadChangeSignificant PEmpty PEmpty = False
      isPayloadChangeSignificant PEmpty _ = True
      getStoreResultForPayload :: Payload o -> StoreResult
      getStoreResultForPayload (PValid _) = SRSuccess
      getStoreResultForPayload (PMultipleStorers _) = SRErrorMultStorers
      getStoreResultForPayload PEmpty = undefined -- should never happen
      

data StoreResult = SRSuccess | SRErrorMultStorers

                 
data LoadResult o = LRSuccess o | LRErrorEmpty | LRErrorMultStorers

loadObject :: (Keyable k, WBObj o) => k -> WBIMonad k o (LoadResult o)
loadObject k =
  do
    (loaderKey, loaderObj) <- ask
    
    liftIO $ atomically $ do
      --get the existing object.. if it doesn't exist, create an empty one
      eo <- fmap (addToReferers loaderKey loaderObj) $ getExistingOrEmptyObject k

      return $ getLoadResultForPayload (payload eo)

  where
    getLoadResultForPayload :: Payload o -> LoadResult o
    getLoadResultForPayload (PValid x) = LRSuccess x
    getLoadResultForPayload (PMultipleStorers _) = LRErrorMultStorers
    getLoadResultForPayload PEmpty = LRErrorEmpty
    

-- TODO PERF 3 we need to think about cache and how to deal with removal
-- the below "defaultCheck" will clear items from the cache once they exceed cache size
-- it will clean all elements that haven't been referenced in half the frequency
--TODO 2 make frequency and cacheSize parameters (or in WBConf)
-- TODO 2.6 verify that TCache is behaving how we want when it synchronizes to disk
-- TODO 2.3 use different persist mechanism so that we can handle billions of entries
-- | starts the whiteboard background threads
startWhiteBoard :: (Keyable k, WBObj o) => WBConf k o -> IO ()
startWhiteBoard wbc = do
  forkIO $ runReaderT schedulerThread wbc
  replicateM (numWorkingThreads wbc) (forkIO $ (runReaderT workerThread wbc))
  return ()
             
  --TODO we will sync ourselves, so we can empty the dirty queue into a dbref
  

-- | saves the cache to the database
finishWhiteBoard :: WBConf k o -> IO ()
finishWhiteBoard _ = return ()
  



data STReadEventMode = STWorkingMode | STStoreToCacheMode


{- | The scheduler thread operates in the following states and state
   transitions:

     1. Working - worker threads process dirty items. All dirty items
     created by working threads or outside of the system (through
     anchor objects) go back into their input queue.

     ** transistion - when save timer goes off, or all threads stop
        working, we transition

     2. Preparing to save - All dirty items produced from anchor
     objects or worker threads is switched to an alternative list for
     saving to the db. Worker Thread input queue is drained into list
     for db.

     ** transistion - when all threads indicate they are paused, we
        move to stage 3

     3. Save - save the db list and all cached, modified items. Dump
     db list of dirty items back into processing queue for transition
     to stage 1. If there are no dirty items to process, wait for an
     item to come in before going back to stage 1 (so we don't busy
     loop endlessly)

   Adding of dirty items, the timer going off, and thread pauses are
   all handled by a single mvar which client threads write to and the
   scheduler thread reads. This way, there can be no race conditions,
   because if the sceduler thread is handling one event, it can't
   receive another while its working that would confuse it.
 -}
schedulerThread :: (Keyable k, WBObj o) => WBMonad k o ()
schedulerThread =
  do
    --start in mode 1
    mode1Prep
    return ()
  where
    readEvent :: WBMonad k o (SchedulerEvent k)
    readEvent = do
      wbc <- ask
      liftIO $ takeMVar (schedulerChannel wbc)

    mode1Prep :: (Keyable k) => WBMonad k o ()
    mode1Prep =
      do
        liftIO $ putStrLn "mode1Prep"
        wakeUpOnTimer
        runStateT mode1 0 -- all worker threads start up in processing mode,
        --so there are 0 threads asleep
        return ()

    --working mode
    mode1 :: (Keyable k) => StateT Int (WBMonad k o) ()
    mode1 =
      do
        liftIO $ putStrLn "mode1"
        wbc <- ask

        --read the next event
        event <- lift $ readEvent
        liftIO $ putStrLn $ "readEvent " ++ (show event)
        case (event) of
          SEThreadWaiting ->
            do
              modify (+1)
              threadsWaiting <- get
              ce <- liftIO $ isChanEmpty $ outChan wbc
              liftIO $ putStrLn $ "threadsWaiting: "++(show threadsWaiting) ++
                    ", channelEmpty: " ++ (show ce)
              if threadsWaiting == (numWorkingThreads wbc) && ce then
                do
                  --no threads are processing and the queue is empty, work is done
                  --go to mode 2
                  mode2Prep 
               else
                mode1
          SEThreadWorking -> modify pred >> mode1
          SETimerWentOff -> mode2Prep --when the timer goes off, we need to do a save of our partially completed work and then continue
          AddDirtyItems ks -> do
            liftIO $ writeList2Chan (inChan wbc) ks --write to the input queue so the workers can get started
            mode1
            
    --prepare to save to cache
    mode2Prep :: (Keyable k) => StateT Int (WBMonad k o) ()
    mode2Prep =
      do
        liftIO $ putStrLn "mode2Prep"
        wbc <- ask

        --empty queue of dirty items so threads stop quicker
        dirtyItems <- whileMToList (fmap not (liftIO $ isChanEmpty $ outChan wbc)) (liftIO $ readChan (outChan wbc))
        threadsWaiting <- get
        lift $ runStateT mode2 (dirtyItems, threadsWaiting)
        return ()
    mode2 :: (Keyable k) => StateT ([k],Int) (WBMonad k o) ()
    mode2 =
      do 
        liftIO $ putStrLn "mode2"
        wbc <- ask
        event <- lift $ readEvent
        
        case (event) of
          SEThreadWaiting ->
            do
              --add to the thread waiting count
              modify (\(di,tw) -> (di,tw+1))
              (dl,tw) <- get
              ce <- liftIO $ isChanEmpty $ outChan wbc
              if tw == (numWorkingThreads wbc) && ce then
                lift $ mode3 dl
                else
                mode2
          SEThreadWorking -> modify (\(di,tw) -> (di,tw-1)) >> mode2
          SETimerWentOff -> mode2
          AddDirtyItems ks ->
            do
              modify (\(cks,tw) -> (ks ++ cks,tw))
              mode2
    --TODO 3 consider that in AN, we'll may have the need to commit some data
    --directly to the disk as soon as it's received for less volatility... not sure
    --about this. 
    mode3 :: (Keyable k) => [k] -> WBMonad k o ()
    mode3 keys = do
      liftIO $ putStrLn "mode3"
      --save the entire cache as a single transaction (so that if there is a power failure,
      --we either commit all or none)
      lift $ atomically $ do
        --we need to save off the new set of dirty keys
        
        --note that any previous set of dirty keys is discarded.
        --This is because when we start up, we copy all the dirty keys into
        --the processing queue, and so they will all be cleared anyway.
        ref <- newDBRef $ DirtyQueue []
        writeDBRef ref $ DirtyQueue keys

      wbc <- ask
      
      --now that were done with the save, we get back to work
      if (isEmpty keys) then
        mode3Purgatory --there are no dirty items, so we wait until one comes in
        else
        do
          --write out the list to the active queue so the threads start processing
          liftIO $ writeList2Chan (inChan $ wbc) keys
          mode1Prep
          return ()
          

    --here, we wait until we get an item to process
    mode3Purgatory :: (Keyable k) => WBMonad k o ()
    mode3Purgatory = do
      liftIO $ putStrLn "mode3Purgatory"
      event <- readEvent

      case (event) of
        AddDirtyItems ks -> do
          wbc <- ask

          liftIO $ writeList2Chan (inChan wbc) ks --write to the input queue so the workers can get started
          runStateT mode1 0
          return ()
        _ -> mode3Purgatory


    --notify ourselves to wake up when we need to save the intermediate state
    wakeUpOnTimer :: (Keyable k) => WBMonad k o ()
    wakeUpOnTimer =
      do
        liftIO $ putStrLn "wakeUpOnTimer"
        wbc <- ask
        lift $ startTimerThread (timeBetweenCommitsSecs wbc * 1000 * 1000) $ 
          putMVar (schedulerChannel wbc) SETimerWentOff
        return ()


-- | returns true if the channel is empty
isChanEmpty :: OutChan x -> IO Bool
isChanEmpty c = getChanContents c >>= return . isEmpty

isEmpty :: [x] -> Bool
isEmpty [] = True
isEmpty _ = False


--starts a single event timer thread
startTimerThread :: Int -> IO () -> IO ThreadId
startTimerThread waitTimeMicroSecs actionToPerform =
  forkIO $ (threadDelay waitTimeMicroSecs >> actionToPerform)

-- | thread for running tasks in the dirty queue
workerThread :: (Keyable k, WBObj o) => WBMonad k o ()
workerThread =
  do
    iterateWhile isWorkingMode processItem
  where
    isWorkingMode :: () -> Bool
    isWorkingMode _ = True --TODO 1.5 we got to have a condition to
                           --stop the train to save to the disk!
    processItem :: (Keyable k, WBObj o) => WBMonad k o ()
    processItem =
      do
        wbc <- ask
        --check if the queue is empty and if it is, we notify the
        --whiteboard that we are not working.  if all worker threads
        --are all waiting and not working we know the job is done
        (elem,readItAgain) <- lift $ tryReadChan (outChan wbc)
        mkey <- lift $ tryRead elem

        key <- lift $ case mkey of
                         Nothing ->
                           do
                             --the queue is empty the last time we
                             --read it, so we tell the scheduler that we are waiting
                             putMVar (schedulerChannel wbc) SEThreadWaiting
                             
                             --now we read and block if its empty again
                             key <- readItAgain

                             --now that we are working again, we need
                             --to note this fact
                             putMVar (schedulerChannel wbc) SEThreadWorking

                             return key
                         Just key -> return key

        --get the object for the key
        (Just obj) <- (lift $ atomically $ readDBRef $ getDBRef (show key)) -- :: (Keyable k, WBObj o) => WBMonad k o (Maybe (ObjMeta k o))

        --use the key to create a task, and then run it
        runReaderT (actionFunc wbc) (key,obj)
