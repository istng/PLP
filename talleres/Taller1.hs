import Data.List
import Test.HUnit

data Proposition = Var String | Not Proposition | And Proposition Proposition | Or Proposition Proposition | Impl Proposition Proposition deriving Eq

type Assignment = String -> Bool

-- recProp :: (String -> b) -> (b -> Proposition -> b) -> (b -> b -> Proposition -> Proposition-> b) -> (b -> b -> Proposition -> Proposition -> b) -> (b -> b -> Proposition -> Proposition -> b) -> Proposition -> b
recProp fVar fNot fAnd fOr fImpl prop = case prop of
  Var a      -> fVar a 
  Not p      -> fNot (w p) p
  And p1 p2  -> fAnd (w p1) (w p2) p1 p2
  Or p1 p2   -> fOr (w p1) (w p2) p1 p2
  Impl p1 p2 -> fImpl (w p1) (w p2) p1 p2
  where w = recProp fVar fNot fAnd fOr fImpl

--foldProp :: (String -> b) -> (b -> b) -> (b -> b -> b) -> (b -> b -> b) -> (b -> b -> b) -> Proposition -> b
foldProp fVar fNot fAnd fOr fImpl prop = case prop of
  Var a      -> fVar a 
  Not p      -> fNot (w p)
  And p1 p2  -> fAnd (w p1) (w p2)
  Or p1 p2   -> fOr (w p1) (w p2)
  Impl p1 p2 -> fImpl (w p1) (w p2)
  where w = foldProp fVar fNot fAnd fOr fImpl

instance Show Proposition where
  show = foldProp (\s     -> s)
                  (\r     -> " ¬" ++ r)
                  (\r1 r2 -> "( " ++ r1 ++ " ∧ " ++ r2 ++ " )")
                  (\r1 r2 -> "( " ++ r1 ++ " ∨ " ++ r2 ++ " )")
                  (\r1 r2 -> "( " ++ r1 ++ " ⊃ " ++ r2 ++ " )")


  --Códigos Unicode para simbolitos por si hay problemas de codificación:  \172, \8835, \8743, \8744.
  
assignTrue :: [String] -> Assignment
assignTrue = flip elem

eval :: Assignment -> Proposition -> Bool
eval f = foldProp f not (&&) (||) (\p q -> (not p) || q)

elimImpl :: Proposition -> Proposition
elimImpl = foldProp (\s -> Var s)
                    (\p -> Not p)
                    (\r1 r2 -> And r1 r2)
                    (\r1 r2 -> Or r1 r2)
                    (\r1 r2 -> Or (Not r1) r2)

negateProp :: Proposition -> Proposition
negateProp = foldProp (\s -> Not (Var s))
                      (\p -> negateProp p)
                      (\r1 r2 -> Or (negateProp r1) (negateProp r2))
                      (\r1 r2 -> And (negateProp r1) (negateProp r2))
                      (\r1 r2 -> And r1 (negateProp r2))

nnf :: Proposition -> Proposition
nnf = undefined

deleteDuplicates :: [a] -> [a]
deleteDuplicates = foldr (\x r -> if (elem x r) then r else (x:r)) []

vars :: Proposition -> [String]
vars p = deleteDuplicates (foldProp (\s -> [s])
                                    id
                                    (\r1 r2 -> r1 ++ r2)
                                    (\r1 r2 -> r1 ++ r2)
                                    (\r1 r2 -> r1 ++ r2) p)

parts :: [a] -> [[a]]
parts = undefined

sat :: Proposition -> [[String]]
sat = undefined

satisfiable :: Proposition -> Bool
satisfiable = undefined

tautology :: Proposition -> Bool
tautology = undefined

equivalent :: Proposition -> Proposition -> Bool
equivalent = undefined

-- Proposiciones de prueba --

f1 = Impl (Var "p") (Var "q")
f2 = Not(Impl (Var "p") (Var "q"))
f3 = Not (Var "p")
f4 = Or f1 f2
f5 = Impl (Var "r") (Var "r")


-- Tests
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
  0 ~=? 0 --Cambiar esto por tests verdaderos.
  ]

testsEj4 = test [
  True ~=?  eval (assignTrue ["p","q"]) (Impl (And (Var "p") (Var "r")) (And (Not (Var "q")) (Var "q")))
  ]

testsEj5 = test [
  Var "q" ~=?  negateProp (Not $ Var "q"),
  Var "p" ~=?  nnf (Not $ Not $ Var "p")
  ]

testsEj6 = test [
  [[1,2,3],[1,2],[1,3],[1],[2,3],[2],[3],[]] ~=? parts [1,2,3]
  ]

