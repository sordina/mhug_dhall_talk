{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Main where

import Dhall
import qualified Network.Wreq as W
import Web.Scotty
import Data.Text.Lazy.Encoding
import Data.Monoid
import Control.Monad.IO.Class
import Data.Generics.Product
import Data.Text.Lazy hiding (drop)

data UserConfig =
  UserConfig
  { name :: Text
  , ip :: Text
  , pageLimit :: Integer
  } deriving (Generic, Show)

data HpConfig =
  HpConfig
  { name :: Text
  , ip :: Text
  , pageLimit :: Integer
  , updateURL :: Text
  } deriving (Generic, Show)

instance Interpret UserConfig
instance Interpret HpConfig

hpDefaultConfig =
  HpConfig
  { name      = "XXX"
  , ip        = "XXX"
  , pageLimit = 123
  , updateURL = "hp.com"
  }

main :: IO ()
main =
  scotty 3000 $ do
    get "/" $ do
      redirect "/userconfig"

    get "/userconfig" $ do
      -- TODO: Automatically derive dhall type for UserConfig
      html "{ name : Text, ip : Text, pageLimit : Integer }"

    get "/hpconfig" $ do
      -- TODO: Automatically derive dhall type for HpConfig
      html "{ name : Text, ip : Text, pageLimit : Integer, updateURL : Text }"

    post "/" $ do
      bytes <- body
      liftIO $ print bytes
      let b = decodeUtf8 bytes

      (v :: UserConfig) <- liftIO $ input auto b

      let foo = smash v hpDefaultConfig

      -- TODO: Figure out how to serialise as Dhall
      html $ pack (drop 9 $ show foo)

