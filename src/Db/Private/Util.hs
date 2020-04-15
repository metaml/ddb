module Db.Private.Util where

import Data.Text

remap :: Text -> Text
remap "pid" = "id"
remap c = c
