module Main where

import App

-- main = servant | beam
main :: IO ()
main = do
  putStrLn "inserting to logs"
  _ <- beam
  putStrLn "listening on port 8081"
  servant
