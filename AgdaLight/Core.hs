module AgdaLight.Core where
import WhiteBoard.Types as WT
import WhiteBoard.Core as C
import Data.TCache.Defs(Serializable(..))
import qualified Data.ByteString.Lazy.Char8 as BL(pack,unpack,ByteString(..))
import qualified Data.Text as T



alActionFunc :: WBIMonad ALKey ALObj ()
alActionFunc = do
  (k,o) <- ask
  case o of
    (ALObj fp c) -> parseFileAction c

    

