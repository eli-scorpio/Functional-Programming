{- butrfeld Andrew Butterfield -}
module Ex04 where

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

-- Datatypes -------------------------------------------------------------------

-- do not change anything in this section !


-- a binary tree datatype, honestly!
data BinTree k d
  = Branch (BinTree k d) (BinTree k d) k d
  | Leaf k d
  | Empty
  deriving (Eq, Show)


-- Part 1 : Tree Insert -------------------------------

-- Implement:
ins :: Ord k => k -> d -> BinTree k d -> BinTree k d

-- insert into empty tree
ins key val Empty = Leaf key val

-- insert at leaf node
ins key val (Leaf k d)
    | key < k    = Branch (Leaf key val) Empty k d
    | key == k   = Leaf key val
    | otherwise  = Branch Empty (Leaf key val) k d

-- insert into tree
ins key val (Branch leftChild rightChild k d)
    | key < k     = Branch (ins key val leftChild) rightChild k d
    | key == k    = Branch leftChild rightChild key val
    | otherwise = Branch leftChild (ins key val rightChild) k d

-- Part 2 : Tree Lookup -------------------------------

-- Implement:
lkp :: (Monad m, Ord k) => BinTree k d -> k -> m d  
lkp Empty _ = fail "Empty"

lkp (Branch leftChild rightChild key val) k
      | k < key = lkp leftChild k
      | k > key = lkp rightChild k
      | otherwise = return val

lkp (Leaf key val) k
      | k == key = return val
      | otherwise = fail "Not in Tree"

-- Part 3 : Tail-Recursive Statistics

{-
   It is possible to compute BOTH average and standard deviation
   in one pass along a list of data items by summing both the data
   and the square of the data.
-}
twobirdsonestone :: Double -> Double -> Int -> (Double, Double)
twobirdsonestone listsum sumofsquares len
 = (average,sqrt variance)
 where
   nd = fromInteger $ toInteger len
   average = listsum / nd
   variance = sumofsquares / nd - average * average

{-
  The following function takes a list of numbers  (Double)
  and returns a triple containing
   the length of the list (Int)
   the sum of the numbers (Double)
   the sum of the squares of the numbers (Double)

   You will need to update the definitions of init1, init2 and init3 here.
-}
getLengthAndSums :: [Double] -> (Int,Double,Double)
getLengthAndSums ds = getLASs init1 init2 init3 ds
init1 = 0
init2 = 0
init3 = 0

{-
  Implement the following tail-recursive  helper function
-}
getLASs :: Int -> Double -> Double -> [Double] -> (Int,Double,Double)
getLASs length listsum sumofsquares []  = (length,listsum,sumofsquares)

getLASs length listsum sumofsquares (x:xs) = let(len, sum, sumsq) = getLASs length listsum sumofsquares xs
                                             in (len + 1, sum + x, sumsq + (x*x))

-- Final Hint: how would you use a while loop to do this?
--   (assuming that the [Double] was an array of double)
