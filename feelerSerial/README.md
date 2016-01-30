# feelerSerial

## Installation

- Copy folder feelerSerial to your processing libraries folder
- Check the processing example patch

##Usage

Include library

	include <feelerSerial.*>

Create an instance

	feelerSerial feelerS;

In setup create the connection, choose bluetooth address.

	feelerS = new feelerSerial(this);

	//This step is not necessary but you can set the settings. 
	//The settings are speeds(seconds) for the 3 different boxes.
	feelerS.setSettings(box1SpeedInt, box2SpeedInt, box3SpeedInt);

	//Then use init and choose bluetooth address
	feelerS.init(”/dev/cu.usbmodem12341”);




Input
	//The variables are not public if you prefer to use them instead. Otherwise use these commands so you don’t change the wrong values. 
	
	//To get the serial. Do this first.
	feelerS.get();
	//OR
	if(feelerS.get()){
	 //do something
	}

	//booleans, these are saved every time you use mySerial.get() so no need to do it again. 
	feelerS.getButton1();
	feelerS.getButton2();
	feelerS.getButton3();

	//Get the playStop, returns "stopped" or "playing". Or a longer string if program and device is not synced. 
	feelerS.getPlayStopSync();

	//check if the boxState is synced with the computer. Returns synced is synced. otherwise "not synced".
  	feelerS.getBoxStateSync();

	//To get the number of boxes connected 0-2
	feelerS.getBoxesConnected();


Output

	//The variables are not public if you prefer to use them instead. Otherwise use these commands so you don’t change the wrong values. 
	

	//To play
	feelerS.play();
	
	//To stop
	feelerS.stop();
	
	//To set box2ledState, defines how many led's are lit. 
	feelerS.setBox2LedState(ledStateInteger);
	
	//Set boxState, this specifies the run cue. 0 is start. 1000 = end.
  	feelerS.setBoxState(4);	

	//To send the values to the boxes. This needs to be done after everything.
	feelerS.sendValues();


Debug
	
	//debug mode activate, do this just after "feelerS = new feelerSerial(this);"
	feelerS.debug();
	//set debug values, these are the values that are received from the arduino, this is run only when debug mode is activated
	//(int boxesConnected, int play(1)/stop(0), int boxState,int int box2buttonPress(1-3), int box2Led(1-50))
	feelerS.debugSet(1, 2, 3, 4, 5);
	
	