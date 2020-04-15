module Db.Db where

import Prelude hiding (log)
import Data.Text hiding (last)
import Database.Selda
import Database.Selda.PostgreSQL
import Db.Log

-- data LogDb f = LogDb { log :: f (TableEntity LogT)
--                      } deriving (Generic, Database Postgres)

-- logDb :: DatabaseSettings Postgres LogDb
-- logDb = defaultDbSettings `withDbModification` renamingFields (rename . defaultFieldName)
--         where
--           rename :: Text -> Text
--           rename = last . splitOn "__"
