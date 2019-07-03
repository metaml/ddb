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

data Logs = Logs [Text]
  deriving (Eq, Generic, Show, ToJSON, FromJSON)

ddb :: IO ()
ddb = do
  c <- connect $ defaultConnectInfo { connectDatabase = "log"
                                    }
  runBeamPostgres c $ do
    gid <- liftIO nextRandom
    utc <- liftIO getCurrentTime

    runInsert $ insert (log logDb) $
      insertValues [Log 1 (Log' gid "source" emptyObject emptyObject) utc utc]

  return ()
