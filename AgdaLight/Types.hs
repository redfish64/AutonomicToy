module AgdaLight.Types where

import WhiteBoard.Types as WT
import WhiteBoard.Core as C

import Data.TCache.Defs(Serializable(..))
import qualified Data.ByteString.Lazy.Char8 as BL(pack,unpack,ByteString(..))

import qualified Data.Text as T

instance Serializable ALObj where
  serialize= BL.pack . show
  deserialize= read . BL.unpack

instance WBObj ALObj

data ALKey = ALFileKey FilePath | ALSymKey SymName
  deriving (Show, Read, Eq)

type FilePos = (Int, Int)

type SymName = T.Text

-- | This is the object that is stored within the whiteboard framework.
--   All references from one whiteboard object to another are made via
--   the objects corresponding key
data ALObj = ALFile { sfFilePath :: FilePath, sfContents ::  T.Text }
  |
  ALSym { srFile :: FilePath, srName :: SymName, srTypePos :: FilePos,
          srValPos :: FilePos, srType :: ParsedExpr, svExpr :: ParsedExpr }
  deriving (Show,Read,Eq)


instance Serializable ALKey where
  serialize= BL.pack . show
  deserialize= read . BL.unpack
  
instance Keyable ALKey where

-- | expression parsed from file. 
data ParsedExpr =
  PEExpr Expr -- a valid expression
  | PEEmpty  -- no expression present
  | PEError  -- error parsing expression
  deriving (Show,Read,Eq)

data Expr =
  Var SymName
  | App Expr Expr
  | Lam SymName Type Expr
  | Pi SymName Type Type
  | Let SymName Type Expr Expr
  | Kind Kind
  deriving (Show,Read,Eq)

type Type = Expr

--TODO we need to implement agda's multi livels, I guess
data Kind = Star | Box
  deriving (Show,Read,Eq)

type ALIMonad = WBIMonad ALKey ALObj
