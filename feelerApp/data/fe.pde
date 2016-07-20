//include library
import feelerSerial.*;
import neurosky.*;
int resizeWithArrows = 0;

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
  feelerS.setSettings(10000, 2000, 3000); //remove this line to use default settings.
  
  //list serial connections
  feelerS.listSerial();
  
  //Initiate connection, bluetooth adress. Send/receive settings
  //feelerS.init("/dev/cu.usbmodem12341");
  feelerS.init("/dev/tty.Feeler-RNI-SPP");
  //feelerS.init("/dev/tty.usbserial-A702U4PD");
  //this is for the timer
  time = millis();
  feelerS.play();
}

void draw() {
  //Stop boxes
  //feelerS.stop();
  //Play boxes

  //set box 2 led state
  //feelerS.setBox2LedState(resizeWithArrows); 
  


  //set debug values, these are the values that are received from the arduino
  //this is run only when debug mode is activated
  //(boxesConnected, play(1)/stop(0), boxState,int box2buttonPress(1-3), box2Led(1-50))
  //feelerS.debugSet(1, resizeWithArrows, 1, 1, 1);

  //set the box state;
  feelerS.setBoxState(resizeWithArrows);
  feelerS.setBox3GameValue(100);
  if(resizeWithArrows >= 10 && resizeWithArrows < 61){
    feelerS.setBox2LedState(resizeWithArrows-10);
    feelerS.setBox2LedSpeed((resizeWithArrows-10)*100);
  }
  else if(resizeWithArrows >= 61 && resizeWithArrows < 100){
    feelerS.setBox3GameValue((resizeWithArrows-61));
  }
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
  

  //  print("boxState: ");
  //println(feelerS.boxState);
}

void keyPressed() {
  feelerS.sendValues();
  if (key == CODED) {
    if (keyCode == LEFT) {
      resizeWithArrows--;
      feelerS.sendValues();
      println(resizeWithArrows);

    } else if (keyCode == RIGHT) {
      resizeWithArrows++;
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
    print("Boxes connected: ");
    println(feelerS.getBoxesConnected()); 
    
    print("Boxes connected: ");
    println(feelerS.getBoxesConnected());
    
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
    
    //feelerS.getButton1();
    //if(feelerS.getButton1()){
      

  
    /*
    //button-presses as bools
    print("Button 1: ");
    println(feelerS.getButton1()); 
    print("Button 2: ");
    println(feelerS.getButton2()); 
    print("Button 3: ");
    println(feelerS.getButton3()); 
    */

    //How many boxes are connected?

    
    //Get box state
    // print("Box state: ");
    // println(feelerS.getBoxState());
  //  print("getPlayStopSync: ");
    //println(feelerS.getPlayStopSync());

  }//*/
}