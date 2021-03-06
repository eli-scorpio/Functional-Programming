{- butrfeld Andrew Butterfield -}
module Ex02 where

name, idno, username :: String
name = "Eligijus Skersonas" -- replace with your name
idno = "19335661" -- replace with your student id
username = "skersone" -- replace with your TCD username

declaration -- do not modify this
  =
  unlines
    [ "",
      "@@@ This exercise is all my own work.",
      "@@@ Signed: " ++ name,
      "@@@ " ++ idno ++ " " ++ username
    ]

-- Datatypes and key functions -----------------------------------------------

-- do not change anything in this section !

type Id = String

data Expr
  = Val Double
  | Add Expr Expr
  | Mul Expr Expr
  | Sub Expr Expr
  | Dvd Expr Expr
  | Var Id
  | Def Id Expr Expr
  deriving (Eq, Show)

type Dict k d = [(k, d)]

define :: Dict k d -> k -> d -> Dict k d
define d s v = (s, v) : d

find :: Dict String d -> String -> Either String d
find [] name = Left ("undefined var " ++ name)
find ((s, v) : ds) name
  | name == s = Right v
  | otherwise = find ds name

type EDict = Dict String Double

v42 = Val 42

j42 = Just v42

-- do not change anything above !

-- Part 1 : Evaluating Expressions -- (50 test marks, worth 25 Exercise Marks) -

-- Implement the following function so all 'eval' tests pass.

-- eval should return `Left msg` if:
-- (1) a divide by zero operation was going to be performed;
-- (2) the expression contains a variable not in the dictionary.
-- see test outcomes for the precise format of those messages

eval :: EDict -> Expr -> Either String Double
-- If evaluating a value return the value
eval _ (Val x) = Right x

-- If evaluating a variable call find to search the look up table for the variable find will return
-- an error message if it does not find the variable otherwise it returns the double binded to the variable
eval d (Var i) = find d i

-- If both expression evaluate to a double then add the two doubles and return the result
-- otherwise return the error that occurred in either expression
eval d (Add x y) = 
  case (eval d x, eval d y) of
    (Right m, Right n) -> Right (m+n)
    (Left m, _) -> Left m
    (_, Left n) -> Left n

-- If both expression evaluate to a double then subtract the two doubles and return the result
-- otherwise return the error that occurred in either expression
eval d (Sub x y) = 
  case (eval d x, eval d y) of
    (Right m, Right n) -> Right (m-n)
    (Left m, _) -> Left m
    (_, Left n) -> Left n

-- If both expression evaluate to a double then multiply the two doubles and return the result
-- otherwise return the error that occurred in either expression
eval d (Mul x y) = 
  case (eval d x, eval d y) of
    (Right m, Right n) -> Right (m*n)
    (Left m, _) -> Left m
    (_, Left n) -> Left n

-- If both expression evaluate to a double then divide the two doubles and return the result
-- otherwise return the error that occurred in either expression
eval d (Dvd x y) = 
  case (eval d x, eval d y) of
    (Right m, Right n) -> if n == 0.0 then Left "div by zero" else Right (m/n)
    (Left m, _) -> Left m
    (_, Left n) -> Left n

-- If e1 evaluates to a double then add it to the dictionary with the key x and evaluate e2 with the new EDict
-- otherwise return the error that occurred when evaluating e1
eval d (Def x e1 e2) = 
  case eval d e1 of
    Right m -> eval (define d x m) e2
    Left m -> Left m

-- Part 1 : Expression Laws -- (15 test marks, worth 15 Exercise Marks) --------

{-

There are many, many laws of algebra that apply to our expressions, e.g.,

  x + y         =   y + z            Law 1
  (x + y) + z   =   x + (y + z)      Law 2
  (x - y) - z   =   x - (y + z)      Law 3
  x*x - y*y     =   (x + y)*(x - y)  Law 4
  ...

  We can implement these directly in Haskell using Expr

  Function LawN takes an expression:
    If it matches the "shape" of the law lefthand-side,
    it replaces it with the corresponding righthand "shape".
    If it does not match, it returns Nothing

    Implement Laws 1 through 4 above
-}

-- if expr is x + y return Just y + x otherwise return Nothing
law1 :: Expr -> Maybe Expr
law1 e = 
  case e of 
    (Add x y) -> Just (Add y x)
    _         -> Nothing

-- if expr is (x + y) + z return Just x + (y + z) otherwise return Nothing
law2 :: Expr -> Maybe Expr
law2 e = 
  case e of
    (Add (Add x y) z) -> Just (Add x (Add y z))
    _                 -> Nothing

-- if expr is (x - y) - z return Just x - (y + z) otherwise return Nothing
law3 :: Expr -> Maybe Expr
law3 e = 
  case e of
    (Sub (Sub x y) z) -> Just (Sub x (Add y z))
    _                 -> Nothing

-- if expr is x*x - y*y return Just (x + y)*(x - y) otherwise return Nothing
law4 :: Expr -> Maybe Expr
law4 e =
  case e of
    (Sub (Mul x x') (Mul y y')) -> if x==x' && y==y' then Just (Mul (Add x y) (Sub x' y')) else Nothing
    _                 -> Nothing
