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


