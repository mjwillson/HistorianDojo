import Data.List
import Data.List.Split
import System.Process

getName :: String -> String
getName line = name
  where _:_:name:_ = splitOn "\t" line

-- The program - a function from a list of strings (git log) to another list of strings (output)
program :: [String] -> [String]
program = map authorCount . group . sort . map getName
  where authorCount l = (head l) ++ " -> " ++ (show $ length l)

-- Customise this if you want different info from git (see "git log --help")
--   hash <tab> timestamp <tab> author <tab> subject
gitLogArgs = ["--pretty=%h\t%at\t%an\t%s"]


--------------------------------------------------------------------------------

-- Runs everything (including 'git log') straight from Haskell (maybe useful for interactive testing).
-- Usage: ghci> run "path/to/repo"
run :: String -> IO ()
run repoDir = gitLog >>= (putStr . unlines . program . lines)
  where gitLog = readProcess "git" (["-C", repoDir, "log"] ++ gitLogArgs) ""

-- Pipe in git logs, pipe out results
-- Usage: $ git log --pretty=... | runhaskell /path/to/historian.hs
main :: IO ()
main = interact (unlines . program . lines)
