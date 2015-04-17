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

