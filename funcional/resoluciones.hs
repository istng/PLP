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
-- else combine $ map (dc trivial solve split combine) (split x)

--II)
--splitList :: [a] -> ([a], [a])
--splitList myList = splitAt (((length myList) + 1) `div` 2) myList

--combineList :: Ord a => [[a]] -> [a]
--combineList xs:ys:xss = [ x | x <- xs, y <- ys, x <= y]++[ y | y <- ys, x <- xs, y <= x]

--mergeSort :: Ord a => [a] -> [a]
--mergeSort xs = dc (((==) 1) length xs)
--                id
--                splitList



--10)
--I)
--antes de (++) 03/09
concatenacion xs ys = foldr (:) ys xs
--ffilter f xs = foldr (\x bs -> (if f x then ([x]++) else ([]++) bs)) [] xs
--ffmap f xs = foldr (:) . $ (\x -> f x) [] xs
--la version de arriba no anda, toma el [] para el (:)??
--pero de ser asi, cual es la funcion o el caso base para foldr??!!!!!!
--ffmap f xs = foldr ((:).(\x -> f x)) [] xs
--ffmap f = foldr ((:).f) []
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



--o==========o
--Martes 10/09

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
aplicarAlUltimo :: (a -> a) -> a -> [a] -> a
aplicarAlUltimo f z xs = if length xs == 0 then z else f (last xs)

generateBase::([a] -> Bool) -> a -> (a -> a) -> [a]
generateBase stop z next = generate stop (\xs -> if length xs == 0 then z else next (last xs))

--II)
factoriales :: Int -> [Int]
factoriales n = generate (\xs -> length xs > n) (\xs -> if length xs == 0 then 1 else last xs * (length xs + 1))

--III)
iterateN :: Int -> (a -> a) -> a -> [a]
iterateN n f x= generateBase (\xs -> length xs > n) x f

iterateProof n f x = take n (iterate f x)

--IV)
aux :: ([a]->a)->[a]->[a]
aux f xs = xs ++ (take 1 (iterate id (f xs)));

generateFrom' stop next xs = last $
    takeWhile (not.stop) $
    iterate (\l -> l++[next l]) xs
--aux f xs = xs ++ [f xs]
--generateFrom' :: ([a] -> Bool) -> ([a] -> a) -> [a] -> [a]
--generateFrom' stop next xs = takeWhile (\_ -> stop xs) (aux next xs)
--stop toma xs, como puedo hacer que sea efectivo en xs y sirva como guarda del takeWhile?!!!!!!!



--17)
--I)
--de la teorica
foldNat :: (b -> b) -> b -> Integer -> b
foldNat s z 0 = z
foldNat s z n = s (foldNat s z (n-1))

--II)
potencia :: Num a => a -> Integer -> a
potencia x n = foldNat ((*)x) x (n-1)


--19)
type Conj a = (a -> Bool)
--I)
vacio :: Conj a
vacio x = False

agregar :: Eq a => a -> Conj a -> Conj a
agregar x c = \y -> if y /= x then c y else True

--II)
interseccion :: Conj a -> Conj a -> Conj a
interseccion c d = \x -> c x && d x

union :: Conj a -> Conj a -> Conj a
union c d = \x -> c x || d x

--III)
todos :: Conj (Int -> Int)
todos = \f -> (<) 0 (f 3)

--IV)
singleton :: Eq a => a -> Conj a
singleton x = agregar x vacio

--V)
--aparentemente no, ya que la unica manera que
--no se me ocurre una manera de saber que elementos
--tengo en un conjunto dado, mas que preguntar
--uno por uno todos los que pueden existir de
--ese tipo de a


--21)
data AHD tInterno tHoja = Hoja tHoja
    | Rama tInterno (AHD tInterno tHoja)
    | Bin (AHD tInterno tHoja) tInterno (AHD tInterno tHoja)

--I)
--foldAHD :: (tInterno -> tInterno) -> (tHoja -> tHoja) -> (AHD tInterno tHoja) -> (AHD tInterno tHoja)
--el AHD original podria ser de tipos distintos al devuelto por el fold, creo?
--foldAHD :: (ti -> tInterno) -> (th -> tHoja) -> Bin (AHD ti th) ti (AHD ti th) ->  -> (AHD ti th) -> (AHD tInterno tHoja)
--no necesariamente devuelve el mismo tipo con el que entro un fold, en este caso
--un AHD...
foldAHD :: (th -> t) -> (ti -> t -> t) -> (t -> ti -> t -> t) -> (AHD ti th) -> t
foldAHD fHoja fRama fBin ahd = case ahd of
    Hoja h -> fHoja h
    Rama r a -> fRama r (rec a)
    Bin i m d -> fBin (rec i) m (rec d)
    where rec = foldAHD fHoja fRama fBin

--shownacho ahd = foldAHD (\h -> ["Hoja ",h])
--                   (\r a -> ["Rama ",r,a])
--                   (\i m d -> ["Bin ",i,m,d])

{-instance Show (AHD tInterno tHoja) where
    show = foldAHD (\h -> "Hoja " ++ (show h))
                   (\r a -> "Rama " ++ (show r) ++ a)
                   (\i m d -> "Bin " ++ i ++ (show m) ++ d)
-}
{-
--II)
mapAHD :: (a -> b) -> (c -> d) -> AHD a c -> AHD b d
mapAHD fnodos fhojas = foldAHD fnodos fhojas-}


--23)
--I)
data RoseTree t = RHoja t | RNodo t [RoseTree t] deriving Show

--II)
recRoseTree :: (Int -> b) -> (Int -> [b] -> Int -> [RoseTree Int] -> b) -> (RoseTree Int) -> b
recRoseTree fhoja fnodo rosetree = case rosetree of
    RHoja h -> fhoja h
    RNodo n rs -> fnodo n (map rec rs) n rs
    where rec = recRoseTree fhoja fnodo

--III)
--a)
flatten xss = foldr (++) [] xss

hojas = recRoseTree (\h -> [h])
                    (\n ns m rs -> flatten ns)