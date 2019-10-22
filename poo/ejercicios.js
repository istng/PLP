
//4)
//a)
var Punto = {}

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