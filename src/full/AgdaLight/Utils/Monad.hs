{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE CPP #-}

module AgdaLight.Utils.Monad
    ( module AgdaLight.Utils.Monad
    , when, unless, MonadPlus(..)
    , (<$>), (<*>)
    , (<$)
#if MIN_VERSION_mtl(2,2,0)
    , Control.Monad.State.modify'
#endif
    )
    where

import Prelude             hiding (concat)
import Control.Monad       hiding (mapM, forM)
import Control.Monad.State
import Control.Monad.Writer
import Control.Applicative
import Data.Traversable as Trav hiding (for, sequence)
import Data.Foldable as Fold
import Data.Maybe

import AgdaLight.Utils.Except
  ( MonadError(catchError, throwError)
  )

import AgdaLight.Utils.List

#include "undefined.h"
import AgdaLight.Utils.Impossible

-- | Binary bind.
(==<<) :: Monad m => (a -> b -> m c) -> (m a, m b) -> m c
k ==<< (ma, mb) = ma >>= \ a -> k a =<< mb

-- Conditionals and monads ------------------------------------------------

whenM :: Monad m => m Bool -> m () -> m ()
whenM c m = c >>= (`when` m)

unlessM :: Monad m => m Bool -> m () -> m ()
unlessM c m = c >>= (`unless` m)

-- | Monadic guard.
guardM :: (Monad m, MonadPlus m) => m Bool -> m ()
guardM c = guard =<< c

-- | Monadic if-then-else.
ifM :: Monad m => m Bool -> m a -> m a -> m a
ifM c m m' =
    do  b <- c
        if b then m else m'

-- | @ifNotM mc = ifM (not <$> mc)@
ifNotM :: Monad m => m Bool -> m a -> m a -> m a
ifNotM c = flip $ ifM c

-- | Lazy monadic conjunction.
and2M :: Monad m => m Bool -> m Bool -> m Bool
and2M ma mb = ifM ma mb (return False)

andM :: (Foldable f, Monad m) => f (m Bool) -> m Bool
andM = Fold.foldl and2M (return True)

allM :: (Functor f, Foldable f, Monad m) => f a -> (a -> m Bool) -> m Bool
allM xs f = andM $ fmap f xs

-- | Lazy monadic disjunction.
or2M :: Monad m => m Bool -> m Bool -> m Bool
or2M ma mb = ifM ma (return True) mb

orM :: (Foldable f, Monad m) => f (m Bool) -> m Bool
orM = Fold.foldl or2M (return False)

anyM :: (Functor f, Foldable f, Monad m) => f a -> (a -> m Bool) -> m Bool
anyM xs f = orM $ fmap f xs

-- | Lazy monadic disjunction with @Either@  truth values.
altM1 :: Monad m => (a -> m (Either err b)) -> [a] -> m (Either err b)
altM1 f []       = __IMPOSSIBLE__
altM1 f [a]      = f a
altM1 f (a : as) = either (const $ altM1 f as) (return . Right) =<< f a

-- Loops gathering results in a Monoid ------------------------------------

-- | Generalized version of @mapM_ :: Monad m => (a -> m ()) -> [a] -> m ()@
--   Executes effects and collects results in left-to-right order.
--   Works best with left-associative monoids.
--
--   Note that there is an alternative
--
--     @mapM' f t = foldr mappend mempty <$> mapM f t@
--
--   that collects results in right-to-left order
--   (effects still left-to-right).
--   It might be preferable for right associative monoids.
mapM' :: (Foldable t, Monad m, Monoid b) => (a -> m b) -> t a -> m b
mapM' f = Fold.foldl (\ mb a -> liftM2 mappend mb (f a)) (return mempty)

-- | Generalized version of @forM_ :: Monad m => [a] -> (a -> m ()) -> m ()@
forM' :: (Foldable t, Monad m, Monoid b) => t a -> (a -> m b) -> m b
forM' = flip mapM'

-- Continuation monad -----------------------------------------------------

type Cont r a = (a -> r) -> r

-- | 'Control.Monad.mapM' for the continuation monad. Terribly useful.
thread :: (a -> Cont r b) -> [a] -> Cont r [b]
thread f [] ret = ret []
thread f (x:xs) ret =
    f x $ \y -> thread f xs $ \ys -> ret (y:ys)

-- Lists and monads -------------------------------------------------------

-- | A monadic version of @'mapMaybe' :: (a -> Maybe b) -> [a] -> [b]@.
mapMaybeM
#if __GLASGOW_HASKELL__ <= 708
  :: (Functor m, Monad m)
#else
  :: Monad m
#endif
  => (a -> m (Maybe b)) -> [a] -> m [b]
mapMaybeM f xs = catMaybes <$> Trav.mapM f xs

-- | The @for@ version of 'mapMaybeM'.
forMaybeM
#if __GLASGOW_HASKELL__ <= 708
  :: (Functor m, Monad m)
#else
  :: Monad m
#endif
  => [a] -> (a -> m (Maybe b)) -> m [b]
forMaybeM = flip mapMaybeM

-- | A monadic version of @'dropWhile' :: (a -> Bool) -> [a] -> [a]@.
dropWhileM :: Monad m => (a -> m Bool) -> [a] -> m [a]
dropWhileM p []       = return []
dropWhileM p (x : xs) = ifM (p x) (dropWhileM p xs) (return (x : xs))

-- | A ``monadic'' version of @'partition' :: (a -> Bool) -> [a] -> ([a],[a])
partitionM :: (Functor m, Applicative m) => (a -> m Bool) -> [a] -> m ([a],[a])
partitionM f [] =
  pure ([], [])
partitionM f (x:xs) =
  (\ b (l, r) -> if b then (x:l, r) else (l, x:r)) <$> f x <*> partitionM f xs

-- Error monad ------------------------------------------------------------

-- | Finally for the 'Error' class. Errors in the finally part take
-- precedence over prior errors.

finally :: MonadError e m => m a -> m () -> m a
first `finally` after = do
  r <- catchError (liftM Right first) (return . Left)
  after
  case r of
    Left e  -> throwError e
    Right r -> return r

-- | Try a computation, return 'Nothing' if an 'Error' occurs.

tryMaybe :: (MonadError e m, Functor m) => m a -> m (Maybe a)
tryMaybe m = (Just <$> m) `catchError` \ _ -> return Nothing

-- State monad ------------------------------------------------------------

-- | Bracket without failure.  Typically used to preserve state.
bracket_ :: Monad m
         => m a         -- ^ Acquires resource. Run first.
         -> (a -> m ())  -- ^ Releases resource. Run last.
         -> m b         -- ^ Computes result. Run in-between.
         -> m b
bracket_ acquire release compute = do
  resource <- acquire
  result <- compute
  release resource
  return result

-- | Restore state after computation.
localState :: MonadState s m => m a -> m a
localState = bracket_ get put

#if !MIN_VERSION_mtl(2,2,0)
modify' :: MonadState s m => (s -> s) -> m ()
modify' f = do
  x <- get
  put $! f x
#endif

-- Read -------------------------------------------------------------------

--TODO 2 we switched to String, is this ok?
--  originally, used something called strMsg which is defined with infinite recursiion
--  in Except.hs
readM :: (MonadError String m, Read a) => String -> m a
readM s = case reads s of
            [(x,"")]    -> return x
            _           ->
              throwError $ "readM: parse error string " ++ s


