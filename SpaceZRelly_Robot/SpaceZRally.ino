#include <Bridge.h>
#include <SpacebrewYun.h>
#include <SoftwareSerial.h>

SpacebrewYun SpaceZero = SpacebrewYun("Space_Robot_Red", "Este es el robot del equipo rojo, echo por alsw.net");
//Esta variable para comunicar con spacebrew

SoftwareSerial SerialRedBot(2, 3); // RX, TX

int X = 0;
int Y = 0;
//Valores de envio del puerto serial;

void setup() {

  Serial.begin(9600);
  //Iniciando la del puerto serial

  SerialRedBot.begin(9600);

  Bridge.begin();
  //Iniciando la libreria de puente entre arduino y liliro

  SpaceZero.verbose(true);
  //Muestras las configuraciones de spacebrew

  SpaceZero.addSubscribe("CI", "range");
  SpaceZero.addSubscribe("CII", "range");
  SpaceZero.addSubscribe("CIII", "range");
  SpaceZero.addSubscribe("CIV", "range");
  //Se dibije el contron por cuadrantes como el plano carteciano
  //Recibe si fue precionado los botones de los cuadrantes
  //0 - No precionado
  //1 - Precionado

  SpaceZero.addSubscribe("Player", "range");
  //Recibe que jugador se añade al juego


  SpaceZero.addPublish("Player", "range");
  //Envia a todos los jugadores que jugador fue seleccionado

  SpaceZero.onRangeMessage(ReadRange);
  //Crea la funcion que procesara los datos de rango que venga de spacebrew

  SpaceZero.connect("sandbox.spacebrew.cc");
  //Conectarme a la nube de spacebrew
}

void loop() {
  SpaceZero.monitor();

  SerialRedBot.print("X");
  SerialRedBot.println(X);
  delay(50);
  SerialRedBot.print("Y");
  SerialRedBot.println(Y);
  delay(50);

}

void ReadRange(String route, int value) {

  Serial.print("Valor de ");
  Serial.print(route);
  Serial.print(", valor recibido: ");
  Serial.println(value);
  if (route == "CI") {
    if (value > 0) {
      X += 50;
      Y += 50;
    }
    else {
      X -= 50;
      Y -= 50;
    }
  }
  if (route == "CII") {
    if (value > 0) {
      X -= 50;
      Y += 50;
    }
    else {
      X += 50;
      Y -= 50;
    }
  }
  if (route == "CIII") {
    if (value > 0) {
      X -= 50;
      Y -= 50;
    }
    else {
      X += 50;
      Y += 50;
    }
  }
  if (route == "CIV") {
    if (value > 0) {
      X += 50;
      Y -= 50;
    }
    else {
      X -= 50;
      Y += 50;
    }
  }
  
  if (route == "Player")
    SpaceZero.send("Player", value);

}
