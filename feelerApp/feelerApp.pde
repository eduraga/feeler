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

//User session stuff
String encodedAuth = "";
Client client;
String loginData;
String host;
int port;
String loginAddress;
String newUserAddress;

boolean isLoggedIn = false;
boolean isWrongPassword = false;
String currentUser = "";
String currentSession = "";
int currentItem;
String currentPassword = "";
Textfield username;
Textfield password;

boolean isNewUser = false;

final static int TIMER = 100;
static boolean isEnabled = true;

//UI variables
OverallAvgs eegAvg, personalAvg;
LineChart trends, eegAct;
int headerHeight = 100;
int padding = 20;
int userTabsX;
int buttonWidth = 70;
int buttonHeight = 20;
int visBarWidth = 300;
int visBarHeight = 120;
int visX;
int visY;
int visWidth;
int visHeight;
int dotSize = 20;
float e = 1;
float containerPosX;
float containerPosY;
int videoWidth = 640;
int videoHeight = 480;

//Color
color graphBgColor = color(240);
color textDarkColor = color(100);
color attentionColor = color(150);
color relaxationColor = color(70);

// files handling
int listSize = 20;
boolean loading = false;
String[] fileNames;
float attentionAverage = 0;
float relaxationAverage = 0;
float[] attentionAverageList = new float[listSize];
float[] relaxationAverageList = new float[listSize];

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

int rowCount, rowCount1, rowCount2, rowCount3;
long state1start, state2start, state3start;
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
  smooth();

  //size(1200, 850);
  size(1200, 700);
  noStroke();
  textSize(12);

  userTabsX = width/2;
  
  visX = width/4;
  visY = headerHeight + padding + 60;
  visWidth = width - width/3;
  visHeight = 300;

  json = loadJSONObject("config.json");
  host = json.getString("host");
  port = json.getInt("port");
  loginAddress = json.getString("login-address");
  newUserAddress = json.getString("new-user-address");

  cp5 = new ControlP5(this);
  
  eegAvg = new OverallAvgs("eeg", "Values based on your EEG data");
  personalAvg = new OverallAvgs("assessment", "Values based on your personal experience");
  trends = new LineChart("averages");
  eegAct = new LineChart("values");
  

  //Create UI elements
  containerPosX = width/2 - videoWidth/2;
  containerPosY = height/2 - videoHeight/2;

  PImage[] imgs = {loadImage("feeler-logo.png"), loadImage("feeler-logo.png"), loadImage("feeler-logo.png")};
  cp5.addButton("homeBt")
    .setBroadcast(false)
    .setPosition(20, 20)
    .setSize(241, 63)
    .setLabel("Feeler")
    .setImages(imgs)
    .setValue(1)
    .setBroadcast(true)
    .getCaptionLabel().align(CENTER, CENTER)
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
    .setSize(200, 40)
    .setValue(1)
    .setBroadcast(true)
    .getCaptionLabel().align(CENTER, CENTER)
    ;
  cp5.getController("submit").moveTo("login");

  cp5.addButton("signup")
    .setBroadcast(false)
    .setLabel("signup")
    .setPosition(width/2 - 100, height/2 + 90)
    .setSize(200, 40)
    .setValue(1)
    .setBroadcast(true)
    .getCaptionLabel().align(CENTER, CENTER)
    ;
  cp5.getController("signup").moveTo("login");

  cp5.addButton("loginBt")
    .setBroadcast(false)
    .setLabel("login")
    .setPosition(width - 100, 20)
    .setSize(80, 40)
    .setValue(1)
    .setBroadcast(true)
    .getCaptionLabel().align(CENTER, CENTER)
    ;
  cp5.getController("loginBt").moveTo("default");

  cp5.addButton("logoutBt")
    .setBroadcast(false)
    .setLabel("Logout")
    .setPosition(width - 80, 10)
    .setSize(70, 20)
    .setValue(1)
    .setBroadcast(true)
    .getCaptionLabel().align(CENTER, CENTER)
    ;
  cp5.getController("logoutBt").moveTo("global");
  cp5.getController("logoutBt").hide();

}

public void draw() {
  background(255);
  
  fill(0);

  if (isLoggedIn) {
    textAlign(RIGHT);
    text("Hello, " + currentUser, width - 10, 50);
  }

  if (isWrongPassword) {
    textAlign(CENTER);
    text("Wrong username or password", width/2, height/2 - 60);
  }
  
  
  //Visualisation
  switch(currentPage){
    case "home":
      if(!loading){
        home();
      }
      break;
    case "overall":
      // TODO: button to EEG overall
      trends.display();
      break;
    case "singleSession":
      singleVisPage();
      break;
    case "eegActivity":
      eegActivity();
      break;
  }
  
  if (debug) {
    textAlign(LEFT);

    fill(0, 20);
    rect(0, height-100, width, 100);

    String s = "Press 'l' to log in" +
      "\nPress 'c' after logging in to capture screen." +
      "\nCurrent user:" + currentUser +
      "\nIs logged in:" + isLoggedIn
      ;

    fill(50);
    text(s, 10, height-90, width-10, height-90);  // Text wraps within text box
  }
  
  textAlign(CENTER);
  if(loading){
    text("Loading...", width/2, height/2);
  }
  
}

public void controlEvent(ControlEvent theControlEvent) {
  if (theControlEvent.isTab()) {
    println("got an event from tab : "+theControlEvent.getTab().getName()+" with id "+theControlEvent.getTab().getId());
  }

  switch(theControlEvent.getName()) {
  case "overall":
    println("overall page");
    currentPage = "overall";
    break;
  case "newSession":
    println("newSession page");
    currentPage = "newSession";
    break;
  case "singleSession":
    println("singleSession page");
    currentPage = "singleSession";
    break;
  case "eegActivity":
    println("eegActivity page");
    currentPage = "eegActivity";
    break;
  }

  //clean up interface on logout
  if (theControlEvent.getLabel() == "Logout") {
    cp5.getController("logoutBt").hide();
    isLoggedIn = false;
    currentUser = "";
    cp5.getTab("default").bringToFront();
    currentPage = "home";
    cp5.getController("newSession").hide();
    cp5.getController("overall").hide();
  }

  if (theControlEvent.isAssignableFrom(Textfield.class)) {
    Textfield t = (Textfield)theControlEvent.getController();

    if (t.getName() == "username") {
      currentUser = t.getStringValue();
    }
    if (t.getName() == "password") {
      currentPassword = t.getStringValue();
    }

    //https://forum.processing.org/two/discussion/10423/working-with-client-connection-to-api-with-authentication
    // post request
    client = new Client(this, host, port);


    if (isNewUser) {
      client.write("POST "+newUserAddress+" HTTP/1.0\r\n");
    } else {
      client.write("POST "+loginAddress+" HTTP/1.0\r\n");
    }


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
    } else {
      println(" but Textfield.isAutoClear() is false, could not setText here.");
    }
    ///////////////////////////////////
  }
}

public void homeBt(int theValue) {
  cp5.getTab("default").bringToFront();
  currentPage = "home";
}

public void loginBt(int theValue) {
  cp5.getTab("login").bringToFront();
  currentPage = "login";
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

public void submit(int theValue) {
  // use callback instead
  isEnabled = true;
  isNewUser = false;
  username.submit();
  password.submit();
  thread("timer"); // from forum.processing.org/two/discussion/110/trigger-an-event
}

public void signup(int theValue) {
  // use callback instead
  isEnabled = true;
  isNewUser = true;
  username.submit();
  password.submit();
  thread("timer"); // from forum.processing.org/two/discussion/110/trigger-an-event
}

public void loginCheck() {
  println("loginCheck");
  
  if (debug) {
    println(currentUser);
    if (currentUser == "") {
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
      println(loginData);
      String[] m = match(loginData, "<logintest>(.*?)</logintest>");
      if (m[1].equals("success")) {
        cp5.getTab("overall").bringToFront();
        isLoggedIn = true;
        isWrongPassword = false;
        cp5.getController("logoutBt").show();
        addUserAreaControllers();
      } else if(m[1].equals("registered")) {
        cp5.getTab("login").bringToFront();
      } else {
        println("wrong password");
        isLoggedIn = false;
        isWrongPassword = true;
      }
    }
  }
  
  loadFiles();
  
  cp5.addScrollableList("loadFilesList")
    .setPosition(20, 120)
    .setLabel("Load session")
    .setSize(200, 100)
    .setBarHeight(20)
    .setItemHeight(20)
    .addItems(fileArray)
    ;
  cp5.getController("loadFilesList").moveTo("overall");

  cp5.addButton("deleteFile")
    .setBroadcast(false)
    .setLabel("delete")
    .setPosition(230, 120)
    .setSize(70, 20)
    .setValue(1)
    .setBroadcast(true)
    .getCaptionLabel().align(CENTER, CENTER)
    ;
  cp5.getController("deleteFile").moveTo("overall");
  /////////////////////////////

  currentPage = "overall";
  
  loading = false;
}

public void addUserAreaControllers() {

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

  cp5.addTab("singleSession");
  cp5.getTab("singleSession")
    .activateEvent(true)
    .setId(5)
    ;

  cp5.addTab("eegActivity");
  cp5.getTab("eegActivity")
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
    .getCaptionLabel().align(CENTER, CENTER)
    ;
  cp5.getController("newSession").moveTo("global");

  cp5.addButton("overall")
    .setBroadcast(false)
    .setLabel("overall")
    .setPosition(userTabsX, headerHeight + padding)
    .setSize(buttonWidth, buttonHeight)
    .setValue(1)
    .setBroadcast(true)
    .getCaptionLabel().align(CENTER, CENTER)
    ;
  cp5.getController("overall").moveTo("global");
}

public void timer() {
  while (isEnabled) {
    loading = true;
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

public void loadFilesList(int n) {
  /* request the selected item based on index n */
  println(n, cp5.get(ScrollableList.class, "loadFilesList").getItem(n));
  CColor c = new CColor();
  c.setBackground(color(0));
  cp5.get(ScrollableList.class, "loadFilesList").getItem(n).put("color", c);
  
  loadFile(n);
}

public void mousePressed() {
  
  switch(currentPage){
    case "singleSession":
      eegAvg.onClick(mouseX, mouseY);
      personalAvg.onClick(mouseX, mouseY);
      loadFile(currentItem + fileArray.length - listSize);
      break;
  }
}

void mouseWheel(MouseEvent event) {
  e = event.getCount();
}

public void keyPressed() {
  if (debug) {
    switch(key) {
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
      thread("timer"); // from forum.processing.org/two/discussion/110/trigger-an-event
      break;
    }
  }
}

public void screenshot() {
  try {
    Robot robot_Screenshot = new Robot();
    screenshot = new PImage(robot_Screenshot.createScreenCapture
      (new Rectangle(0, 0, displayWidth, displayHeight)));
  }
  catch (AWTException e) {
  }
  frame.setLocation(0, 0);
}