//include library
import feelerSerial.*;

int resizeWithArrows = 10;

//Create an instance
feelerSerial feelerS;

boolean bool = false;
double time; 
void setup() {
  bool = false;
  size(400, 400);
  smooth();

  //Make a new feelerSerial
  feelerS = new feelerSerial(this); 

  //debug mode
  //feelerS.debug();


  //Set the settings you want to send.
  //The settings are speeds(seconds) for the 3 different boxes.
  feelerS.setSettings(20, 10, 50); //remove this line to use default settings.

  //Initiate connection, bluetooth adress. Send/receive settings
  feelerS.init("/dev/cu.usbmodem12341");

  //this is for the timer
  time = millis();
}


void draw() {
  //Stop boxes
  feelerS.stop();
  //Play boxes
  feelerS.play();
  //set box 2 led state
  feelerS.setBox2LedState(resizeWithArrows); 

  //set debug values, these are the values that are received from the arduino
  //this is run only when debug mode is activated
  //(boxesConnected, play(1)/stop(0), boxState,int box2buttonPress(1-3), box2Led(1-50))
  feelerS.debugSet(122, 22, 30, 2, 12);
  
  //set the box state;
  feelerS.setBoxState(4);
  //Send serial
  feelerS.sendValues();

  //Get serial
  if (feelerS.get()) {
    println(" ");
    //button-presses as bools
    print("Button 1: ");
    println(feelerS.getButton1()); 
    print("Button 2: ");
    println(feelerS.getButton2()); 
    print("Button 3: ");
    println(feelerS.getButton3()); 

    //How many boxes are connected?
    print("Boxes connected: ");
    println(feelerS.getBoxesConnected()); 

    //Get box state
    // print("Box state: ");
    // println(feelerS.getBoxState());
    print("getPlayStopSync: ");
    println(feelerS.getPlayStopSync());
    println(feelerS.playStop);

    print("boxState: ");
    println(feelerS.getBoxStateSync());
    println(feelerS.boxStateInput);

    print("box2LedState: ");
    println(feelerS.getBox2LedState());
    println(feelerS.box2LedState);
    println(resizeWithArrows);
   
  }//*/

  //a simple timer
  double time2 = millis();
  if (time2 - time > 100) {
    time = millis() + (time2-time - 100);
    //timer
    //do something
  }
  

  //  print("boxState: ");
  //println(feelerS.boxState);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      resizeWithArrows--;
    } else if (keyCode == RIGHT) {
      resizeWithArrows++;
    } else if (keyCode == UP) {
      resizeWithArrows++;
    } else if (keyCode == DOWN) {
      resizeWithArrows--;
    }
  }
}