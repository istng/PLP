
%Ej 1

padre(juan, carlos).
padre(juan, luis).
padre(carlos, daniel).
padre(carlos, diego).
padre(luis,pablo).
padre(luis,manuel).
padre(luis,ramiro).
abuelo(X,Y):- padre(X,Z), padre(Z,Y).

%I) El resultado será "juan", ya que el padre de manuel es luis, y
%tanto manuel como luis no tienen ningún otro padre.

%II)
hijo(X,Y):- padre(Y,X).
hermano(X,Y):- padre(Z,X), padre(Z,Y).
descendiente(X,Y):- padre(Y,X).
descendiente(X,Y):- padre(Y,Z), descendiente(X,Z).
%La idea básicamente es: dame todos los hijos de Y, y después dame todos los
%hijos de Y devuelta, dandome ahora toda la descendencia de cada hijo.

%IV)
%abuelo(juan,Y).

%V)
%hermano(pablo,Y).

%VI)
%ancestro(X, X).
%ancestro(X, Y) :- ancestro(Z, Y), padre(X, Z).

%VII) Se cuelga y termian excediendo el stack.

%VIII) Tamién dando vuelta las reglas. Como está originalmente nunca
%instancia Z, se la vive entrando en ancestro...
ancestro(X,Y):- descendiente(Y,X).


%3)

natural(0).
natural(suc(X)) :- natural(X).
%menorOIgual(X, suc(Y)) :- menorOIgual(X, Y).
menorOIgual(X,X) :- natural(X).

%I) Se cuelga y excede el stack.

%II) Se cuelga cuando no puede unificar las variables instanciadas con nada en
%la circunstancia de entrar recursivamente a una función

%III) Cambiando el orden...
menorOIgual(X, suc(Y)) :- menorOIgual(X, Y).


%4)
concatenar([],YS,YS).
concatenar([X|XS],YS,[X|L]):- concatenar(XS, YS, L).

%5)
%I)
last([X|[]], X).
last([X|XS], U):- last(XS,U).

%II)
reverse([],[]).
reverse([X|XS],L):- reverse(XS, R), append(R, [X], L).

%III)
prefijo([],_).
prefijo([X|XS],[X|YS]):- prefijo(XS,YS).

prefijo2(XS,YS):- concatenar(XS,L,YS).

%IV)
sufijo(XS,YS):- reverse(XS,XR), reverse(YS,YR), prefijo(XR,YR).

sufijo2(S, L):-prefijo(P,L),append(P, S, L).

%V)
sublista(S,L):- prefijo(S,L).
sublista(S,[U|L]):- sublista(S,L).

%VI)
pertenece(X,[X|L]).
pertenece(X,[_|L]):- pertenece(X,L).


%6)
esLista([X|XS]).
esLista([]).

aplanar([],[]).
aplanar([X|XS], LS):- aplanar(X,PX), aplanar(XS,PXS), append(PX,PXS,LS).
aplanar(X,[X]):- not(esLista(X)).


%8)
%I)
todasLasMezclas(L1,L2,L3):- concatenar(LP1,_,L1), concatenar(LP2,_,L2), 
  concatenar(LP1,LP2,L3).
estanTodos([],_,_).
estanTodos([X|L3],L1,L2) :- member(X,L1), member(X,L2), estanTodos(L3,L1,L2).
interseccion(L1,L2,L3):- todasLasMezclas(L1,L2,L3), estanTodos(L3,L1,L2).


interseccion2([],_,[],_).
interseccion2([X|L1],L2,L3,U):- not(member(X,L2)), interseccion2(L1,L2,L3,U).
interseccion2([X|L1],L2,[X|L3],U):- member(X,L2), not(member(X,U)), interseccion2(L1,L2,L3,[X|U]).
interseccion2([X|L1],L2,L3,U):- member(X,U), interseccion2(L1,L2,L3,U).
interseccionFinal(L1,L2,L3):- interseccion2(L1,L2,L3,[]).


partir(0,_,L1,L1).
partir(N,[X|L],L1,[X|L2]):- M is N-1, partir(M,L,L1,L2).
%N no es reversible porque nunca temrinaría de instanciarlo. L1 lo es, pero
%no busca una instanciación si no que deja la variable ya que es lo que entra.

%II)
borrar([],_,[]).
borrar([Y|LO],X,[Y|LS]):- Y \= X, borrar(LO,X,LS).
borrar([X|LO],X,LS):- borrar(LO,X,LS).

%III)
sacarDuplicadosAux([],[],_).
sacarDuplicadosAux([X|L1],L2,U):- member(X,U), sacarDuplicadosAux(L1,L2,U).
sacarDuplicadosAux([X|L1],[X|L2],U):- not(member(X,U)), sacarDuplicadosAux(L1,L2,[X|U]).
sacarDuplicados(L1,L2):- sacarDuplicadosAux(L1,L2,[]).

%IV)
permutacionAux([],[]).
permutacionAux([X|L1],L2):- member(X,L2), borrar(L1,X,LB1), borrar(L2,X,LB2), permutacionAux(LB1,LB2).
permutacion(L1,L2):- length(L1,N1), length(L2,N2), N1 =:= N2, permutacionAux(L1,L2).

%V)
listar([],[]).
listar([L|LListas],LL):- concatenar(L,Z,LL), listar(LListas,Z).
reparto(L,N,LListas):- length(LListas,LN), LN =:= N, listar(LListas,LL), L = LL.

%VI)
listarSV([],[]).
listarSV([L|LListas],LL):- concatenar(L,Z,LL), length(L,N), N =\= 0, listarSV(LListas,Z).
repartoSinVacias(L,LListas):- listarSV(LListas,LL), L = LL.


%10)
desde(X,X).
desde(X,Y) :- N is X+1, desde(N,Y).

%I) Con Y mayor a X, si no, nunca va a unificar y va a continuar llamandose con el +1.

%II)
desde3(X, Y) :-nonvar(Y),Y >= X.
desde3(X,Y) :-var(Y),desde(X,Y).


%12)

arbolito(bin(bin(bin(nil,4,nil),2,bin(bin(nil,6,nil),5,nil)),1,bin(nil,3,bin(nil,7,nil)))).

vacio(nil).
raiz(bin(_,X,_),X).

maximo(X,Y,X):- X >= Y.
maximo(X,Y,Y):- X < Y.

altura(nil,0).
altura(bin(nil,_,nil),1).
altura(bin(Izq,_,Der),N):- altura(Izq,I), altura(Der,D), maximo(I,D,L), N is L+1.

cantidadDeNodos(nil,0).
cantidadDeNodos(bin(nil,_,nil),1).
cantidadDeNodos(bin(Izq,_,Der),N):- cantidadDeNodos(Izq,I), cantidadDeNodos(Der,D), L is I+D, N is L+1.


%13)
%I)
inorder(nil,[]).
%inorder(bin(nil,V,nil), [V]).
inorder(bin(Izq,V,Der),L):- inorder(Izq, LI), inorder(Der, LD), concatenar(LI,[V],Z), concatenar(Z,LD,L).

%II)
arbolConInorder(L,AB):-inorder(AB,L).

%III)
abb(bin(bin(bin(nil,1,nil),5,bin(bin(nil,6,nil),7,nil)),10,bin(nil,11,bin(nil,13,nil)))).


maxValue(bin(nil,V,nil),V).
maxValue(bin(Izq,V,nil),V):- maxValue(Izq, I), V >= I.
maxValue(bin(Izq,V,nil),I):- maxValue(Izq, I), I > V.
maxValue(bin(nil,V,Der),V):- maxValue(Der, D), V >= D.
maxValue(bin(nil,V,Der),D):- maxValue(Der, D), D > V.
maxValue(bin(Izq,V,Der),V):- maxValue(Izq, I), maxValue(Der, D), V >= I, V >= D.
maxValue(bin(Izq,V,Der),I):- maxValue(Izq, I), maxValue(Der, D), I >= V, I >= D.
maxValue(bin(Izq,V,Der),D):- maxValue(Izq, I), maxValue(Der, D), D >= V, D >= I.


minValue(bin(nil,V,nil),V).
minValue(bin(Izq,V,nil),V):- minValue(Izq, I), I >= V.
minValue(bin(Izq,V,nil),I):- minValue(Izq, I), V > I.
minValue(bin(nil,V,Der),V):- minValue(Der, D), D >= V.
minValue(bin(nil,V,Der),D):- minValue(Der, D), V > D.
minValue(bin(Izq,V,Der),V):- minValue(Izq, I), minValue(Der, D), I >= V, D >= V.
minValue(bin(Izq,V,Der),I):- minValue(Izq, I), minValue(Der, D), V >= I, D >= I.
minValue(bin(Izq,V,Der),D):- minValue(Izq, I), minValue(Der, D), V >= D, I >= D.


aBB(nil).
aBB(bin(nil,_,nil)).
aBB(bin(Izq,V,nil)):- maxValue(Izq,I), V >= I, aBB(Izq).
aBB(bin(nil,V,Der)):- minValue(Der,D), D >= V, aBB(Der).
aBB(bin(Izq,V,Der)):- maxValue(Izq,I), minValue(Der,D), V >= I, D >= V, 
  aBB(Izq), aBB(Der).


%IV) quizá le faltaría chequear que sea aBB, pero es agregar una condición...
aBBInsertar(X,bin(nil,V,nil),bin(bin(nil,X,nil),V,nil)):- V >= X.
aBBInsertar(X,bin(nil,V,nil),bin(nil,V,bin(nil,X,nil))):- X > V.
aBBInsertar(X,bin(Izq,V,nil),bin(T2,V,nil)):- V >= X, aBBInsertar(X,Izq,T2).
aBBInsertar(X,bin(nil,V,Der),bin(nil,V,T2)):- X >= V, aBBInsertar(X,Der,T2).
aBBInsertar(X,bin(Izq,V,Der),bin(T2,V,Der)):- V >= X, aBBInsertar(X,Izq,T2).
aBBInsertar(X,bin(Izq,V,Der),bin(Izq,V,T2)):- X >= V, aBBInsertar(X,Der,T2).


%14)
sonCoprimos(X,Y):- gcd(X,Y,R), R =:= 1.

generarPares(Y,Z):- desde3(0,X).

coprimos(X,Y):- generarPares(X,Y), sonCoprimos(X,Y).


%15)
%I)
sumaLista([],0).
sumaLista([X|XS],R):- sumaLista(XS,S), R = X+S.
dimension([],_).
dimension([X|XS],D):- length(X,D), dimension(XS,D).
cuadradoSemiLatinoAux2([],_).
cuadradoSemiLatinoAux2([X|XS],S):- sumaLista(X,S), cuadradoSemiLatinoAux2(XS,S).
cuadradoSemiLatino2(N, [X|XS]):- dimension([X|XS],N), sumaLista(X,S), cuadradoSemiLatinoAux2(XS,S).


entre(X,Y,X):- Y >= X.
entre(X,Y,Z):- Y > X, N is X+1, entre(N,Y,Z).

listasQueSuman([],_,0).
listasQueSuman([X|XS],D,S):-
  Dn is D-1,
  length(XS,Dn),
  entre(0,S,R),
  X is R,
  Sn is S-X,
  listasQueSuman(XS,Dn,Sn).

cuadradoSemiLatinoAux(_,0,[],_).

cuadradoSemiLatinoAux(N,D,[X|XS],S):-
  Dn is D-1,
  length(XS,Dn),
  listasQueSuman(X,N,S),
  cuadradoSemiLatinoAux(N,Dn,XS,S).

cuadradoSemiLatino(N,[X|XS]):- desde(0,S), cuadradoSemiLatinoAux(N,N,[X|XS],S).


%II)
primerosElems([],[]).
primerosElems([[L|LS]|XS],[L|YS]):- primerosElems(XS,YS).

colas([],[]).
colas([[L|LS]|XS],[LS|YS]):- colas(XS,YS).

sonVacias([]).
sonVacias([X|XS]):- length(X,0), sonVacias(XS).

traspuesta([],[]).
traspuesta(XS,[]):- sonVacias(XS).
traspuesta(XS,[T|TS]):- primerosElems(XS,T), colas(XS,CS), traspuesta(CS,TS).

cuadradoMagico(N,XS):- cuadradoSemiLatino(N,XS), traspuesta(XS,TS), cuadradoSemiLatino(N,TS).


%17)
frutal(manzana).
frutal(frutilla).
frutal(banana).
cremoso(americana).
cremoso(banana).
cremoso(frutilla).
cremoso(dulceDeLeche).

leGusta(X) :- frutal(X), cremoso(X).
cucurucho(X,Y) :- leGusta(X), leGusta(Y), !.


%18)
%I) Dado que los dos son verdad para cualquier variable instanciada o no instanciada,
%ocurre que negar una siempre dá false.
p(X).
q(X).

%II) Lo mismo...

%III)



%19)
diff(S,L1,L2):-
  sumaLista(L1,S1),
  sumaLista(L2,S2),
  S is abs(S1-S2).

corteParejo(L,C):-
  sumaLista(L,S),
  C is S/2.

corteMasParejo(L,L1,L2):- concatenar(L1,L2,L), corteParejo(L,C), diff(C,L1,L2).


%23)

%esNodo(+G,?X)
%esArista(+G,?X,?Y)

%I)

esArista(g,1,2).
esArista(g,2,3).
esArista(g,3,4).
esArista(g,1,5).
esArista(g,2,1).
esArista(g,3,2).
esArista(g,4,3).
esArista(g,5,1).

caminataPorGrafo(_,_,[],_).

caminataPorGrafo(G,D,LS,U):-
  esArista(G,D,X),
  member(U,X),
  caminataPorGrafo(G,D,LS,U).

caminataPorGrafo(G,D,[D|LS],U):-
  esArista(G,D,X),
  not(member(U,X)),
  caminataPorGrafo(G,X,LS,[X|U]).