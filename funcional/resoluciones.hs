--Martes 03/09

--1)
--I)
--max2 :: (Float,Float) -> Float;
max2 (x,y) | x >= y = x | otherwise = y;


--normaVectorial :: (Float,Float) -> Float
normaVectorial (x,y) = sqrt (x^2 + y^2)


--subtract :: (Float,Float) -> Float NOP! tiene el tipo de -
--subtract :: Float -> Float -> Float
subtract = flip (-)


--predecesor :: Float -> Float
predecesor = Main.subtract 1


--o bien toma una funcion que toma un float y devuelve otro float, o una
--funcion que toma un float y devuelve una funcion... las dos funcionan.
--la funcion que toma no puede tomar tuplas porque en evaluarEnCero
--estamos evaluandolo en cero y no en una tupla, asi que si o si la
--funcion que toma tiene que tomar floats... osea si es "multivariable",
--lo es tomando un parametro y devolviendo una funcion
--evaluarEnCero :: (Float -> Float) -> Float
--podria "tomar" mas floats, osea, devolver mas funciones intermedias hasta
--el float...
evaluarEnCero = \f -> f 0
--ghci dice "(Integer -> t) -> t", me imagino que t puede ser un tipo
--"primitivo", u otra funcion


--dosVeces :: (t -> t) -> t -> t
dosVeces = \f -> f.f


--flipAll :: xss -> xss
flipAll = map flip
--claro, flip no es de listas, es de funciones...
--map toma lista y devuelve lista, flip toma funcion luego:
--flipAll :: [a -> b -> c] -> [a -> b -> c]
--y son a,b,c porque no tengo ninguna restriccion sobre sus tipos


--flipRaro :: (a -> b -> c) -> a -> b -> c
flipRaro = flip flip
--no entiendo!!!!!!!!!!!!!!!!!!!


--II)
--la primera no esta currificada
cmax2 x = \y -> case () of 
    _ | x >= y -> x
      | otherwise -> y
--esta era la idea? !!!!!!!!!!!



--2)
--I)
curry' f a b = f(a,b)
--II)
uncurry' f (a,b) = f a b
--III)
--a menos de que haskell tenga algo en particular para "abstraer" los n
--argumentos, no veo una solucion... con "abstraer" me fiero a por ejemplo
--pasar los n argumentos a una lista, o hacer recursion sacan de a un
--argumento... esta bien esto? !!!!!!!!


--3)
--da [1,3] lo que me hace concluir que la manera en usar el y y la guarda
--no es un para todo si no un para cada uno, digamos

--4)
--no es ultil porque se queda infinitamente tomando valores para c, y nunca
--agrega ni un valor a la lista
--pitagoricas x = [(a, b, c) | a <- [1..x], b <-[1..a], c <- [1..b], a^2 + b^2 == c^2]
--MAL nunca se va a dar porque como c llega hasta b, c^2 siempre va a ser mas chico
--que a^2+b^2...
pitagoricas x = [(a, b, c) | c <- [1..x], a <-[1..c], b <- [1..c], a^2 + b^2 == c^2]
--ahora si, cada valor fijo de c a y b van a llenarse antes de seguir con otor c


--5)
divisores n = [x | x<-[2..n], n `mod` x == 0]
esPrimo n = (length (divisores n)) == 1
primos n = [x | x <- [2..n], esPrimo x]


--10)
--I)
fsum xs = foldr (+) 0 xs
felem x xs = foldr (\y b -> x == y || b) False xs




--17)
--I)
--que es foldNat??? !!!!!!!!!


--o===========o
--Viernes 06/09

--7)
listasQueSuman :: Int -> [[Int]]
listasQueSuman 0 = [[]]
listasQueSuman n = [(x:xs) | x <- [1..n], y <- [x..n], xs <- listasQueSuman(n-y), x + sum xs == n]

listasQueSuman2 :: Int -> [ [Int] ]
listasQueSuman2 0 = [[]]
listasQueSuman2 n = [(x:xs) | x<-[1..n],xs<-listasQueSuman (n-x)]


--8)
listasPositivas :: [[Int]]
listasPositivas = [xs | n <- [1..], xs <- listasQueSuman2(n)]




--9)
--no termino de entender la sintaxis de los esq de recr !!!!!!!!!!!!!!!!!!!!
type DivideConquer a b = (a -> Bool)
                        -> (a -> b)
                        -> (a -> [a])
                        -> ([b] -> b)
                        -> a
                        -> b

--I)
dc :: DivideConquer a b
dc trivial solve split combine x = if trivial x
    then solve x
    else combine [dc trivial solve split combine s | s <- split x ]

--II)
--splitList :: [a] -> ([a], [a])
--splitList myList = splitAt (((length myList) + 1) `div` 2) myList

--combineList :: Ord a => [[a]] -> [a]
--combineList xs:ys:xss -> [ x | x <- xs, y <- ys, x <= y]++[ y | y <- ys, x <- xs, y <= x]

--mergeSort :: Ord a => [a] -> [a]
--mergeSort xs = dc (((==) 1) length xs)
--                id
--                splitList



--10)
--I)
--antes de (++) 03/09
concatenacion xs ys = foldr (:) ys xs
ffilter f xs = foldr (\x -> if f x then ([x]++) else ([]++)) [] xs
--ffmap f xs = foldr (:).(\x -> f x) [] xs
--la version de arriba no nada, toma el [] para el (:)??
--pero de ser asi, cual es la funcion o el caso base para foldr??!!!!!!
ffmap f xs = foldr ((:).(\x -> f x)) [] xs

--II)
mejorSegun :: (a -> a -> Bool) -> [a] -> a
mejorSegun f xs = foldr1 (\x y -> if f x y then x else y) xs

--III)
sumasParciales :: Num a => [a] -> [a]
sumasParciales xs = [sum (take n xs) | n <-[1..(length xs)]]

--IV)
sumaAlt :: Num a => [a] -> a
sumaAlt = foldr (-) 0

--V)
sumaAltInv :: Num a => [a] -> a
sumaAltInv xs = sumaAlt (reverse xs)

--VI)
--permutaciones :: [a] -> [[a]]
--permutaciones

--takeSome xs = [ take n xs | n <- [1..(length xs)]]
--dropSome xs = [ drop n xs | n <- [1..(length xs)]]


--12)
recr::(a->[a]->b->b)->b->[a]->b
recr _ z [] = z
recr f z (x:xs) = f x xs (recr f z xs)

--a)
sacarUna :: Eq a => a -> [a] -> [a]
sacarUna y ys = reverse (recr (\x xs bs -> if (x == y && not (elem y xs)) then bs else x:bs) [] (reverse ys))

--b)
--no podria distinguir si ya saque el elemento o no, no tengo acceso a a lista

--c)
insertarOrdernado :: Ord a => a -> [a] -> [a]
insertarOrdernado y ys = recr (\x xs bs -> if (y >= x && not (elem y bs)) then x:y:bs else x:bs) [] ys

--d)



--14)
--I)
mapPares :: (a -> b -> c) -> [(a, b)] -> [c]
mapPares f xs= map (uncurry f) xs

mapPares2 :: (a -> b -> c) -> [(a, b)] -> [c]
mapPares2 f ys= recr (\x xs bs -> (f (fst x) (snd x)):bs) [] ys

--II)

--recr2 _ z [] [] = z
--recr2 f z (x:xs) (y:ys) = f x y xs ys (recr f z xs ys)

--armarPares xs ys = recr (\x ls bs -> (recr (\y yls ybs -> meterParSinRepetir x y ybs)) [] xs
armarPares :: [a] -> [b] -> [(a,b)]
armarPares [] [] = []
armarPares (x:xs) (y:ys) = (x,y): (armarPares xs ys)
--no se me ocurre zip...


--III)
mapDoble f xs ys = mapPares2 f (armarPares xs ys)


--16)
generate :: ([a] -> Bool) -> ([a] -> a) -> [a]
generate stop next = generateFrom stop next []

generateFrom:: ([a] -> Bool) -> ([a] -> a) -> [a] -> [a]
generateFrom stop next xs | stop xs = init xs
    | otherwise = generateFrom stop next (xs ++ [next xs])

--I)
