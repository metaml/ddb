module App where

import Prelude hiding (log)
import Data.Aeson.Types
import Data.Time.Clock
import Data.UUID.V4
import Database.Beam
import Database.Beam.Postgres
import Db.Db
import Db.Log
import Network.Wai.Handler.Warp
import Web.Server

servant :: IO ()
servant = run 8081 app

beam :: IO ()
beam = do
  c <- connect $ defaultConnectInfo { connectDatabase = "log"
                                    }
  runBeamPostgres c $ do
    gid <- liftIO nextRandom
    utc <- liftIO getCurrentTime
    runInsert $ insert (log logDb) $ insertValues
      [ Log 1 (Log' gid "source" emptyObject emptyObject) utc utc
      ]

    gid' <- liftIO nextRandom
    runInsert $ insert (log logDb) $ insertExpressions
      [ Log default_ (Log' (val_ gid') (val_ "source") (val_ emptyObject) (val_ emptyObject)) default_ default_
      ]
