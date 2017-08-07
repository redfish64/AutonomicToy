module WhiteBoard.Monitor where

--simple module implementing java style monitors in haskell

import Control.Concurrent.MVar
import Data.IORef
import Control.Concurrent
import Control.Monad

data Monitor = Monitor
    { monitorLock :: MVar ()
    , monitorCond :: MVar [MVar ()]
    }

-- | Repeatedly tests @b@ and runs @doit@ if false.
whileM :: IO Bool -> IO () -> IO ()
whileM cond body = doit
  where
    doit =
      do
        v <- cond
        if v then
          do body; doit
          else return ()
          

-- | Create a new monitor object, which contains the lock as
-- well as the queue of condition variables threads are waiting on.
newMonitor :: IO Monitor
newMonitor =
  do
    ml <- newMVar ()
    mc <- newMVar []
    
    return Monitor { monitorLock = ml, monitorCond = mc }

-- | Runs a computation within a monitor.
synchronized :: Monitor -> IO a -> IO a
synchronized m doit =
  do
    --take the monitor lock, so no one else can run, and then run our
    --IO
    takeMVar $ monitorLock m
    v <- doit
    putMVar (monitorLock m) ()
    return v
    
-- | Inside a 'synchronized' block, releases the lock and waits
-- to be notified
-- WARNING: MUST ONLY BE USED WITHIN A SYNCHRONIZED BLOCK
wait :: Monitor -> IO ()
wait m =
  do
    --create a new mvar for us to wait on
    myC <- newEmptyMVar

    --add that to the monitorCond list. Since we take the monitorCond first
    --we are guaranteed that no other thread can edit us (because they also take it)
    mc <- takeMVar $ monitorCond m
    putMVar (monitorCond m) $ myC : mc

    --release the synchronization lock (waits can only be within sychronized blocks
    putMVar (monitorLock m) ()

    --take our condition, which we set as empty. When a notify occurs, it
    --will put, which will wake us up so we can continue our thread
    takeMVar myC

    --now that we are done waiting, take the synchronization lock again to continue
    takeMVar (monitorLock m)

-- | Notifies the monitor that some conditions may have become true,
-- and wakes up one process.
notify :: Monitor -> IO ()
notify m =
  do
    mc <- takeMVar $ monitorCond m
    putStrLn $ "notify: mc length is "++(show $ length mc)
    case mc of
      [] -> putMVar (monitorCond m) mc -- no threads waiting, so just put the monitorCond back
      myC : mc ->  -- there are thread(s) waiting, so wake one up
        do
          putMVar myC () --wake up the waiting thread
          putMVar (monitorCond m) mc --take the waiting thread off the queue
   

---------------------------------------------------------------------
-- Example code:

data Account = Account {
    withdraw :: Int -> IO (),
    deposit :: Int -> IO ()
}

newAccount :: IO Account
newAccount = do
    m <- newMonitor
    balance <- newIORef 0
    return Account
            { withdraw = \n -> synchronized m $ do
                putStrLn ("Withdrawing " ++ show n)
                whileM (fmap (< n) $ readIORef balance) $ wait m
                curr <- readIORef balance
                writeIORef balance (curr - n)
                putStrLn "Withdrawal approved"
            , deposit = \n -> synchronized m $ do
                putStrLn ("Depositing " ++ show n)
                curr <- readIORef balance
                writeIORef balance (curr + n)
                notify m
            }

makeAccountWithPendingWithdrawal = do
    a <- newAccount
    makePendingWithdrawal a

makePendingWithdrawal a = do
    forkIO $ do
        withdraw a 20
    return a

_test =
  do
    a <- makeAccountWithPendingWithdrawal
    makePendingWithdrawal a
    makePendingWithdrawal a
    makePendingWithdrawal a
    makePendingWithdrawal a
    makePendingWithdrawal a
    deposit a 1
    deposit a 2
    deposit a 3
    deposit a 20
    deposit a 20
    deposit a 20
    deposit a 20
    deposit a 20
    deposit a 20
