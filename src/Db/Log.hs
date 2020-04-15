module Db.Log where

import Data.Aeson
import Data.Text
import Data.Text.Manipulate
import Data.Time
import Data.UUID
import Database.Selda
import Database.Selda.PostgreSQL
import Db.Private.Util

data Log = Log { pid :: ID Log
               , guid :: UUID
               , source :: Text
               , input :: Value
               , output :: Value
               , createdAt :: UTCTime
               , updatedAt :: UTCTime
               } deriving (Generic, SqlRow)

log :: Table Log
log = tableFieldMod "logs"
  [#pid :- autoPrimary]
  (toSnake . remap)


-- : Table Person
-- > people = tableFieldMod "people"
-- >   [#personName :- autoPrimaryGen]
-- >   (fromJust . stripPrefix "person")
--
--   This will create a table with the columns named
--   @Id@, @Name@, @Age@ and @Pet@.
