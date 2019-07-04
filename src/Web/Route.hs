module Web.Route where

import Db.Log
import Servant

type LogApi = "log" :> Get '[JSON] [Log]
