//2)
//a)
let t = {ite: function(a,b){return a;}}
let f = {ite: function(a,b){return b;}}
//console.log(t.ite("hola","chau"));
//console.log(f.ite("hola","chau"));

//b)
t.mostrar = function(){return "Verdadero";}
f.mostrar = function(){return "Falso";}

//console.log(t.mostrar());
//console.log(f.mostrar());

//c)
t.not = function(){return f;}
f.not = function(){return t;}

//console.log(f.not().not().mostrar());

t.and = function(b){return b.ite(t,f);}
f.and = function(b){return this;}

//console.log(t.and(t).mostrar());
//console.log(t.and(f).mostrar());
//console.log(f.and(t).mostrar());
//console.log(t.and(f).mostrar());


//3)
//a)

let cero = {esCero: function(){return true;}}

function Sucesor(predecesor) {
  this.pred = predecesor;
  this.esCero = function(){
    return false;
  };
}

cero.succ = function(){
  return new Sucesor(this);
}

//let uno = new Sucesor(cero);
//console.log(cero.esCero());
//console.log(uno.esCero());
//console.log(uno.pred.esCero());
//let dos = cero.succ().succ();
//console.log(dos.esCero());
//console.log(dos.pred.esCero());
//console.log(dos.pred.pred.esCero());


//let succ = {esCero: function(){return false;}, pred:}

//b)

cero.toNumber = function(){return 0;}
//esto no funciono:
//Sucesor.toNumber = function(){return 1+this.pred.toNumber;}
//console.log(uno.toNumber());

function Sucesor(predecesor) {
  this.pred = predecesor;
  this.esCero = function(){
    return false;
  };
  this.succ = function(){
    return new Sucesor(this);
  }
  this.toNumber = function(){
    return 1+this.pred.toNumber();
  }
}

//let uno = new Sucesor(cero);
//let dos = cero.succ().succ();
//console.log(cero.toNumber());
//console.log(uno.toNumber());
//console.log(dos.toNumber());

//c)

function Sucesor(predecesor) {
  this.pred = predecesor;
  this.esCero = function(){
    return false;
  };
  this.succ = function(){
    return new Sucesor(this);
  }
  this.toNumber = function(){
    return 1+this.pred.toNumber();
  }
  this.for = function(f){
    this.pred.for(f);
    return f.eval(this);
  }
}

cero.for = function(f){
  return f.eval(this);
}

let f3 = { eval : function ( i ) { console . log ( i . toNumber ) }};
//console.log(cero.succ().succ().for(f3));



//4)

let Punto = {}
Punto.new = function(a,b){
  let p = {};
  p.x=a;
  p.y=b;
  p.mostrar = function(){
    return Punto.mostrar(this);
  }
  return p;
}

Punto.mostrar = function(o){
  return "Punto("+o.x+","+o.y+")";
}

//let p = Punto.new(1,2);
//let p2 = Punto.new(3,4);
//console.log(p.mostrar());
//console.log(p2.mostrar());
//Punto.mostrar = function(){return "unPunto";}
//console.log(Punto.mostrar());

//b)c)
let PuntoColoreado = {}
PuntoColoreado.new = function(a,b,color) {
  let p = Punto.new(a,b);
  p.c = color;
  return p;
}

//let px = PuntoColoreado.new(5,6,"amarillo");
//console.log(pc.mostrar());

//d)
//esto así por si sólo no tiene efecto
//Punto.moverX = function(u){
//  this.x+u;
//}
//otra alternativa es hacer como con mostrar(this), moverX(this,u)

Punto.new = function(a,b){
  let p = {};
  p.x=a;
  p.y=b;
  p.mostrar = function(){
    return Punto.mostrar(this);
  }
  p.moverX = function(u){
    this.x += u;
  }
  return p;
}

//px = PuntoColoreado.new(7,8);
//px.moverX(3);
//console.log(px.mostrar());


//5)

function Punto5(a,b) {
  this.x = a;
  this.y = b;

  this.moverX = function(u){
    this.x += u;
  }
}

Punto5.prototype.mostrar = function(){
  return "Punto("+this.x+","+this.y+")";
}

//let p = new Punto5(1,2);
//let p2 = new Punto5(13,2);
//console.log(p.mostrar());
//console.log(p2.mostrar());

function PuntoColoreado5(a,b,c){
  this.x = a;
  this.y = b;
  this.color = c;
}

PuntoColoreado5.prototype.__proto__ = Punto5.prototype;

//let pc = new PuntoColoreado5(1,2,"rojo");
//console.log(pc.mostrar());


//7)
function C1 () {};
C1 . prototype . g = " Hola " ;
function C2 () {};
C2 . prototype . g = " Mundo " ;
//a) Los dos mostraran "Mundo" porque se modificó el prototipo de C1, y
//tanto a como b iran a buscar la función g en sus prototipos ya que
//C1 como objeto no la tiene definida (mal, en (b) lo repienso).

let a = new C1 () ;
C1 . prototype = C2 . prototype
let b = new C1 () ;

C2.prototype.h = "c2";
//C1.prototype.h = "c1";

console . log ( a . g ) ;
console . log ( b . g ) ;
console . log ( a . h ) ;
console . log ( b . h ) ;
console.log(C1.prototype);

//b)
let c = new C1 () ;
C1 . prototype.g = C2 . prototype.g
let d = new C1 () ;
//console . log ( c . g ) ;
//console . log ( d . g ) ;

//Claro no. Cuando reemplazamos el prototype en (a), a seguía teniendo dónde
//buscar dentro de C1 la función g, ya que estaba definida, pero cunado
//cambiamos en el prototipo a la función g en C1, ahí pasó a usar la misma
//que C2...


//8)
let o1 = { x : 1};
let o2 = Object . create ( o1 ) ;
o2 . __proto__ . y = 2;
console . log ( o1 . y ) ;
//acá le encuentro sentido que muestre 2 porque se modifica el
//prototipo de o2, es decir, o1...
console . log ( o1 . x ) ;
o2 . __proto__ . x = 5;
console . log ( o1 . x ) ;


let q1 = { x : 1};
let q2 = { y : 2};
q1 . __proto__ . z = 3;
console . log ( q2 . z ) ; 
//devuelve 3... por qué lo busca como si estuviese relacionado con q1??