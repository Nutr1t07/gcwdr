module Utils.Logging where

import           Data.Time                      ( defaultTimeLocale
                                                , formatTime
                                                , getCurrentTime
                                                )
import           System.IO                      ( hFlush
                                                , stdout
                                                )

data LogTag = Info | Warning | Error | Debug

-- | Log with tag
logWT :: LogTag -> String -> IO ()
logWT logTag msg = do
  t <- getCurrentTime
  let nowtime = formatTime defaultTimeLocale "%Y/%m/%d %H:%M" t
  putStrLn $ concat ["[", nowtime, "] ", "[", transTag logTag, "] ", msg]
  hFlush stdout

transTag :: LogTag -> String
transTag tag = case tag of
  Info    -> "Info"
  Warning -> "Warning"
  Error   -> "Error"
  Debug   -> "Debug"

-- | Log errors with action name and details.
logErr :: String -> String -> IO ()
logErr msg errText = logWT Error (msg ++ ": " ++ errText)

logErrAndTerminate :: String -> String -> IO a
logErrAndTerminate msg err = logErr msg err >> error "fatal error"
