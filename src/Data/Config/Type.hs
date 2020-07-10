{-# LANGUAGE OverloadedStrings #-}
module Data.Config.Type where

import Data.Text     (Text)
import Data.Map.Lazy       (fromList)
import Data.Template       (toNodeList)
import Data.Template.Type

data Config = Config {
    siteTitle :: Text
  , siteUrl   :: Text
  , siteMenus :: [Menu]
} deriving (Show)

data Menu = Menu {
    menuName :: Text
  , menuLoc :: Text
} deriving (Show)

instance ToObjectTree Menu where
  toObjectTree menu = ObjNode (fromList tup)
    where tup = [ ("menuName", ObjLeaf $ menuName menu)
                , ("menuLoc" , ObjLeaf $ menuLoc menu) ]
  

instance ToObjectTree Config where
  toObjectTree config = ObjNode (fromList tup)
    where tup = [ ("siteTitle", ObjLeaf $ siteTitle config)
                , ("siteUrl"  , ObjLeaf $ siteUrl config)
                , ("siteMenus", toNodeList (toObjectTree <$> (siteMenus config)))]
