/*	Serial message with 'b' is a value from arduino, B is a settingsvalue.
 *	To send settings 'S' is used, and to send data to arduino 's'. 'E' if message is received correctly.
 */

package feelerSerial;


import processing.core.*;
import processing.serial.*;
import java.util.Arrays;

public class feelerSerial {
	
	
	PApplet myParent;
	
	//	Stored message values to these
	public static char[] receivedSerial = new char[63];
	public static int[] intValues = new int[63]; 
	
	//	Message settings
	static char startMarker = '<';
	static char endMarker = '>';
	static char limitMarker = ',';
	static int maxLengthOfSerial = 63;
	
	// Serial settings
	static Serial mySerial;
	
	// Settings are written in seconds, if zero is sent, nothing is changed
	static boolean settingsBool = false;
	static int box1Speed = 0;
	static int box2Speed = 0;
	static int box3Speed = 0;
	
	// Input from arduino
	static int boxesConnected = 0;
	static int boxStateInput = 0;
	static int box2LedState = 0;
	
	// Output to arduino 
	static int boxState = 20;
	static int box3Button = 0;
	//static int boxNumber = 1;
	// This works like "last button press"
	static int box3ButtonTemp = 0;
	
	// Button bools to activate when button is pressed and deactivate when information is gotten
	static boolean box3Button1 = false;
	static boolean box3Button2 = false;
	static boolean box3Button3 = false;
	
	public static boolean debugMode = false; //SET TRUE FOR DEBUG
	

	/*-------------------------------------------------------------------------------------------------------------
	 * INITIATE
	 *------------------------------------------------------------------------------------------------------------*/
	
	// Applet
	public feelerSerial(PApplet theParent) {	
		myParent = theParent;
	}
	
	// Set settings that are sent to arduino. They are sent only if you set this. 
	public void setSettings(int speed1, int speed2, int speed3){
		box1Speed = speed1;
		box2Speed = speed2;
		box3Speed = speed3;
		settingsBool = true;
	}
	
	// INITIATE
	public void init(String adress){
	//Do this if not in debug mode
	if(!debugMode){
		//	Connect to arduino
		 int portBoolean = 0;
		 //Search for serial
		 System.out.print("Connecting");
		  while (portBoolean == 0) {
		    String[] temp = Serial.list();
		    for (int i = 0; i < temp.length; i++){
		      if (temp[i].equals(adress)) {
		        try { 
		        mySerial = new Serial(myParent, adress, 56700);	//connect to serial
		        portBoolean = 1;
		        break;
		      }
		      catch (Exception a){
		        mySerial = null;
		      }
		    }
		    }
		    try {						//sleep for 700 microseconds
	        	  Thread.sleep(700L);
	        	}
	        catch (Exception e) {}
		    System.out.print(".");
		    //Get the serial list again
		    temp = Serial.list();
		  }
		  //Set settings so it buffers until endMarker is found
		  mySerial.bufferUntil(endMarker); 
		  
		  System.out.println("");
		  System.out.println("Feeler found!");
		  
		  //Send settings if there are any set, receive "E" when ready
		  System.out.print("Sending settings");
		  boolean getSettingsB = false;
			  	while(true){ 
			  		mySerial.write(startMarker + "S" + limitMarker + Integer.toString(box1Speed) + limitMarker + Integer.toString(box2Speed) + limitMarker + Integer.toString(box3Speed) + endMarker);
					System.out.print(".");
					while(mySerial.available() > 0){
						char input = (char)mySerial.read();
						//Break when 'E' character is gotten back from the arduino
						if(input == 'E'){
							getSettingsB = true;
							System.out.println("");
							System.out.println("Settings sent successfully");
							break;
						} 
						//Break if sketch already running
						if(input == 'b'){
							getSettingsB = true;
							System.out.println("No settings sent, sketch already running.");
							break;
						}
					}
					//Break the while loop if something has happened
					if(getSettingsB == true) break;
					delay(50);
				}

		 //If no set settings, receive settings from arduino
		System.out.print("Receiving settings");
		while(true){
			if(getSettings() == true) {
					mySerial.write("E");
					//delay(2);
					//mySerial.write("E");
					break;
				}
			System.out.print(".");
			delay(100);
				 
			}		  
		 System.out.println("Feeler connected!");
		  
		}
		else System.out.println("Serial debug mode started");
	}
	

	
	/*-------------------------------------------------------------------------------------------------------------
	 * SERIAL INPUT
	 *------------------------------------------------------------------------------------------------------------*/
	
	// Get the serial information and return it if received successfully, else return NULL
	private static char[] getSerial(){
		if(!debugMode){
		//char[] receivedSerial = new char[maxLengthOfSerial];
		boolean receiving = false;
	    int index = 0;
	    while (mySerial.available() > 0) {
	        char input = (char)mySerial.read();
	        //System.out.print(input);
	        //Start receiving if startmarker is found, check else if
	        if (receiving == true) {
	        	receivedSerial[index] = input;
	            if (index > maxLengthOfSerial-1) return null;  //return if max length of serial is filled
	            if (input == endMarker) {
	                receivedSerial[index+1] = '\0';
	        		//System.out.println(receivedSerial);
	                while(mySerial.available() > 0) mySerial.read(); //clear rest
	                char[] arr2 = Arrays.copyOf(receivedSerial, index+2); //copy to new array, and make it the right length
	                return arr2; //return array
	            }
		        index++;
	        }
	        //Start receiving if startmarker
	        else if (input == startMarker) {
	        	receiving = true;
	            receivedSerial[index] = startMarker;
	            index++;
	        }
	    }
		} else {
			String temp = "<b,3,2,1>";
			receivedSerial = temp.toCharArray();
			return receivedSerial;
					
		}
		return null;
	}
	
	// Get the settings when sketch is started	
	private static boolean getSettings(){
		//Get the serial
		char[] serialSettings = getSerial();
		// Return false if no serial is received
		if (serialSettings == null) return false;
		//make a buffer for the int values
		int[] intSettings = new int[maxLengthOfSerial];
		
		int index = 0;
		boolean parsing = false;
		byte number = 0;
		while (index < maxLengthOfSerial) {
			// Start parsing if start marker is found, check else if
			if (parsing == true) {
				//Parse the numbers to the int array
				if (isNumber(serialSettings[index])) {
					intSettings[number] = (intSettings[number] * 10) + (serialSettings[index] - '0');
					if (intSettings[number] > 65535) return false; //return if int is bigger then an undefined int
				} else if (serialSettings[index] == limitMarker) {
					//jump over limitmarkers, ',' and start new number
					number++; 
					intSettings[number] = 0;
				} else if (serialSettings[index] == endMarker) {
					//store settings when endMarker is reached
					box1Speed = intSettings[0];
					box2Speed = intSettings[1];
					box3Speed = intSettings[2];
					
					System.out.print("Settings loaded");
					System.out.print("Box1 Speed: " + Integer.toString(box1Speed));
					System.out.print(" | Box2 Speed: " + Integer.toString(box2Speed));
					System.out.println(" | Box3 Speed: " + Integer.toString(box3Speed));
					return true;
				}
			} else if (serialSettings[index] == startMarker) {
				//Start new number when limitmarker is reached
				if(serialSettings[index+1] == 'B'){
				//Start parsing if message starts with 'B'
				index +=2;
				parsing = true;
				} else if(serialSettings[index+1] == 'b'){
					//break if sketch is already dunning
					System.out.println("Device already running, restart the device if you have changed the settings");
					return true;
				}
				else {
						while(mySerial.available() > 0) mySerial.read();
						break;
					}
			}
			//next character
			index++;
		}
		return false;
	}
	
	// Get message from arduino 
	public  boolean get(){
		// Get the serial and return if not received
		char[] serialSettings = getSerial();
		if (serialSettings == null) return false;
		//Int buffer
		int[] intSettings = new int[maxLengthOfSerial];
		int index = 0;
		boolean parsing = false;
		byte number = 0;
		while (index < maxLengthOfSerial) {
			//Start parsing if startcharacter is received, see else if
			if (parsing == true) {
				//Parse the numbers to the int array
				if (isNumber(serialSettings[index])) {
					intSettings[number] = (intSettings[number] * 10) + (serialSettings[index] - '0');
					if (intSettings[number] > 65535) return false; //return if number too large for unsigned int in arduino
				} else if (serialSettings[index] == limitMarker) { 
					//Start new number when limitmarker is reached
					number++;
					intSettings[number] = 0;
				} else if (serialSettings[index] == endMarker) {
					//Store settings when endmarker is reached
					boxesConnected = intSettings[0];
					//System.out.println("boxesConnected: " + Integer.toString(boxesConnected));	//debug
					boxStateInput = intSettings[1];
					//System.out.println("boxStateInput: " + Integer.toString(boxStateInput));		//debug
					box3Button = intSettings[2]; 
					//System.out.println("box3Button: " + Integer.toString(box3Button));			//debug
					//Put the boxbool on according to the information
        		    if(box3Button != box3ButtonTemp){
        		    	if(box3Button == 1) box3Button1 = true;
        		    	else if(box3Button == 2) box3Button2 = true;
        		    	else if(box3Button == 3) box3Button3 = true;
        		    }
					return true;
				}
			} else if (serialSettings[index] == startMarker ) {
				//Start receiving 
				if(serialSettings[index+1] == 'b'){
					index +=2;
					parsing = true;
				}
				else {
					while(mySerial.available() > 0) mySerial.read();
					break;
				}
			}
			index++;
		}
	return false;
	}
	
	/*-------------------------------------------------------------------------------------------------------------
	 * GET FUNCTIONS
	 *------------------------------------------------------------------------------------------------------------*/
	
	//Get button press
	public boolean getButton1(){
		if(box3Button1 == true){ 
			box3Button1 = false;
			return true;
		}
		return false;
	}
	
	public boolean getButton2(){
		if(box3Button2 == true){ 
			box3Button2 = false;
			return true;
		}
		return false;
	}
	
	public boolean getButton3(){
		if(box3Button3 == true){ 
			box3Button3 = false;
			return true;
		}
		return false;
	}

	//Get the value that shows how many boxes are connected
	public int getBoxesConnected(){
		return boxesConnected;
	}

	
	//Not used
	//A simple function to parse an int from an char array, return 0 if number is too big
	/*private static int parseInt(int index){
		int newNumber = 0;
		while (isNumber(receivedChars[index])){
			newNumber = (newNumber * 10) + (receivedChars[index] - '0'); 
	        if(newNumber > 65535) return 0; 
	        index++;
	    }
	    return newNumber;
	}
	*/
	

	/*-------------------------------------------------------------------------------------------------------------
	 * Output
	 *------------------------------------------------------------------------------------------------------------*/

	//Set playing on, sent to arduino
	public void play(){
		boxState = 1;
	}
	
	//Set playing off, sent to arduino
	public void stop(){
		boxState = 0;
	}
	
	//Set box2LedState, sent to arduino
	public void setBox2LedState(int ledState){
		box2LedState = ledState;
	}
	
	//Get the boxState, returns "stopped" or "playing". Or a longer string if program and device is not synced. 
	public String getBoxState(){
		if(boxStateInput == 0 && boxState == boxStateInput) return "stopped";
		else if(boxStateInput == 1 && boxState == boxStateInput) return "playing";
		
		return "program and device not synced";
	}
	
	//Send the set values to arduino
	public void sendValues(){
		String write1 = startMarker + "s" + limitMarker + Integer.toString(boxState) + limitMarker + Integer.toString(box2LedState) + endMarker;
		if(!debugMode){
			mySerial.write(write1);
		} else{
		System.out.print("Sent: ");
		System.out.println(write1);
		}
	}
	
	/*-------------------------------------------------------------------------------------------------------------
	 * Tools
	 *------------------------------------------------------------------------------------------------------------*/
	//Is the char an number
	private static boolean isNumber(char input){
		if(input >= '0' && input <= '9') return true;
		return false;
	}
	

	//a simpler way to sleep for int time
	private static void delay(int time){
		try {
		    Thread.sleep(time);
		} catch(InterruptedException ex) {
		    Thread.currentThread().interrupt();
		}
	}
	
	public void debug(){
		debugMode = true;
	}
	/*NOT USED*/
	/*
	//List values, maybe using this
	private void list(){
		System.out.println(boxState);
		System.out.println(box2LedState);
		System.out.println("");
	}
	 
	//Not used!
	//Print one string with start and end marker
	public void print(String print){
		mySerial.write(startMarker + print + endMarker);
	}
	
	//Not used!
	//Print one string with start and end marker
	public void write(String print){
		mySerial.write(startMarker + print + endMarker);
	}
	
	
	*/
	
	
	
	/*
	void serialEvent(Serial mySerial) {
		get();	
		sendValues();
		
	}	//*/
}
