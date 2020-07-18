module Data.Markdown.Type where

import Data.Text

data MDElem = Header              Int Text
            | Paragrah            [MDElem]    -- Should contain Italic, Bold, BoldAndItalic, Code
                                              --                                    , Link, Image
            | PlainText           Text
            | Italic              Text
            | Bold                Text
            | BoldAndItalic       Text
            | Strikethrough       Text
            | Code                Text
            | CodeBlock           Text
            | Link                [MDElem] Text (Maybe Text)
            | Image               Text Text (Maybe Text)
            | OrderedList         [MDElem]    -- Should contain ListElem
            | UnorderedList       [MDElem]    -- As above
            | ListElem            [MDElem]    -- Should contain the same as Paragrah contains
            | Blockquotes         [MDElem]    -- Should contain the whole fuckin universe
            | Footnote            Text
            | FootnoteRef         Text [MDElem]
            | FootnoteRefs        [MDElem]
            | HorizontalRule
  deriving (Show, Eq)