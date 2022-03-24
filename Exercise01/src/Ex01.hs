module Ex01 where
import Data.Char (toUpper)

name, idno, username :: String
name      =  "Eligijus Skersonas"  -- replace with your name
idno      =  "19335661"    -- replace with your student id
username  =  "skersone"   -- replace with your TCD username


declaration -- do not modify this
 = unlines
     [ ""
     , "@@@ This exercise is all my own work."
     , "@@@ Signed: " ++ name
     , "@@@ "++idno++" "++username
     ]


{- Part 1

Write a function 'raise' that converts a string to uppercase

Hint: 'toUpper :: Char -> Char' converts a character to uppercase
if it is lowercase. All other characters are unchanged.
It is imported should you want to use it.

-}
-- String :: [Char]
raise :: String -> String
raise [] = []
raise (x:xs) =  toUpper x : raise xs

{- Part 2

Write a function 'nth' that returns the nth element of a list.
Hint: the test will answer your Qs

-}
-- !! is the indexing operator
nth :: Int -> [a] -> a
nth i xs = xs !! (i-1)


{- Part 3

Write a function `commonLen` that compares two sequences
and reports the length of the prefix they have in common.

-}

commonLen :: Eq a => [a] -> [a] -> Int
commonLen [] _ = 0   -- if first list is empty return 0
commonLen _ [] = 0   -- if second list is empty return 0
commonLen (x:xs) (y:ys) | x == y    = 1 + commonLen xs ys -- if elements equal add 1 (recursive)
                        | otherwise = 0                   -- else return 0

{- Part 4

(TRICKY!) (VERY!)

Write a function `runs` that converts a list of things
into a list of sublists, each containing elements of the same value,
which when concatenated together give the same list

So `runs [1,2,2,1,3,3,3,2,2,1,1,4]`
 becomes `[[1],[2,2],[1],[3,3,3],[2,2],[1,1],[4]]`

Hint:  `elem :: Eq a => a -> [a] -> Bool`

HINT: Don't worry about code efficiency
       Seriously, don't!

-}

-- takeWhile takes elements from the head of xs that match the condition
-- dropWhile returns a list with n elements removed from the head of xs that match the condition
runs :: Eq a => [a] -> [[a]]
runs [] = []  -- if list is empty return the empty list
runs (x:xs) = (x:ys) : runs zs     
            where  (ys,zs) = (takeWhile (==x) xs, dropWhile (==x) xs)
