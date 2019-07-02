module Db.Db where

import Database.Beam
import Database.Beam.Postgres
import Db.Log

data LogDb f = LogDb { log :: f (TableEntity LogT)
                     } deriving (Generic, Database Postgres)

logDb :: DatabaseSettings Postgres LogDb
logDb = defaultDbSettings
