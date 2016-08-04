/*
feelerS.setSettings(10000, 2000, 3000); //remove this line to use default settings.
first value sets the ledfade time in box 1

0 : is start
1 :   ledfade box 1
2 :   ledfade ready
3 :   ledgrid, give number of leds with feelerS.setBox2LedState(value); 21 or 0 is turn off leds
      to set speed use feelerS.setBox2LedSpeed(value);
      
4 :   led fade ready, connect box 2

*/
//include library
import feelerSerial.*;
import neurosky.*;
int resizeWithArrows = 0;
int resizeWithArrowsLights = 0;

//Create an   instance
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
  //first number speed for ledfade in box 1
  feelerS.setSettings(10000, 2000, 3000); //remove this line to use default settings.
  
  //list serial connections
  feelerS.listSerial();
  
  //Initiate connection, bluetooth adress. Send/receive settings
  feelerS.init("/dev/tty.Feeler-RNI-SPP");
  //this is for the timer
  time = millis();
  
  feelerS.play();
  
  feelerS.setBox3GameValue(100);
  feelerS.setBox2LedSpeed(1000);
}

void draw() {
  //set debug values, these are the values that are received from the arduino
  //this is run only when debug mode is activated
  //(boxesConnected, play(1)/stop(0), boxState,int box2buttonPress(1-3), box2Led(1-50))
  //feelerS.debugSet(1, resizeWithArrows, 1, 1, 1);

  feelerS.setBoxState(resizeWithArrows);
  feelerS.setBox2LedState(resizeWithArrowsLights);
  //Send serial
  //feelerS.sendValues();

  
  //a simple timer
  double time2 = millis();
  if (time2 - time > 100) {
    time = millis() + (time2-time - 100);
    feelerS.sendValues();
    getSerialData();
    //timer
    //do something
  }
}

void keyPressed() {
  feelerS.sendValues();
  if (key == CODED) {
    if (keyCode == LEFT) {
      resizeWithArrowsLights--;
      feelerS.sendValues();
      println(resizeWithArrows);

    } else if (keyCode == RIGHT) {
      resizeWithArrowsLights++;
      println(resizeWithArrows);
      feelerS.sendValues();
      getSerialData();

    } else if (keyCode == UP) {
      resizeWithArrows++;
      println(resizeWithArrows);
      feelerS.sendValues();
      getSerialData();

    } else if (keyCode == DOWN) {
       resizeWithArrows--;
      println(resizeWithArrows);
      feelerS.sendValues();
      getSerialData();
    }
  }
}

void getSerialData(){
  //Get serial
  if (feelerS.get()){
    println(" ");
    //1 when the first box is connected and state is 3
    print("Boxes connected: ");
    println(feelerS.getBoxesConnected());
    print("connection: ");
    println(feelerS.checkConnection());
    print("Playing or stopped(0 when stopped): ");
    println(feelerS.getPlayStop());
    
        
    print("boxState: --- output:  ");
    print(feelerS.boxState);
    print(" input: ");
    println(feelerS.getBoxStateInput());

    print("box2LedState --- output: ");
    print(feelerS.box2LedState);
    print(" input: ");
    println(feelerS.getBox2LedState());
    
    print("box2LedSpeed --- output: ");
    print(feelerS.box2LedSpeed);
    print(" input: ");
    println(feelerS.getBox2LedSpeed());
    
    print("box3GameValue --- output: ");
    print(feelerS.box3GameValue);
    print(" input: ");
    println(feelerS.getBox3GameValue());
    println(resizeWithArrowsLights);
    
  }
}