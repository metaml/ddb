module Web.Server where

import Control.Monad.IO.Class (liftIO)
import Database.Selda
import Database.Selda.PostgreSQL
import Data.Time
import Data.Time.Clock.System
import Db.Log
import Db.Query
import Servant

-- app :: Application
-- app = serve logApi server

-- logApi :: Proxy LogApi
-- logApi = Proxy

-- type LogApi = "logs" :> Get '[JSON] [Log]
--               :<|> "healthcheck" :> Get '[JSON] UTCTime

-- server :: Server LogApi
-- server = getLogs :<|> getHealthcheck

-- getLogs :: Handler [Log]
-- getLogs = do
--   c <- liftIO $ connect $ defaultConnectInfo { connectDatabase = "log" }
--   liftIO $ logs c >>= pure

-- getHealthcheck :: Handler UTCTime
-- getHealthcheck = do
--   t <- liftIO $ systemToUTCTime <$> getSystemTime
--   pure t
