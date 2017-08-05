{-# LANGUAGE OverloadedStrings #-}
module WhiteBoard.Types where

import Data.Text as T
import Data.Map.Strict
import Data.Typeable
import Data.TCache
import Data.TCache.DefaultPersistence
import Data.ByteString.Lazy.Char8 as BL(pack,unpack)
import GHC.Read(readPrec,expectP)
import Text.Read.Lex(Lexeme(..))
import Text.ParserCombinators.ReadPrec(step)

data WBMonad x

type WBId = Text

data 


class (Eq v, Typeable v, Serializable v) => WBObj v where
  wbId :: v -> WBId             -- ^ an id that is unique up to the data type.
          -- Ex, if you have a Foo data type and a Bar data type and their id are both
          -- "1" then this is fine, and they'll still represent separate objects, by
          -- virtue of their data types being different.
  action :: v -> WBMonad ()  -- ^ action to run when an object of the data type is created
  key :: v -> String  -- ^ raw key, must be totally unique
  --key v = deriveRawKey v (wbId v)

-- instance (Read a, Show a) => Serializable a where
--    serialize= BL.pack . show
--    deserialize= read . BL.unpack


instance Functor WBMonad where
  --fmap :: Functor f => (a -> b) -> f a -> f b
  fmap = undefined

instance Applicative WBMonad where
  pure = undefined
  (<*>) = undefined
  
instance Monad WBMonad where
  (>>=) = undefined

-- data WBObjMeta = WBObjMeta {
--   obj :: WBObjable,  -- ^ object represented by this meta data
--   loaders :: [WBObjable], -- ^ objects that load this object (so if it changes, they become dirty)
--   storedObjs :: [WBObjable], -- ^ objects stored by this object. We need this to be able to clean
--     --up objects, when the objects that are stored change when we rerun.
--   isDirty :: Bool -- ^ true if the object is dirty 
--   } deriving (Typeable)


data (Serializable key, Eq key) => WhiteBoard key = WhiteBoard key {
  keyToAction :: (key -> WBMonad ())
  dirtyObjectQueueHead :: DBRef (DirtyQueueEntry key),
  dirtyObjectQueueTail :: DBRef (DirtyQueueEntry key),
  }
  

data WhiteBoardData = WhiteBoardData {
  } --deriving (Typeable,Show,Read)

-- instance Indexable WhiteBoardData where
--   key _ = "WhiteBoard!"

-- deriveRawKey :: Typeable x => x -> Text -> String
-- deriveRawKey x k = (show (typeOf x)) ++ ":" ++ (T.unpack k)

