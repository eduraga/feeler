#define PACKETSIZE 63
#include <ardFeelerSerial.h>
#include <serialParseUInt.h>

int box3Button = 2;
//create a regular serial connection
feelerSerial bluetooth(PACKETSIZE);

//create a softwareSerial connection
feelerSerial serialBox1(PACKETSIZE, 2, 3);

feelerSerial serialBox2(PACKETSIZE, 4, 5);

char array2[PACKETSIZE];
unsigned int speeds[3] = {60, 70, 80};
  
void setup() {
  bluetooth.setSettings(speeds[0],speeds[1],speeds[2]);                
  bluetooth.begin(57600);  // Start bluetooth serial at 9600
  //gets info from computer
  bluetooth.setup();
  
  serialBox2.begin(9600);
}

void loop() {
   bluetooth.getSpeed1();
   
  serialBox1.send('l', (int)bluetooth.getPlayStop(), bluetooth.getBox2LedState(), 56, 0, 0);
  serialBox2.send('r', (int)bluetooth.getPlayStop(), 99, 88, 0,0);
  serialBox2.get('L');
  serialBox2.get('R');

 

  
  //from computer 's'
  boolean test = bluetooth.get('s');
  if(test){
     //getBoxState, int
    Serial.print("playStop: ");
    Serial.println(bluetooth.getPlayStop());
    Serial.print("boxState: ");
    Serial.println(bluetooth.getBoxState());
    //getBox2LedState, int    
    Serial.print("getBox2LedState: ");
    Serial.println(bluetooth.getBox2LedState());
    //Do somethings
 }
 delay(100);
 //to computer 'b'
 bluetooth.send('b', bluetooth.getSpeed1(), bluetooth.getPlayStop(), bluetooth.getBoxState(), box3Button, bluetooth.getBox2LedState());
}

