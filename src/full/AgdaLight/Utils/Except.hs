{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE CPP #-}

------------------------------------------------------------------------------
-- | Wrapper for Control.Monad.Except from the mtl package
------------------------------------------------------------------------------

module AgdaLight.Utils.Except
  ( 
    ExceptT
  , mkExceptT
  , MonadError(catchError, throwError)
  , runExceptT
  , mapExceptT
  ) where

------------------------------------------------------------------------
-- New mtl, reexport ExceptT, define class Error for backward compat.
------------------------------------------------------------------------

import Control.Monad.Except

-- | We cannot define data constructors synonymous, so we define the
-- @mkExceptT@ function to be used instead of the data constructor
-- @ExceptT@.
mkExceptT :: m (Either e a) -> ExceptT e m a
mkExceptT = ExceptT

