module App where

import Prelude hiding (log)
import Data.Aeson
import Data.Aeson.Types
import Data.Generics.Internal.VL.Lens
import Data.Generics.Product
import Data.Time.Clock
import Data.Text hiding (drop)
import Data.UUID.V4
import Database.Beam
import Database.Beam.Postgres
import Db.Db
import Db.Log

data LogLine = LogLine { _line :: Text }
  deriving (Eq, Generic, Show)

instance ToJSON LogLine where
  toJSON = genericToJSON defaultOptions { fieldLabelModifier = drop 1 }

instance FromJSON LogLine where
  parseJSON = genericParseJSON defaultOptions { fieldLabelModifier = drop 1 }

ddb :: IO ()
ddb = do
  c <- connect $ defaultConnectInfo { connectDatabase = "log"
                                    }
  runBeamPostgres c $ do
    gid <- liftIO nextRandom
    utc <- liftIO getCurrentTime

    runInsert $ insert (logDb ^. field @"log") $
      insertValues [LogT 1 gid "source" emptyObject emptyObject utc utc]

    runInsert $ insert (logDb ^. field @"log") $
      insertExpressions [LogT { logId        = default_
                              , logGuid      = default_
                              , logSource    = val_ "source"
                              , logInput     = val_ $ toJSON . LogLine $ "’Twas brillig, and the slithy toves"
                              , logOutput    = val_ $ toJSON . LogLine $ "Did gyre and gimble in the wabe:"
                              , logCreatedAt = default_
                              , logUpdatedAt = default_
                              }
                        ]

  return ()
