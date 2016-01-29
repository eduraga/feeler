//include library
import feelerSerial.*;

int resizeWithArrows = 100;

//Create an instance
feelerSerial feelerS;

boolean bool = false;
double time; 
void setup() {
  bool = false;
  size(400,400);
  smooth();
  
  //Make a new feelerSerial
  feelerS = new feelerSerial(this); 
  
  //debug mode
  feelerS.debug();
  
  //set debug values, these are the values that are received from the arduino
  //this is run only when debug mode is activated
  feelerS.debugSet(1,200,300);
  
  //Set the settings you want to send.
  //The settings are speeds(seconds) for the 3 different boxes.
  feelerS.setSettings(20, 10, 50); //remove this line to use default settings.
  
  //Initiate connection, bluetooth adress. Send/receive settings
  feelerS.init("/dev/cu.usbmodem12341");
 
  //this is for the timer
  time = millis();
}


void draw(){
  //Stop boxes
  feelerS.stop();
  //Play boxes
  feelerS.play();
  //set box 2 led state
  feelerS.setBox2LedState(resizeWithArrows); 
  
  //Send serial
  feelerS.sendValues();
  
  //Get serial
  if(feelerS.get()){
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
    print("Box state: ");
    println(feelerS.getBoxState());
  }
  
  //a simple timer
  double time2 = millis();
  if(time2 - time > 100){
      time = millis() + (time2-time - 100);
      //timer
      //do something
  }
}
  
void keyPressed() {
  if (key == LEFT) {
    resizeWithArrows--;
  }
  else if (key == RIGHT) {
    resizeWithArrows++;
  }
  else if (key == UP) {
    resizeWithArrows++;
  }
  else if (key == DOWN) {
    resizeWithArrows--;
  }
}