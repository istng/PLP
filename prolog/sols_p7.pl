
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
concatenar(XS,[],XS).
concatenar([X|XS],YS,[X|L]):- concatenar(XS, YS, L).

%5)
%I)
last([X|[]], X).
last([X|XS], U):- last(XS,U).

%II)
reverse([],[]).
reverse([X|XS],L):- reverse(XS, R), concatenar(R, [X], L).

%III)
prefijo([],_).
prefijo([X|XS],[Y|YS]):- X =:= Y, prefijo(XS,YS).

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
aplanar([],[]).
aplanar([[]],[]).
aplanar([[X]|XS],[X|XS]).
aplanar([X|XS],L):- aplanar(X,Xa), aplanar(XS,XA), concatenar(Xa,XA,L).