module Ccap.Codegen.GetSchemaConfig
  ( GetSchemaConfig
  , getSchemaConfig
  ) where

import Prelude
import Data.Foldable (fold)
import Data.Maybe (Maybe)
import Data.String (Pattern(..))
import Data.String (split) as String
import Options.Applicative as OptParse
import Options.Applicative.Types as OptParse.Types

type GetSchemaConfig
  = { domains :: Boolean
    , database :: String
    , dbManagedColumns :: Maybe (Array String)
    , table :: Maybe String
    , scalaPkg :: String
    , pursPkg :: String
    }

getSchemaConfig :: OptParse.Parser GetSchemaConfig
getSchemaConfig = do
  ( \domains database table scalaPkg pursPkg dbManagedColumns ->
      { database
      , dbManagedColumns
      , domains
      , pursPkg
      , scalaPkg
      , table
      }
  )
    <$> domainsOption
    <*> databaseOption
    <*> tableOption
    <*> scalaPkgOption
    <*> pursPkgOption
    <*> dbManagedColumnsOption


domainsOption :: OptParse.Parser Boolean
domainsOption =
  OptParse.switch
    $ fold
        [ OptParse.long "domains"
        , OptParse.short 'd'
        ]

databaseOption :: OptParse.Parser String
databaseOption =
  OptParse.strOption
    $ fold
        [ OptParse.long "config"
        , OptParse.metavar "Database"
        , OptParse.short 'c'
        , OptParse.help "The database to use"
        ]

tableOption :: OptParse.Parser (Maybe String)
tableOption =
  OptParse.Types.optional
    $ OptParse.strOption
    $ fold
        [ OptParse.long "table"
        , OptParse.metavar "Table"
        , OptParse.short 't'
        , OptParse.help "Query the provided database table"
        ]

scalaPkgOption :: OptParse.Parser String
scalaPkgOption =
  OptParse.strOption
    $ fold
        [ OptParse.long "scala-pkg"
        , OptParse.metavar "Scala package"
        , OptParse.short 's'
        ]

pursPkgOption :: OptParse.Parser String
pursPkgOption =
  OptParse.strOption
    $ fold
        [ OptParse.long "purs-pkg"
        , OptParse.metavar "Purescript package"
        , OptParse.short 'p'
        ]

dbManagedColumnsOption :: OptParse.Parser (Maybe (Array String))
dbManagedColumnsOption =
  let
    split = String.split (Pattern ",")

    arrayStringParse = map split OptParse.str
  in
   OptParse.Types.optional
    $ OptParse.option arrayStringParse
    $ fold
        [ OptParse.long "db-managed-columns"
        , OptParse.metavar "DbManaged Columns"
        , OptParse.help "Columns to set the dbManaged annotation"
        ]
