{-# LANGUAGE OverloadedStrings #-}
module Data.Template.Type where

import Data.Text          (Text, unpack)
import Data.Map.Lazy
import Data.List          (intersperse)

type MapO x = Map Text x

data Stmt = DotStmt [Text]
          | ForeachStmt Text Stmt [Stmt]
          | PartialStmt Text
          | IfStmt
          | Raw Text
  deriving (Show, Eq)

data ObjectTree = ObjNode (Map Text ObjectTree)
                | ObjLeaf Text
                | ObjNodeList [Map Text ObjectTree]
  deriving (Show)

showObjTree :: ObjectTree -> String
showObjTree (ObjLeaf x) = "Leaf " <> unpack x
showObjTree (ObjNode xs) = "Node {" <> mconcat (intersperse ", " $ fmap (showNodeAbsrt) (toList xs)) <> "}"
  where showNodeAbsrt (x, (ObjLeaf _)) = unpack x
        showNodeAbsrt (x, obj) = unpack x <> " {" <> showObjTree obj <> "}"
showObjTree (ObjNodeList xss) = "List [" <> mconcat (intersperse ", " $ fmap (showObjTree.ObjNode) xss) <> "]"

class ToObjectTree a where
  toObjectTree :: a -> ObjectTree

getType :: ObjectTree -> String
getType (ObjLeaf _) = "ObjLeaf"
getType (ObjNodeList _) = "ObjNodeList"
getType (ObjNode _) = "ObjNode"