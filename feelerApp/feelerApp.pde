boolean debug = true;

import processing.net.*;
import controlP5.*;
import java.util.*;
import java.awt.Robot;
import java.awt.AWTException;
import java.awt.Rectangle;

ControlP5 cp5;

JSONObject json;

String encodedAuth = "";
Client client;
String loginData;

boolean isLoggedIn = false;
boolean isWrongPassword = false;
String currentUser = "";
String currentPassword = "";
Textfield username;
Textfield password;

final static int TIMER = 100;
static boolean isEnabled = true;

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

String host;
int port;
String address;

void setup() {
  size(1200,600);
  //size(1200, 850);
  noStroke();
  textSize(12);
  
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

  cp5.addTab("userHome");
  cp5.getTab("userHome")
     .activateEvent(true)
     .setId(3)
     ;

  cp5.addTab("newSession");
  cp5.getTab("newSession")
     .activateEvent(true)
     .setId(4)
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
  
  
  cp5.addButton("newSession")
     .setBroadcast(false)
     .setLabel("start a session")
     .setPosition(width - 160, 10)
     .setSize(70,20)
     .setValue(1)
     .setBroadcast(true)
     .getCaptionLabel().align(CENTER,CENTER)
     ;
  cp5.getController("newSession").moveTo("userHome");
  

}

void draw() {
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

void controlEvent(ControlEvent theControlEvent) {
  if (theControlEvent.isTab()) {
    println("got an event from tab : "+theControlEvent.getTab().getName()+" with id "+theControlEvent.getTab().getId());
  }
  
  if(theControlEvent.getLabel() == "Logout"){
    cp5.getController("logoutBt").hide();
    isLoggedIn = false;
    currentUser = "";
    cp5.getTab("default").bringToFront();
  }
  
  if (theControlEvent.isAssignableFrom(Textfield.class)) {
    Textfield t = (Textfield)theControlEvent.getController();
    
    if(t.getName() == "username"){
      currentUser = t.getStringValue();
    }
    if(t.getName() == "password"){
      currentPassword = t.getStringValue();
    }
    
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


void submit(int theValue) {
  // use callback instead
  isEnabled = true;
  username.submit();
  password.submit();
  thread("timer"); // from forum.processing.org/two/discussion/110/trigger-an-event
}

void loginCheck(){
  if(debug){
    println(currentUser);
    if(currentUser == ""){
      currentUser = "someuser";
    }
    
    println("success");
    cp5.getTab("userHome").bringToFront();
    isLoggedIn = true;
    isWrongPassword = false;
    cp5.getController("logoutBt").show();
    
  } else {
    if (client.available() > 0) {
      loginData = client.readString();
      String[] m = match(loginData, "<logintest>(.*?)</logintest>");
      if(m[1].equals("success")){
        println("success");
        cp5.getTab("userHome").bringToFront();
        isLoggedIn = true;
        isWrongPassword = false;
        cp5.getController("logoutBt").show();
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
  cp5.getController("loadFiles").moveTo("userHome");
  
  cp5.addButton("deleteFile")
     .setBroadcast(false)
     .setLabel("delete")
     .setPosition(230, 120)
     .setSize(70,20)
     .setValue(1)
     .setBroadcast(true)
     .getCaptionLabel().align(CENTER,CENTER)
     ;
  cp5.getController("deleteFile").moveTo("userHome");
  /////////////////////////////
  
  

}

void timer() {
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
    println("não existe");
  }
  
}

void loadFiles(int n) {
  /* request the selected item based on index n */
  println(n, cp5.get(ScrollableList.class, "loadFiles").getItem(n));
  CColor c = new CColor();
  c.setBackground(color(0));
  cp5.get(ScrollableList.class, "loadFiles").getItem(n).put("color", c);

  filenameString = fileArray[n];
  
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
  
  println(data.getColumnMax(0));

  deltaMax = (int)data.getColumnMax(0);      deltaMin = (int)data.getColumnMin(0); 
  thetaMax = (int)data.getColumnMax(1);      thetaMin = (int)data.getColumnMin(1);
  lowAlphaMax = (int)data.getColumnMax(2);   lowAlphaMin = (int)data.getColumnMin(2); 
  highAlphaMax = (int)data.getColumnMax(3);  highAlphaMin = (int)data.getColumnMin(3);
  lowBetaMax = (int)data.getColumnMax(4);    lowBetaMin = (int)data.getColumnMin(4); 
  highBetaMax = (int)data.getColumnMax(5);   highBetaMin = (int)data.getColumnMin(5);
  lowGammaMax = (int)data.getColumnMax(6);   lowGammaMin = (int)data.getColumnMin(6); 
  midGammaMax = (int)data.getColumnMax(7);   midGammaMin = (int)data.getColumnMin(7);
  blinkStMax = (int)data.getColumnMax(8);    blinkStMin = (int)data.getColumnMin(8);
  attentionMax = (int)data.getColumnMax(9);  attentionMin = (int)data.getColumnMin(9);
  meditationMax = (int)data.getColumnMax(10);  meditationMin = (int)data.getColumnMin(10);
}

void keyPressed(){
  
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

void screenshot() {
  try{
    Robot robot_Screenshot = new Robot();
    screenshot = new PImage(robot_Screenshot.createScreenCapture
    (new Rectangle(0,0,displayWidth,displayHeight)));
  }
  catch (AWTException e){ }
  frame.setLocation(0, 0);
}