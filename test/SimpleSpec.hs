{-# LANGUAGE OverloadedStrings #-}
module SimpleSpec where

import           Data.Attoparsec.Text           ( many'
                                                , parseOnly
                                                )
import           Data.Markdown.Parser           ( mdElem )
import           Data.Markdown.Type             ( MDElem
                                                  ( Bold
                                                  , BoldAndItalic
                                                  , Italic
                                                  , ListElem
                                                  , Paragrah
                                                  , PlainText
                                                  , UnorderedList
                                                  )
                                                )
import           Data.Template.Parser           ( stmt )
import           Data.Template.Type             ( Stmt(..) )
import           Data.Text                      ( Text )
import           Prelude                 hiding ( unlines )
import           Test.Hspec                     ( Spec
                                                , describe
                                                , it
                                                , shouldBe
                                                )

spec :: Spec
spec = do
  describe "Markdown parsing stuff" $ do
    it "parses bold" $ do
      parseMD "**test**" `shouldBe` rtPara [Bold "test"]
    it "parses italic" $ do
      parseMD "*test*" `shouldBe` rtPara [Italic "test"]
    it "parses boldAndItalic" $ do
      parseMD "***test***" `shouldBe` rtPara [BoldAndItalic "test"]
    it "parses unordered list" $ do
      parseMD "- xyz\n- zyx"
        `shouldBe` rt
                     [ UnorderedList
                         [ ListElem [PlainText "xyz"]
                         , ListElem [PlainText "zyx"]
                         ]
                     ]

  describe "Template parsing stuff" $ do
    it "parses dot" $ do
      parseTP "[- this.posts -]" `shouldBe` rt [DotStmt ["this", "posts"]]
      parseTP "[- this. -]" `shouldBe` rt [Raw "[- this. -]"]
    it "parses partials" $ do
      parseTP "[- partial index.html -]"
        `shouldBe` rt [PartialStmt "index.html"]
    it "parses foreach" $ do
      parseTP "[- foreach x in this.posts -][- end -]"
        `shouldBe` rt [ForeachStmt "x" (DotStmt ["this", "posts"]) []]
      parseTP "[- foreach x in this.posts -][- x.title -][- end -]"
        `shouldBe` rt
                     [ ForeachStmt "x"
                                   (DotStmt ["this", "posts"])
                                   [DotStmt ["x", "title"]]
                     ]

    it "parses ifdef" $ do
      parseTP "[- ifdef this.posts -][- else -][- end -]"
        `shouldBe` rt [IfdefStmt (DotStmt ["this", "posts"]) [] []]
      parseTP
          "[- ifdef this.posts -][- x.title -][- else -][- y.title -][- end -]"
        `shouldBe` rt
                     [ IfdefStmt (DotStmt ["this", "posts"])
                                 [DotStmt ["x", "title"]]
                                 [DotStmt ["y", "title"]]
                     ]


rtPara :: [MDElem] -> Either a [MDElem]
rtPara x = Right [Paragrah x]

rt :: b -> Either a b
rt = Right

parseTP :: Text -> Either String [Stmt]
parseTP = parseOnly (many' stmt)

parseMD :: Text -> Either String [MDElem]
parseMD = parseOnly (many' mdElem) . (<> "\n")
