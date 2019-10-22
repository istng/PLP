//los ejercicios que no están aćá están en el cuaderno... no habían muchos

//4)
//a)
var Punto = {};
Punto.new = function(x,y) {
  var p = {};
  p.x = x;
  p.y = y;
  p.mostrar = function() {
    return Punto.mostrar(this);
  }
  return p;
}

Punto.mostrar = function(o) {
  return "Punto(" + o.x + "," + o.y + ")";
}

let p = Punto.new(1,2);
console.log(p.mostrar());
p.x = 3;
console.log(p.mostrar());
Punto . mostrar = function () { return " unPunto " };
console . log ( p . mostrar () ) ;


//b)
var PuntoColoreado = {};
PuntoColoreado.new = function(x,y) {
  var pc = {}
  pc.c = "rojo";
  var p = Punto.new(x,y);
  pc.x = p.x;
  pc.y = p.y;
  pc.mostrar = function() {
    return PuntoColoreado.mostrar(this);
  }
  return pc;
}

PuntoColoreado.mostrar = function(o) {
  return Punto.mostrar(o);
}

let p = PuntoColoreado.new(1 ,2) ;
console . log ( p . mostrar () ) ;
Punto . mostrar = function () { return " UnPunto " };
console . log ( p . mostrar () ) ;
PuntoColoreado . mostrar = function () { return " U n P u n t o C o l o r e a d o " };
console . log ( p . mostrar () ) ;

/*
//Alternativa

var PuntoColoreado = {};

PuntoColoreado.new = function(x,y){
	var p = Punto.new(x,y);
	p.color = "rojo";
	p.mostrar = function(){
		return PuntoColoreado.mostrar(this);
	};
		return p;
};

PuntoColoreado.mostrar = function(o) {
	return Punto.mostrar(o);
};
*/

//c)
var PuntoColoreado = {};
PuntoColoreado.new = function(x,y,c) {
  var pc = {}
  pc.c = c;
  var p = Punto.new(x,y);
  pc.x = p.x;
  pc.y = p.y;
  pc.mostrar = function() {
    return PuntoColoreado.mostrar(this);
  }
  return pc;
}

PuntoColoreado.mostrar = function(o) {
  return Punto.mostrar(o) + " con color: " + o.c;
}

let p = PuntoColoreado.new(1,2,"amarillo");
console.log(p.mostrar());


//d)
//solo se me ocurre agregar al new la función nueva, y eso sería antes e crear p1 y pc1... y eso funciona
var Punto = {};

Punto.new = function(x,y) {
  var p = {};
  p.x = x;
  p.y = y;
  p.mostrar = function() {
    return Punto.mostrar(this);
  }
  return p;
}

Punto.mostrar = function(o) {
  return "Punto(" + o.x + "," + o.y + ")";
}

var PuntoColoreado = {};

PuntoColoreado.new = function(x,y,c){
	var p = Punto.new(x,y);
	p.color = c;
	p.mostrar = function(){
		return PuntoColoreado.mostrar(this);
	};
		return p;
};

PuntoColoreado.mostrar = function(o) {
	return Punto.mostrar(o) + " con color: " + o.color;;
};

let p1 = Punto . new (1 ,2) ;
let pc1 = PuntoColoreado . new (1 ,2) ;

Punto.moverX = function(o,u) {
  o.x += u;
}

let p2 = Punto . new (1 ,2) ;
let pc2 = PuntoColoreado . new (1 ,2) ;

console.log(p1.mostrar());
p2.moverX(1);
console.log(p1.mostrar());

//5)
//de Gian, pero pensado
function Punto(x, y){
	this.x = x;
	this.y = y;
}

Punto.prototype.mostrar = function(){
	return "Punto(" + this.x + "," + this.y + ")";
}

function PuntoColoreado(x,y, color) {
	this.x = x
	this.y = y
	this.color = color
}

PuntoColoreado.prototype.__proto__ = Punto.prototype

Punto.prototype.moverX = function(x){
	this.x += x
}

let p = new Punto(1 ,2) ;
console . log ( p . mostrar () ) ;