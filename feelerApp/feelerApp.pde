boolean debug = true;


import processing.net.*; 
import controlP5.*; 
import java.util.*; 
import java.awt.Robot; 
import java.awt.AWTException; 
import java.awt.Rectangle; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 






ControlP5 cp5;

JSONObject json;

String currentPage = "home";

float attentionAverage;
float relaxationAverage;

//User session stuff
String encodedAuth = "";
Client client;
String loginData;
String host;
int port;
String address;

boolean isLoggedIn = false;
boolean isWrongPassword = false;
String currentUser = "";
String currentPassword = "";
Textfield username;
Textfield password;

final static int TIMER = 100;
static boolean isEnabled = true;

//UI variables
int headerHeight = 100;
int padding = 5;
int userTabsX;
int buttonWidth = 70;
int buttonHeight = 20;
int visBarWidth = 300;
int visBarHeight = 120;

// files handling
String userDataFolder = "user-data";
String absolutePath;
FloatTable data;
String filenameString;
String[] fileArray;
File directory2;

float dataMin, dataMax;
int deltaMax, deltaMin, thetaMax, thetaMin, lowAlphaMax, lowAlphaMin, highAlphaMax, highAlphaMin, lowBetaMax, lowBetaMin, highBetaMax, highBetaMin, lowGammaMax, lowGammaMin, midGammaMax, midGammaMin, blinkStMax, blinkStMin, attentionMin, attentionMax, meditationMin, meditationMax; 
float plotX1, plotY1;
float plotX2, plotY2;
 
int rowCount, rowCount1, rowCount2,  rowCount3;
long state1start, state2start,state3start;
int columnCount;
int currentColumn = 0; 
char[] filenameCharArray = new char[20];
/////////////////////////

// screen capture
PImage screenshot;
/////////////////

/*
Communication stuff

setup: feelerS.play();

1. when pressing 'start'
  feelerS.setBoxState(100);
2. when pressing 'record' // "meditate"
  feelerS.setBoxState(200);
  start timer
  setBox2LedState(timer mapped to int(0\u201450) ); //loop
  when timer reaches target send feelerS.setBoxState(299);
3. when pressing 'record' // "study"
  feelerS.setBoxState(300);
  reset timer
  setBox2LedState(timer mapped to int(0\u201450) ); //loop
  when timer reaches target send feelerS.setBoxState(399);
  feelerS.getButton1();
4. // "assess"
  if(feelerS.getButton1()){
    //question 1
    feelerS.getButton2();
    feelerS.setBoxState(301);
  }
  
  if(feelerS.getButton2()){
    //question 2
    feelerS.getButton3();
    feelerS.setBoxState(302);
  }

  if(feelerS.getButton3()){
    //question 3
    feelerS.setBoxState(303);
    // submit answers
    feelerS.setBoxState(1000);
    //and success
  }
  
  ????????????????

*/


public void setup() {
  
  size(1200, 850);
  noStroke();
  textSize(12);
  
  userTabsX = width/2;
  
  json = loadJSONObject("config.json");
  host = json.getString("host");
  port = json.getInt("port");
  address = json.getString("address");
  
  cp5 = new ControlP5(this);
  
  PImage[] imgs = {loadImage("feeler-logo.png"),loadImage("feeler-logo.png"),loadImage("feeler-logo.png")};
  cp5.addButton("homeBt")
     .setBroadcast(false)
     .setPosition(20, 20)
     .setSize(241,63)
     .setLabel("Feeler")
     .setImages(imgs)
     .setValue(1)
     .setBroadcast(true)
     .getCaptionLabel().align(CENTER,CENTER)
     ;
  cp5.getController("homeBt").moveTo("global");
     
  cp5.getTab("default")
     .activateEvent(true)
     .setLabel("home")
     .setId(1)
     ;
  
  cp5.addTab("login");
  cp5.getTab("login")
     .activateEvent(true)
     .setId(2)
     ;

  
  username = cp5.addTextfield("username")
     .setPosition(width/2 - 100, height/2 - 40)
     .setSize(200, 20)
     .setLabel("username")
     .setFocus(true)
     ;
  username.setAutoClear(true);
  cp5.getController("username").moveTo("login");
  
  password = cp5.addTextfield("password")
     .setPosition(width/2 - 100, height/2)
     .setSize(200, 20)
     .setPasswordMode(true)
     .setLabel("password")
     ;
  password.setAutoClear(true);
  cp5.getController("password").moveTo("login");
  
  cp5.addButton("submit")
     .setBroadcast(false)
     .setLabel("login")
     .setPosition(width/2 - 100, height/2 + 40)
     .setSize(200,40)
     .setValue(1)
     .setBroadcast(true)
     .getCaptionLabel().align(CENTER,CENTER)
     ;
  cp5.getController("submit").moveTo("login");
  
  cp5.addButton("loginBt")
     .setBroadcast(false)
     .setLabel("login")
     .setPosition(width - 100, 20)
     .setSize(80,40)
     .setValue(1)
     .setBroadcast(true)
     .getCaptionLabel().align(CENTER,CENTER)
     ;
  cp5.getController("loginBt").moveTo("default");
  
  cp5.addButton("logoutBt")
     .setBroadcast(false)
     .setLabel("Logout")
     .setPosition(width - 80, 10)
     .setSize(70,20)
     .setValue(1)
     .setBroadcast(true)
     .getCaptionLabel().align(CENTER,CENTER)
     ;
  cp5.getController("logoutBt").moveTo("global");
  cp5.getController("logoutBt").hide();
  
  
  

}

public void draw() {
  background(255);
  fill(0);
  
  if(isLoggedIn){
    textAlign(RIGHT);
    text("Hello, " + currentUser, width - 10, 50);
  }
  
  if(isWrongPassword){
    textAlign(CENTER);
    text("Wrong username or password", width/2, height/2 - 60);
  }
  
  //Visualisation
  if(currentPage == "overall"){
    textAlign(CENTER, CENTER);
  
    int visX = width/2;
    fill(220);
    rect(visX, headerHeight + 50, visBarWidth, visBarHeight);
    fill(120);
    rect(visX, headerHeight + 50, map(attentionAverage, 0, 100, 0, visBarWidth), visBarHeight);
    fill(0);
    text("Attention " + str(attentionAverage),visX, headerHeight + 50, visBarWidth, visBarHeight);
  
    fill(220);
    rect(visX, headerHeight + 50 + visBarHeight, visBarWidth, visBarHeight);
    fill(120);
    rect(visX, headerHeight + 50 + visBarHeight, map(relaxationAverage, 0, 100, 0, visBarWidth), visBarHeight);
    fill(0);
    text("Relaxation " + str(relaxationAverage),visX, headerHeight + 50 + visBarHeight, visBarWidth, visBarHeight);
    
    text("Values based on your EEG data", visX, headerHeight + 50 + visBarHeight*2, visBarWidth, 30);
    // TODO: button to EEG overall 
  }
  
  
  if(debug){
    textAlign(LEFT);
    
    fill(210);
    rect(0, height-100, width, 100);
    
    String s = "Press 'l' to log in" +
               "\nPress 'c' after logging in to capture screen." +
               "\nCurrent user:" + currentUser +
               "\nIs logged in:" + isLoggedIn
            ;
    fill(50);
    text(s, 10, height-90, width-10, height-90);  // Text wraps within text box
  }
}

public void controlEvent(ControlEvent theControlEvent) {
  if (theControlEvent.isTab()) {
    println("got an event from tab : "+theControlEvent.getTab().getName()+" with id "+theControlEvent.getTab().getId());
  }
  
  switch(theControlEvent.getName()){
    case "overall":
      println("overall page");
      currentPage = "overall";
      break;
    case "newSession":
      println("newSession page");
      currentPage = "newSession";
      break;
    case "lastSession":
      println("lastSession page");
      currentPage = "lastSession";
      break;
  }
  
  //clean up interface
  if(theControlEvent.getLabel() == "Logout"){
    cp5.getController("logoutBt").hide();
    isLoggedIn = false;
    currentUser = "";
    cp5.getTab("default").bringToFront();
    cp5.getController("newSession").hide();
    cp5.getController("overall").hide();
    cp5.getController("lastSession").hide();
  }
  
  if (theControlEvent.isAssignableFrom(Textfield.class)) {
    Textfield t = (Textfield)theControlEvent.getController();
    
    if(t.getName() == "username"){
      currentUser = t.getStringValue();
    }
    if(t.getName() == "password"){
      currentPassword = t.getStringValue();
    }
    
    //https://forum.processing.org/two/discussion/10423/working-with-client-connection-to-api-with-authentication
    // post request
    client = new Client(this, host, port);
    client.write("POST "+address+" HTTP/1.0\r\n");
    client.write("Accept: application/xml\r\n");
    client.write("Accept-Charset: utf-8;q=0.7,*;q=0.7\r\n");
    client.write("Content-Type: application/x-www-form-urlencoded\r\n");
    String contentLength = nf(23+currentUser.length()+currentPassword.length()); 
    client.write("Content-Length: "+contentLength+"\r\n\r\n");
    
    client.write("username="+currentUser+"&password="+currentPassword+"&\r\n");
    client.write("\r\n");

    println("controlEvent: accessing a string from controller '"
      +t.getName()+"': "+t.getStringValue()
    );
    
    print("controlEvent: trying to setText, ");

    t.setText("controlEvent: changing text.");
    if (t.isAutoClear()==false) {
      println(" success!");
    } 
    else {
      println(" but Textfield.isAutoClear() is false, could not setText here.");
    }
    ///////////////////////////////////
  }
}

public void loginBt(int theValue) {
  cp5.getTab("login").bringToFront();
}

public void newSession(int theValue) {
  cp5.getTab("newSession").bringToFront();
  
  String lastLogin = String.valueOf(year()) + "-" + String.valueOf(month()) + "-" + String.valueOf(day()) + "-" + String.valueOf(hour()) + "-" + String.valueOf(minute()) + "-" + String.valueOf(second()) + ".txt";
  String[] userLoglist = split(lastLogin, ' ');
  saveStrings(userDataFolder + "/" +currentUser + "/last-login.txt", userLoglist);
}

public void overall(int theValue) {
  cp5.getTab("overall").bringToFront();
}

public void lastSession(int theValue) {
  cp5.getTab("lastSession").bringToFront();
}

public void submit(int theValue) {
  // use callback instead
  isEnabled = true;
  username.submit();
  password.submit();
  thread("timer"); // from forum.processing.org/two/discussion/110/trigger-an-event
}

public void loginCheck(){
  if(debug){
    println(currentUser);
    if(currentUser == ""){
      currentUser = "someuser";
    }
    
    cp5.getTab("overall").bringToFront();
    isLoggedIn = true;
  
    isWrongPassword = false;
    cp5.getController("logoutBt").show();
    
    addUserAreaControllers();
    
  } else {
    if (client.available() > 0) {
      loginData = client.readString();
      String[] m = match(loginData, "<logintest>(.*?)</logintest>");
      if(m[1].equals("success")){
        cp5.getTab("overall").bringToFront();
        isLoggedIn = true;
        isWrongPassword = false;
        cp5.getController("logoutBt").show();
        addUserAreaControllers();
      } else {
        println("wrong password");
        isLoggedIn = false;
        isWrongPassword = true;
      }
    }
  }
  
  // file handling
  File directory1 = new java.io.File(sketchPath(""));
  absolutePath = directory1.getAbsolutePath();
  String temp = absolutePath;
  //temp += "/log";
  temp += "/" + userDataFolder + "/" + currentUser;
  
  //create user folder
  File f1 = new File(dataPath(temp));
  f1.mkdir();
  
  temp += "/log";
  
  //create log folder
  File f2 = new File(dataPath(temp));
  f2.mkdir();
  
  directory2 = new File(temp);
  fileArray = directory2.list();
  
  cp5.addScrollableList("loadFiles")
     .setPosition(20, 120)
     .setLabel("Load session")
     .setSize(200, 100)
     .setBarHeight(20)
     .setItemHeight(20)
     .addItems(fileArray)
     ;
   cp5.getController("loadFiles").moveTo("overall");
  
  cp5.addButton("deleteFile")
     .setBroadcast(false)
     .setLabel("delete")
     .setPosition(230, 120)
     .setSize(70,20)
     .setValue(1)
     .setBroadcast(true)
     .getCaptionLabel().align(CENTER,CENTER)
     ;
  cp5.getController("deleteFile").moveTo("overall");
  /////////////////////////////
  
  currentPage = "overall";
}

public void addUserAreaControllers(){
  
  cp5.addTab("newSession");
  cp5.getTab("newSession")
     .activateEvent(true)
     .setId(3)
     ;
     
  cp5.addTab("overall");
  cp5.getTab("overall")
     .activateEvent(true)
     .setId(4)
     ;
     
  cp5.addTab("lastSession");
  cp5.getTab("lastSession")
     .activateEvent(true)
     .setId(5)
     ;
  
  //other controllers
  cp5.addButton("newSession")
     .setBroadcast(false)
     .setLabel("start a session")
     .setPosition(width - 160, 10)
     .setSize(buttonWidth, buttonHeight)
     .setValue(1)
     .setBroadcast(true)
     .getCaptionLabel().align(CENTER,CENTER)
     ;
  cp5.getController("newSession").moveTo("global");
  
  cp5.addButton("overall")
     .setBroadcast(false)
     .setLabel("overall")
     .setPosition(userTabsX, headerHeight + padding)
     .setSize(buttonWidth, buttonHeight)
     .setValue(1)
     .setBroadcast(true)
     .getCaptionLabel().align(CENTER,CENTER)
     ;
  cp5.getController("overall").moveTo("global");
  
  cp5.addButton("lastSession")
     .setBroadcast(false)
     .setLabel("last session")
     .setPosition(userTabsX + buttonWidth + padding, headerHeight + padding)
     .setSize(buttonWidth, buttonHeight)
     .setValue(1)
     .setBroadcast(true)
     .getCaptionLabel().align(CENTER,CENTER)
     ;
  cp5.getController("lastSession").moveTo("global");
  
}

public void timer() {
  while (isEnabled) {
    delay(TIMER);
    isEnabled = false;
    loginCheck();
  }
}


public void deleteFile(int theValue) {
  String fileName = dataPath("test.json");
  //File f = new File(fileName);
  File f = new File(directory2 + "/" + filenameString);
  println(fileName);
  println("data: " + directory2 + "/" + filenameString);
  
  if (f.exists()) {
    f.delete();
    println("deletou");
    loginCheck();
  } else {
    println("n\u00e3o existe");
  }
  
}

public void loadFiles(int n) {
  /* request the selected item based on index n */
  println(n, cp5.get(ScrollableList.class, "loadFiles").getItem(n));
  CColor c = new CColor();
  c.setBackground(color(0));
  cp5.get(ScrollableList.class, "loadFiles").getItem(n).put("color", c);

  filenameString = fileArray[n];
  // TODO: plot fileArray as graph
  
  data = new FloatTable(directory2 + "/" + filenameString);
  filenameCharArray = filenameString.toCharArray();

  rowCount = data.getRowCount(9);
  rowCount1 = data.getRowCount(1);
  rowCount2 = data.getRowCount(2);
  rowCount3 = data.getRowCount(3);
  columnCount = data.getColumnCount();
 
  state1start = data.getStateStart(1); // state1end = data.getStateEnd(1);
  state2start = data.getStateStart(2); // state2end = data.getStateEnd(2);
  state3start = data.getStateStart(3); // state3end = data.getStateEnd(3);
  
  println("attention" + data.getRowCount(10));
  println("relaxation" + data.getColumnMax(11));
  
  attentionAverage = 0;
  relaxationAverage = 0;
  for(int i = 0; i < data.data.length ; i++){
    if(data.data[i][11] == 1 || data.data[i][11] == 2){
      println("attention: " + data.data[i][9]);
      attentionAverage += data.data[i][9]/data.data.length;
      println("meditation: " + data.data[i][10]);
      relaxationAverage += data.data[i][10]/data.data.length;
    }
  }
  
  
  /*
  // what is relaxation and attention? average?

  attentionMax = (int)data.getColumnMax(9);  attentionMin = (int)data.getColumnMin(9);
  meditationMax = (int)data.getColumnMax(10);  meditationMin = (int)data.getColumnMin(10);
  */
}

public void keyPressed(){
  
  if(debug){
    switch(key){
      case 'c':
        screenshot();
        PImage newImage = createImage(100, 100, RGB);
        newImage = screenshot.get();
        newImage.save(
                        absolutePath + "/user-data/" + currentUser + "/" +
                        String.valueOf(year()) + "-" + String.valueOf(month()) + "-" + String.valueOf(day()) + "-" + String.valueOf(hour()) + "-" + String.valueOf(minute()) + "-" + String.valueOf(second()) +
                        "-screenshot.png"
                      );
        break;
      case 'l':
        loginCheck();
        break;
    }
    
  }
}

public void screenshot() {
  try{
    Robot robot_Screenshot = new Robot();
    screenshot = new PImage(robot_Screenshot.createScreenCapture
    (new Rectangle(0,0,displayWidth,displayHeight)));
  }
  catch (AWTException e){ }
  frame.setLocation(0, 0);
}