{
module Main (main) where
}

%wrapper "basic"

$digit = 0-9               -- digits
$alpha = [a-zA-Z]          -- alphabetic characters

tokens :-

  $white+                    ;
  "--".*                    ;
  let                         { \s -> Let }
  in                         { \s -> In }
  $digit+                    { \s -> Int (read s) }
  [\=\+\-\*\/\(\)]               { \s -> Sym (head s) }
  . # [ $white ] +           { \s -> Var s }
{
--    [^$white]+          { \s -> Var s }
--  .+ 
-- Each action has type :: String -> Token

-- The token type:
data Token =
     UnicodeIdentifierBeBoop     |
     Apple     |
     Banzai    |
     Let           |
     In            |
     Sym Char     |
     Var String     |
     Int Int
     deriving (Eq,Show)

showVarNames :: String -> IO ()
showVarNames s = do
   let v = (alexScanTokens  s)
   mapM printVarName v
   return ()
 where
   printVarName :: Token -> IO ()
   printVarName (Var v) = putStrLn v
   printVarName _       = return ()

main = do
  s <- getContents
  print (alexScanTokens s)
}
