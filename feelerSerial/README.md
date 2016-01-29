# feelerSerial

## Installation
<<<<<<< HEAD
=======

>>>>>>> origin/master
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




Input:
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
	
	//This returns a string  with ”playing”, ”stopped” or ”program and device not synced”
	//Can be used to test the state of the devides. 
	feelerS.getBoxState();

	//To get the number of boxes connected 0-2
	feelerS.getBoxesConnected();


Output:

	//To play
	feelerS.play();
	
	//To stop
	feelerS.stop();
	
	//To set box2ledState, defines how many leds are lit. 
	feelerS.setBox2LedState(ledStateInteger);

	//To send the values to the boxes. This needs to be done after everything.
	feelerS.sendValues();

	
