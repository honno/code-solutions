module Main where

import System.IO (hSetBuffering, stdout, BufferMode(..))
import Data.Char (toUpper)

main =
    do
    initialiseIO
    putStrLn $ "known OS types = " ++ show allTypes
    ostype <- getElement "operating system type"
    putStrLn $ show (ostype2OS ostype) ++ " is a type of " ++ show ostype

initialiseIO =
    do
    hSetBuffering stdout NoBuffering
        -- ensure any console output is shown asap

data OS = ANDROID | IOS | MACOSX | WINDOWS8 | WP8 | VXWORKS
    deriving (Show, -- default formatting
              Read, -- default parsing
              Eq,   -- default equality testing
              Bounded, -- default minBound and maxBound
              Enum) -- default sequencing (needed for .. ranges)
data OSType = DESKTOP | EMBEDDED | MOBILE
    deriving (Show, -- default formatting
              Read, -- default parsing
              Eq,   -- default equality testing
              Bounded, -- default minBound and maxBound
              Enum) -- default sequencing (needed for .. ranges)

allTypes :: [OSType] -- ie it is a list of OS elements
allTypes = [minBound .. maxBound]

ostype2OS MOBILE = ANDROID
ostype2OS MOBILE = IOS
ostype2OS DESKTOP = MACOSX
ostype2OS DESKTOP = WINDOWS8
ostype2OS MOBILE = WP8
ostype2OS EMBEDDED = VXWORKS

getElement elementTypeName =
    keepTrying
    where
    keepTrying =
        do
        showPrompt
        line <- getLine -- get whatever user types as a string
        let lineUpperCase = map toUpper line -- convert each character to upper case
        case reads lineUpperCase of -- attempt to parse the string
                -- after converting all characters to upper case
            [] -> -- no valid interpretation of the line as an element
                do
                reportError
                keepTrying -- try again - using recursion
            ((e,_) : _) -> -- at least one interpretation - it is given the name e
                    -- underscore here means "anything - its value does not matter"
                return e -- type of e is derived from context
                        -- where getElement is used
    showPrompt =
        putStr ("Input one " ++ elementTypeName ++ ": ")
    reportError =
        putStrLn ("Invalid " ++ elementTypeName ++ ", try again")
