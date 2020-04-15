module Db.Query where

import Prelude hiding (log)
import Database.Selda
import Database.Selda.PostgreSQL
import Db.Db
import Db.Log

-- logs :: Connection -> IO [Log]
-- logs c = do
--   ls <- liftIO $ runBeamPostgres c $ do
--                    runSelectReturningList $ select $ do
--                      all_ (log logDb)
--   return ls
