module Db.Log where

import Data.Aeson
import Data.Int
import Data.Text
import Data.Time
import Data.UUID
import Database.Beam
import Database.PostgreSQL.Simple (Connection)

data Log'T f = Log' { logGuid      :: C f UUID
                    , logSource    :: C f Text
                    , logInput     :: C f Value
                    , logOutput    :: C f Value
                    } deriving (Beamable, Generic)

type Log' = Log'T Identity
deriving instance Eq Log'
deriving instance Show Log'
deriving instance ToJSON Log'
deriving instance FromJSON Log'

data LogT f = Log { logId        :: C f Int64
                  , log'         :: Log'T f
                  , logCreatedAt :: C f UTCTime
                  , logUpdatedAt :: C f UTCTime
                  } deriving (Beamable, Generic)

type Log = LogT Identity
deriving instance Eq Log
deriving instance Show Log
deriving instance ToJSON Log
deriving instance FromJSON Log

type LogId = PrimaryKey LogT Identity
deriving instance Eq LogId
deriving instance Show LogId

instance Table LogT where
   data PrimaryKey LogT f = LogId ( C f Int64
                                  ) deriving (Beamable, Generic)
   primaryKey = LogId . logId
