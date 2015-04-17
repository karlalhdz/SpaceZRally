import spacebrew.*;

String server="sandbox.spacebrew.cc";
String name="Space_Blue_Control_2";
String description ="Control de robot del equipo azul";
//Datos del del servidor spacebrew

char UltimoC;
//Ultimo cuadrante selecionado

Spacebrew SpaceZero;
//Crea el objeto de spacebrew

Boton BCI;
Boton BCII;
Boton BCIII;
Boton BCIV;
//Botones de los diferentes cuadrantes diagonales


Boton P1;
Boton P2;
Boton P3;
Boton P4;
//Botones para escojer que jugador
// 1 y 2 con azues
// 2 y 4 son rojos

int P = 1;
//jugador del juego
//1 Jugador azul 1
//2 Jugador azul 2
//3 Jugador Rojo 3
//4 Jugador Rojo 4

void setup() {
  size(800, 400);

  noStroke();
  textSize(height*0.05);
  textAlign(CENTER, CENTER);
  //Predispone la altura del texto dentro de los botones
  //asi como su alineacion

  BCI = new Boton("Derecha Adelante", 
  int(width*0.6), int(height*0.1), 
  int(width*0.3), int(height*0.25));

  BCII = new Boton("Izquierda Adelante", 
  int(width*0.1), int(height*0.1), 
  int(width*0.3), int(height*0.25));

  BCIII = new Boton("Izquierda Atras", 
  int(width*0.1), int(height*0.55), 
  int(width*0.3), int(height*0.25));

  BCIV = new Boton("Derecha Atras", 
  int(width*0.6), int(height*0.55), 
  int(width*0.3), int(height*0.25));
  //Iniciando las posiciones de los botones


  P1 = new Boton("Jugador 1", 
  0, 0, 
  int(width/2), int(height/2));
  P1.setiarColor( color(100, 100, 255), color(0, 0, 255));

  P2 = new Boton("Jugador 2", 
  int(width/2), 0, 
  int(width/2), int(height/2));
  P2.setiarColor( color(100, 100, 255), color(0, 0, 255));

  P3 = new Boton("Jugador 3", 
  0, int(height/2), 
  int(width/2), int(height/2));
  P3.setiarColor( color(255, 100, 100), color(255, 0, 0));

  P4 = new Boton("Jugador 4", 
  int(width/2), int(height/2), 
  int(width/2), int(height/2));
  P4.setiarColor( color(255, 100, 100), color(255, 0, 0));

  SpaceZero = new Spacebrew( this );
  //Creado el objeto de spacebrew

  SpaceZero.addPublish("CI", "range", 0 );
  SpaceZero.addPublish("CII", "range", 0 );
  SpaceZero.addPublish("CIII", "range", 0  );
  SpaceZero.addPublish("CIV", "range", 0 );
  //Creado lo que publican datos al arduino

  SpaceZero.addPublish("Player", "range", 0);
  SpaceZero.addSubscribe("Player", "range");
  SpaceZero.connect(server, name, description);
  //Conectando con el servidor

}

void draw() {
  background( 0 );
  //Pone el fondo en negro

  if (P == 0) {
    background(100, 100, 255 );
    fill(255, 100, 100);
    rect(0, height/2, width, height/2);
    P1.dibujar();
    P2.dibujar();
    P3.dibujar();
    P4.dibujar();
  } else {
    BCI.dibujar(); 
    BCII.dibujar();
    BCIII.dibujar();
    BCIV.dibujar();
    //Dibuja los botones
  }
}

void mousePressed() {
  if (P == 0) {
    if (P1.mouseDentro() && P1.visible) {
      SpaceZero.send("P", 1);
    }
    if (P2.mouseDentro() && P2.visible) {
      SpaceZero.send("P", 2);
    }
    if (P3.mouseDentro() && P3.visible) {
      SpaceZero.send("P", 3);
    }
    if (P4.mouseDentro() && P4.visible) {
      SpaceZero.send("P", 4);
    }
  } else {
    if (BCI.mouseDentro()) {
      SpaceZero.send("CI", 1); 
      UltimoC = '1';
    }
    if (BCII.mouseDentro()) {
      SpaceZero.send("CII", 1); 
      UltimoC = '2';
    }
    if (BCIII.mouseDentro()) {
      SpaceZero.send("CIII", 1); 
      UltimoC = '3';
    }
    if (BCIV.mouseDentro()) {
      SpaceZero.send("CIV", 1); 
      UltimoC = '4';
    }
  }
}

void mouseReleased() {
  if (P != 0) {
    switch(UltimoC) {
    case '1': 
      SpaceZero.send("CI", 0); 
      break;
    case '2': 
      SpaceZero.send("CII", 0); 
      break;
    case '3': 
      SpaceZero.send("CIII", 0); 
      break;
    case '4': 
      SpaceZero.send("CIV", 0); 
      break;
    }
  }
}

void onRangeMessage( String name, int value) {
  if (P == 0) {
    //Si se encuentra selecionando jugador
    //Quita los que otros jugadores allas escojido
    println(name +" " + value);
    if (name == "P") {
      if (value == 1)
        P1.visible = false;
      if (value == 2)
        P2.visible = false;
      if (value == 3)
        P3.visible = false;
      if (value == 4)
        P4.visible = false;
    }
  }
}

class Boton {
  String etiqueta;
  int x, y, w, h;

  boolean visible = true;
  color c_inactivo = color(192);
  color c_activo = color(255);
  Boton(String n_etiqueta, int n_x, int n_y, int n_ancho, int n_alto) {
    //Copia los datos del constructor a la clase
    etiqueta = n_etiqueta;
    x = n_x;
    y = n_y;
    w = n_ancho;
    h = n_alto;
  }

  void dibujar() {
    if (visible) {
      //Dibuja el rectangulo que representa el boton
      stroke(128);
      //Cambia el color de relleno en caso que se presione el boton
      if (presionado()) fill(c_activo);
      else fill(c_inactivo);
      //Dibuja el rectangulo
      rect(x, y, w, h);

      //Dibuja la etiqueta del boton en color negro
      fill(0);
      text(etiqueta, x, y, w, h);
    }
  }

  void setiarColor(color c1, color c2) {
    c_inactivo = c1;
    c_activo = c2;
  }

  boolean presionado() {
    //Devuelve verdadero en caso que se haga un click dentro del
    //area del boton
    return mousePressed && mouseX >= x && mouseX < x+w
      && mouseY >= y && mouseY < y+h;
  }

  boolean mouseDentro() {
    //Devuelve verdadero en caso que el cursor del mouse este
    //dentro del area del boton
    return mouseX >= x && mouseX < x+w &&
      mouseY >= y && mouseY < y+h;
  }
};


