import Data.List
import Data.List.Split
import System.Process

-- The program - a function from a list of strings (git log) to another list of strings (output)
program :: [String] -> [String]
----- YOUR CODE HERE -----
program log = log                                            -- echo
--program = id                                                 -- (also) echo
--program log = [(show $ length log) ++ " commits"]            -- commit count
--program = sort . concat . map (words . last . splitOn "\t")  -- sorted list of words in commit subjects


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
