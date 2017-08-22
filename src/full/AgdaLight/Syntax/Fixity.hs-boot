module AgdaLight.Syntax.Fixity where

import Control.DeepSeq (NFData)

import AgdaLight.Syntax.Position ( KillRange )

data Fixity'

instance KillRange Fixity'
instance NFData Fixity'
instance Show Fixity'

noFixity' :: Fixity'
