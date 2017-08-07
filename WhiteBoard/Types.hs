{-# LANGUAGE OverloadedStrings #-}
module WhiteBoard.Types where

import Data.Text as T
import Data.Map.Strict
import Data.Typeable
import Data.TCache
import Data.TCache.DefaultPersistence
import qualified Data.ByteString.Lazy.Char8 as BL(pack,unpack,ByteString(..))
import GHC.Read(readPrec,expectP)
import Text.Read.Lex(Lexeme(..))
import Text.ParserCombinators.ReadPrec(step)
import Data.Sequence(Seq)
import Data.ByteString
import Control.Monad.State
import Control.Monad.Reader
import Data.IORef
import WhiteBoard.Monitor

data WBConf = WBConf {
  keyToAction :: (Key -> WBMonad ()),
  wbMon :: Monitor, -- ^ monitor used for managing queue of objects in whiteboard
  wbRef :: DBRef WhiteBoard -- ^ contains ref to whiteboard singleton
  }

data WhiteBoard = WhiteBoard {
  queue :: Seq Key -- ^ queue of dirty objects, FIFO.. dirty object are added to the end
  } deriving (Show,Read)


type WBMonad = ReaderT WBConf IO

runWBMonad :: WBConf -> WBMonad x -> IO x
runWBMonad wbc m = runReaderT m wbc

whiteBoardKey :: Key
whiteBoardKey = "_WhiteBoard"

instance Indexable WhiteBoard where
  key _ = whiteBoardKey -- ^ WhiteBoard is a singleton

instance Serializable (WhiteBoard ) where
  --TODO 4 PERF make these more binary'ie
  serialize= BL.pack . show
  deserialize= read . BL.unpack

data Payload obj = Valid obj -- ^ valid object which can be stored in database
  | MultipleStorers -- ^ if multiple objects try to write to same object, it is an error, and no value is used
  | Empty -- ^ No objects have stored the value for this object
  deriving (Show, Read, Eq)

data ObjMeta o = ObjMeta {
  key :: Key,
  payload :: Payload o,
  referersKeys :: [Key], -- ^ objects that load, or store this object, so if it changes, they become dirty. In the case of storers, if there are multiple stores, we have to report an error, so this keeps track of them as well.
  referers :: Maybe [ObjMeta o], -- ^ populated on demand from referersKeys
  storedObjsKeys :: [Key], -- ^ objects stored by this object. We need this to be able to clean
    --up objects, when the objects that are stored change when we rerun.

  storedObjs :: Maybe [ObjMeta o] -- ^ populated on demand from storedObjsKeys
  
  } deriving (Show,Read)

instance Indexable (ObjMeta o) where
  key = WhiteBoard.Types.key

class (Typeable o,Indexable o,Serializable o,Eq o,Show o,Read o) => WBObj o  

instance WBObj o => Serializable (ObjMeta o) where
  --TODO 4 PERF make these more binary'ie
  --TODO 2 make sure we take advantage of the serialization of o
  serialize= BL.pack . show
  deserialize= read . BL.unpack

type WBId = Text

type Key = String

-- class (Eq v, Typeable v, Serializable v) => ObjMeta v where
--   wbId :: v -> WBId             -- ^ an id that is unique up to the data type.
--           -- Ex, if you have a Foo data type and a Bar data type and their id are both
--           -- "1" then this is fine, and they'll still represent separate objects, by
--           -- virtue of their data types being different.
--   action :: v -> WBMonad ()  -- ^ action to run when an object of the data type is created
--   key :: v -> String  -- ^ raw key, must be totally unique
  --key v = deriveRawKey v (wbId v)

-- instance (Read a, Show a) => Serializable a where
--    serialize= BL.pack . show
--    deserialize= read . BL.unpack



-- data ObjMetaMeta = ObjMetaMeta {
--   obj :: ObjMetaable,  -- ^ object represented by this meta data
--   loaders :: [ObjMetaable], -- ^ objects that load this object (so if it changes, they become dirty)
--   storedObjs :: [ObjMetaable], -- ^ objects stored by this object. We need this to be able to clean
--     --up objects, when the objects that are stored change when we rerun.
--   isDirty :: Bool -- ^ true if the object is dirty 
--   } deriving (Typeable)



-- instance Indexable WhiteBoardData where
--   key _ = "WhiteBoard!"

-- deriveRawKey :: Typeable x => x -> Text -> String
-- deriveRawKey x k = (show (typeOf x)) ++ ":" ++ (T.unpack k)

