{-# LANGUAGE OverloadedStrings #-}
module AgdaLight.Parser where

import WhiteBoard
import AgdaLight.Types
import Text.Parsec
import qualified Data.Text as T
import Text.ParserCombinators.Parsec.Language
import qualified Text.ParserCombinators.Parsec.Token as Token
import Data.Functor.Identity
import qualified Data.Text.IO as I

type ALParserM = ParsecT T.Text () ALIMonad

languageDef :: GenLanguageDef T.Text u ALIMonad
languageDef = 
   LanguageDef { Token.commentStart    = "{-"
            , Token.commentEnd      = "-}"
            , Token.commentLine     = "--"
            , Token.nestedComments  = True
            , Token.identStart      = letter <|> char '_'
            , Token.identLetter     = alphaNum <|> oneOf "_'"
            , Token.opStart         = oneOf ":!#$%&*+./<=>?@\\^|-~"
            , Token.opLetter       = oneOf ":!#$%&*+./<=>?@\\^|-~"
            , Token.reservedNames   = [ "module",
                                        "where" -- "if"
                                      -- , "then"
                                      -- , "else"
                                      -- , "while"
                                      -- , "do"
                                      -- , "skip"
                                      -- , "true"
                                      -- , "false"
                                      -- , "not"
                                      -- , "and"
                                      -- , "or"
                                      ]
            , Token.reservedOpNames = [":", "=", "*", "/", ":="
                                      -- , "<", ">", "and", "or", "not"
                                      ]
            , caseSensitive  = True
            }

lexer :: Token.GenTokenParser T.Text u ALIMonad
lexer = Token.makeTokenParser languageDef

identifier = Token.identifier lexer -- parses an identifier
reserved   = Token.reserved   lexer -- parses a reserved name
reservedOp = Token.reservedOp lexer -- parses an operator
parens     = Token.parens     lexer -- parses surrounding parenthesis:
                                    --   parens p
                                    -- takes care of the parenthesis and
                                    -- uses p to parse what's inside them
integer    = Token.integer    lexer -- parses an integer
semi       = Token.semi       lexer -- parses a semicolon
whiteSpace = Token.whiteSpace lexer -- parses whitespace

type ModulePath = [T.Text]

{- | parses a file
   mp - module path
   fp - file path of source file
   c  - contents of file
-}
parseFileAction :: ModulePath -> T.Text -> T.Text -> ALIMonad ()
parseFileAction mp fp c = do
  runParserT fileParser () (T.unpack fp) c
  return ()

fileParser :: ALParserM ()
fileParser = do
  whiteSpace
  reserved "module"
  modName <- identifier
  reserved "where"
  many varDef
  
  return ()
  

varDef :: ALParserM ()
varDef = do
  varName <- identifier
  reservedOp ":"
  varType <- expr
  statementEnd
  optional
    do
      varName2 <- expr
      varName == varName2 or error
      args <- many identifier
      

