# Arduino FeelerSerial

## Installation

- Copy folder feelerSerial to your arduino libraries folder
- Check the example patch

##Usage

Include library

	#include <ardFeelerSerial.h>

Create an instances

	//create a regular serial connection
	feelerSerial serialPort(maxPacketsize);

	//create a softwareSerial connection, feelerSerial serialBox1(maxPacketsize, rxPin, txPin);
	feelerSerial serialBox1(maxPacketsize, 2, 3);

In setup create the connection, choose bluetooth address.

	//Set the settings on arduino, no need to do this if you are using default settings or sending them from the computer
	serialPort.setSettings(speeds[0],speeds[1],speeds[2]); 
	
	// Start bluetooth serial at 9600               
  	serialPort.begin(57600);
  	
	//get settings from computer, send them back.
	serialPort.setup();


Input

	//get settings
	serialPort.getSpeed1();
	serialPort.getSpeed2();
	serialPort.getSpeed3();

	//’s’ is the computer
	serialBox2.get('s'); 

  	//getBoxState, int
 	serialPort.getBoxState();
	
	//get play state
	serialPort.getPlayStop();

 	//getBox2LedState, int
 	serialPort.getBox2LedState();

Output

	//send values, ’b’ is the computer. Send 5 int values.
	//only 3 first for the settings, leave rest 0
	serialBox1.send(’b’,boxesConnected, bluetooth.getPlayStop(), bluetooth.getBoxState(), box3Button, bluetooth.getBox2LedState());

	