module AgdaLight.Syntax.Parser.LexActions where

import AgdaLight.Syntax.Literal
import AgdaLight.Syntax.Parser.Alex
import AgdaLight.Syntax.Parser.Monad
import AgdaLight.Syntax.Parser.Tokens
import AgdaLight.Syntax.Position

lexToken :: Parser Token

token :: (String -> Parser tok) -> LexAction tok

withInterval  :: ((Interval, String) -> tok) -> LexAction tok
withInterval' :: (String -> a) -> ((Interval, a) -> tok) -> LexAction tok
withLayout :: LexAction r -> LexAction r

begin   :: LexState -> LexAction Token
endWith :: LexAction a -> LexAction a
begin_  :: LexState -> LexAction Token
end_    :: LexAction Token

keyword    :: Keyword -> LexAction Token
symbol     :: Symbol -> LexAction Token
identifier :: LexAction Token
literal    :: Read a => (Range -> a -> Literal) -> LexAction Token

followedBy    :: Char -> LexPredicate
eof           :: LexPredicate
inState       :: LexState -> LexPredicate
