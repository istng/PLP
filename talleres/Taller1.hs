import Data.List
import Test.HUnit

data Proposition = Var String | Not Proposition | And Proposition Proposition | Or Proposition Proposition | Impl Proposition Proposition deriving Eq

type Assignment = String -> Bool

recProp :: (String -> b) -> (b -> Proposition -> b) -> (b -> b -> Proposition -> Proposition-> b) -> (b -> b -> Proposition -> Proposition -> b) -> (b -> b -> Proposition -> Proposition -> b) -> Proposition -> b
recProp fVar fNot fAnd fOr fImpl prop = case prop of
  Var a      -> fVar a 
  Not p      -> fNot (rec p) p
  And p1 p2  -> fAnd (rec p1) (rec p2) p1 p2
  Or p1 p2   -> fOr (rec p1) (rec p2) p1 p2
  Impl p1 p2 -> fImpl (rec p1) (rec p2) p1 p2
  where rec = recProp fVar fNot fAnd fOr fImpl

foldProp :: (String -> b) -> (b -> b) -> (b -> b -> b) -> (b -> b -> b) -> (b -> b -> b) -> Proposition -> b
foldProp fVar fNot fAnd fOr fImpl prop = case prop of
  Var a      -> fVar a 
  Not p      -> fNot (rec p)
  And p1 p2  -> fAnd (rec p1) (rec p2)
  Or p1 p2   -> fOr (rec p1) (rec p2)
  Impl p1 p2 -> fImpl (rec p1) (rec p2)
  where rec = foldProp fVar fNot fAnd fOr fImpl

instance Show Proposition where
  show = foldProp id
                  (\r     -> "¬" ++ r)
                  (\r1 r2 -> "(" ++ r1 ++ " ∧ " ++ r2 ++ ")")
                  (\r1 r2 -> "(" ++ r1 ++ " ∨ " ++ r2 ++ ")")
                  (\r1 r2 -> "(" ++ r1 ++ " ⊃ " ++ r2 ++ ")")


  --Códigos Unicode para simbolitos por si hay problemas de codificación:  \172, \8835, \8743, \8744.
  
assignTrue :: [String] -> Assignment
assignTrue = flip elem

eval :: Assignment -> Proposition -> Bool
eval f = foldProp f not (&&) (||) (\p q -> (not p) || q)

elimImpl :: Proposition -> Proposition
elimImpl = foldProp Var
                    Not
                    And
                    Or
                    (\r1 r2 -> Or (Not r1) r2)

negateProp :: Proposition -> Proposition
negateProp = recProp (\s -> Not (Var s))
                      (\r p -> p)
                      (\r1 r2 p1 p2 -> Or r1 r2)
                      (\r1 r2 p1 p2-> And r1 r2)
                      (\r1 r2 p1 p2-> And p1 r2)
                     {- where recneg r1 = (case r1 of
                              Var p -> Not (Var p)
                              Not p -> p
                              Or p1 p2 -> And p1 p2
                              And p1 p2 -> Or p1 p2
                              Impl p1 p2 -> And p1 p2)
-}
nnf :: Proposition -> Proposition
nnf = foldProp (\s -> (Var s))
                      (\r -> (negateProp r))
                      (\r1 r2 -> And (r1) (r2))
                      (\r1 r2 -> Or (r1) (r2))
                      (\r1 r2 -> Or (negateProp r1) r2)

deleteDuplicates :: (Eq a) => [a] -> [a]
deleteDuplicates = foldr (\x r -> if (elem x r) then r else (x:r)) []

vars :: Proposition -> [String]
vars p = deleteDuplicates (foldProp (\s -> [s])
                                    id
                                    (\r1 r2 -> r1 ++ r2)
                                    (\r1 r2 -> r1 ++ r2)
                                    (\r1 r2 -> r1 ++ r2) p)

parts :: [a] -> [[a]]
parts = foldr (\x recr -> (map (x:) recr) ++ recr) [[]]

sat :: Proposition -> [[String]]
sat p = filter (\x -> eval (assignTrue x) p) (parts (vars p))

satisfiable :: Proposition -> Bool
satisfiable p = length (sat p) > 0

tautology :: Proposition -> Bool
tautology p = length (sat p) == length (parts (vars p))

equivalent :: Proposition -> Proposition -> Bool
equivalent p q = tautology (And (Impl p q) (Impl q p))

-- Proposiciones de prueba --

f1 = Impl (Var "p") (Var "q")
f2 = Not(Impl (Var "p") (Var "q"))
f3 = Not (Var "p")
f4 = Or f1 f2
f5 = Impl (Var "r") (Var "r")


-- Tests
contains [] y = True
contains (x:xs) y = elem x y && contains xs y

equals x y = contains x y && contains y x

main :: IO Counts
main = do runTestTT allTests

allTests = test [
  "ejercicio1" ~: testsEj1,
  "ejercicio2" ~: testsEj2,
  "ejercicio3" ~: testsEj3,
  "ejercicio4" ~: testsEj4,
  "ejercicio5" ~: testsEj5,
  "ejercicio6" ~: testsEj6
  ]

testsEj1 = test [
  5 ~=? foldProp (const 1) (+1) (+) (+) (+) f4
  ]
  
testsEj2 = test [
  "\172(p \8835 q)"~=? show f2
  ]

testsEj3 = test [
  True ~=? (assignTrue ["p", "q"]) "p",
  True ~=? assignTrue ["p", "q"] "q",
  False ~=? assignTrue ["p", "q"] "h"
  ]

testsEj4 = test [
  True ~=?  eval (assignTrue ["p","q"]) (Impl (And (Var "p") (Var "r")) (And (Not (Var "q")) (Var "q")))
  ]

testsEj5 = test [
  Var "q" ~=?  negateProp (Not $ Var "q"),
  And (Not (Var "p")) (Not (Var "q")) ~=?  negateProp (Not (And (Not (Var "p")) (Not (Var "q")))),
  (And (Var "p") (Not (Var "q"))) ~=? negateProp (Impl (Var "p") (Var "q")),
  Var "p" ~=?  nnf (Not $ Not $ Var "p")
  ]

testsEj6 = test [
  True ~=? equals ["p", "q"] (vars (And (Var "p") (Var "q"))),
  [[1,2,3],[1,2],[1,3],[1],[2,3],[2],[3],[]] ~=? parts [1,2,3],
  True ~=? equals [["p","q"],[],["q"]] (sat ( (Impl (Var "p") (Var "q")))),
  True ~=? satisfiable (Impl (Var "p") (Var "q")),
  False ~=? satisfiable (And (Not (Var "p")) (Var "p")),
  True ~=? tautology (Or (Var "p") (Not (Var "p"))),
  True ~=? equivalent (Impl (Var "p") (Var "q")) (Impl (Not (Var "q")) (Not (Var "p"))),
  False ~=? equivalent (Var "p") (Var "q")
  ]






















