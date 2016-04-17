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

import processing.serial.*;
import pt.citar.diablu.processing.mindset.*;


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

int assess1 = 50;
int assess2 = 50;
boolean assess3Toggle1 = true;
boolean assess3Toggle2 = true;
int assessQuestion = 0;

//Color
color graphBgColor = color(240);
color textDarkColor = color(100);
color attentionColor = color(150);
color relaxationColor = color(70);

// files handling
int listSize;
float[] attentionAverageList;
float[] relaxationAverageList;

boolean loading = false;
String[] fileName;
String[] fileNames;
String filePath;
String sessionPath;
String[] sessionFolders;
String userFolder;
float attentionAverage = 0;
float relaxationAverage = 0;
String[] assessmentData;
File assessmentFolder;

String userDataFolder = "user-data";
String absolutePath;
FloatTable data;
String filenameString;
String[] fileArray;
String[] fileAssessmentArray;
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

int boxState = 0;

//MindSet stuff
MindSet mindSet;
boolean simulateMindSet = true;

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
  
  eegAvg.setup(visWidth, visHeight);
  personalAvg.setup(visWidth, visHeight);

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



  //Session
  cp5.addButton("startSession")
    .setBroadcast(false)
    .setLabel("Record (start session)")
    .setPosition(padding, headerHeight + padding * 7)
    .setSize(200, 80)
    .setValue(1)
    .setBroadcast(true)
    .getCaptionLabel().align(CENTER, CENTER)
    ;
  cp5.getController("startSession").moveTo("global");
  cp5.getController("startSession").hide();


  //Session assessment
  cp5.addSlider("assess1")
    .setPosition(padding, headerHeight + padding * 3)
    .setRange(0,100)
    ;
  cp5.getController("assess1").moveTo("global");
  cp5.getController("assess1").hide();

  cp5.addButton("assess1Bt")
    .setBroadcast(false)
    .setLabel("Next")
    .setPosition(padding, headerHeight + padding * 4)
    .setSize(70, 20)
    .setValue(1)
    .setBroadcast(true)
    .getCaptionLabel().align(CENTER, CENTER)
    ;
  cp5.getController("assess1Bt").moveTo("global");
  cp5.getController("assess1Bt").hide();
  
  cp5.addSlider("assess2")
    .setPosition(padding, headerHeight + padding * 3)
    .setRange(0,100)
    ;
  cp5.getController("assess2").moveTo("global");
  cp5.getController("assess2").hide();

  cp5.addButton("assess2Bt")
    .setBroadcast(false)
    .setLabel("Next")
    .setPosition(padding, headerHeight + padding * 4)
    .setSize(70, 20)
    .setValue(1)
    .setBroadcast(true)
    .getCaptionLabel().align(CENTER, CENTER)
    ;
  cp5.getController("assess2Bt").moveTo("global");
  cp5.getController("assess2Bt").hide();
  
  cp5.addToggle("assess3Toggle1")
      .setColorLabel(color(0))
      .setLabel("yes/no")
      .setPosition(277, 150)
      .setSize(70, 20)
      .setValue(true)
      .setMode(ControlP5.SWITCH)
      ;
  cp5.getController("assess3Toggle1").moveTo("global");
  cp5.getController("assess3Toggle1").hide();
  
  cp5.addToggle("assess3Toggle2")
      .setColorLabel(color(0))
      .setLabel("yes/no")
      .setPosition(181, 185)
      .setSize(70, 20)
      .setValue(true)
      .setMode(ControlP5.SWITCH)
      ;
  cp5.getController("assess3Toggle2").moveTo("global");
  cp5.getController("assess3Toggle2").hide();
  
  cp5.addButton("assess3Bt")
    .setLabel("Submit")
    .setPosition(padding, headerHeight + padding * 6)
    .setSize(70, 20)
    .setValue(1)
    .setBroadcast(true)
    .getCaptionLabel().align(CENTER, CENTER)
    ;
  cp5.getController("assess3Bt").moveTo("global");
  cp5.getController("assess3Bt").hide();
  /////////////////////////////////
  
  
  //Setup Mindset
  if(!simulateMindSet){
    mindSet = new MindSet(this, "/dev/cu.MindWaveMobile-DevA");
  }
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
      trends.display();
      break;
    case "singleSession":
      singleVisPage();
      break;
    case "eegActivity":
      //eegActivity();
      eegAct.display();
      break;
    case "assessmentActivity":
      //println("assessmentActivity");
      assessmentActivity();
      break;
    case "assessAct":
      break;
    case "newSession":
      newSession();
      break;
  }
  
  if (debug) {
    textAlign(LEFT);

    fill(0, 20);
    rect(0, height-100, width, 100);

    String s = "Press 'L' to log in" +
      "\nPress 'C' after logging in to capture screen." +
      "\nCurrent user:" + currentUser +
      "\nIs logged in:" + isLoggedIn +
      "\nPress 'M' to toggle MindSet simulation"
      ;

    fill(50);
    text(s, padding, height-90, width/3, height-90);
    
    
    if(simulateMindSet){
      simulate();
    }

    
    if(currentPage == "newSession"){
      String s2 = "Box state: " + boxState +
        "\nPress 'P' to to start a session" +
        "\nPress 'S' to study" +
        "\nPress 'A' to assess"
      ;
      text(s2, width/3 + padding*2, height-90, width/2, height-90);
      
      String s3 = "Assessment question 1: " + assess1 + "%" +
        "\nAssessment question 2: " + assess2 + "%" +
        "\nAssessment question 3a: " + assess3Toggle1 +
        "\nAssessment question 3b: " + assess3Toggle2
      ;
      text(s3, (width/3)*2 + padding*2, height-90, width/2, height-90);
    }
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
    boxState = 0;
    break;
  case "startSession":
    println("startSession");
    sessionPath = userFolder + "/" + nf(year(),4)+"-"+nf(month(),2)+"-"+nf(day(),2)+"-"+nf(hour(),2)+"-"+nf(minute(),2)+"-"+nf(second(),2);
    
    //create user folder
    File sessionFolder = new File(dataPath(sessionPath));
    sessionFolder.mkdir();
    
    //filePath = absolutePath + "/user-data/" + currentUser + "/" + "assessment/"+nf(year(),4)+"."+nf(month(),2)+"."+nf(day(),2)+" "+nf(hour(),2)+"."+nf(minute(),2)+"."+nf(second(),2);
    //filename = absolutePath + "/user-data/" + currentUser + "/" + "log/"+nf(year(),4)+"."+nf(month(),2)+"."+nf(day(),2)+" "+nf(hour(),2)+"."+nf(minute(),2)+"."+nf(second(),2) + ".tsv";
    
    filename = sessionPath + "/brain-activity.tsv";
    
    output = createWriter(filename);
    output.println("time" + TAB + "delta" + TAB + "theta" + TAB + "lowAlpha" + TAB + "highAlpha" + TAB + "lowBeta" + TAB + "highBeta" + TAB + "lowGamma" + TAB + "midGamma" + TAB + "blinkSt" + TAB + "attention" + TAB + "meditation" + TAB + "timeline");
    datetimestr0 = minute()*60+second();   
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
  if(isLoggedIn){
    cp5.getController("loginBt").hide();
  }
}

public void logoutBt(int theValue) {
  //cp5.getTab("default").bringToFront();
  cp5.getController("loginBt").show();
  currentUser = "";
  isLoggedIn = false;
  isEnabled = true;
  isWrongPassword = false;
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

public void startSession(int theValue) {
  //currentPage = "meditate";
  boxState = 100;
}


public void assess1Bt(int theValue) {
  assessQuestion = 2;
  cp5.getController("assess1").hide();
  cp5.getController("assess1Bt").hide();
  cp5.getController("assess2").show();
  cp5.getController("assess2Bt").show();
}

public void assess2Bt(int theValue) {
  assessQuestion = 3;
  cp5.getController("assess2").hide();
  cp5.getController("assess2Bt").hide();
  cp5.getController("assess3Bt").show();
  cp5.getController("assess3Toggle1").show();
  cp5.getController("assess3Toggle2").show();
}

public void assess3Bt(int theValue) {
  assessQuestion = 4;
  //cp5.getController("assess3").hide();
  cp5.getController("assess3Bt").hide();
  cp5.getController("assess3Toggle1").hide();
  cp5.getController("assess3Toggle2").hide();
  output.flush();
  output.close();
  
  String[] assessment = {str(assess1), str(assess2), str(assess3Toggle1), str(assess3Toggle2)};
  // Writes the strings to a file, each on a separate line
  saveStrings(sessionPath + "/assessment.txt", assessment);
  
  isRecordingMind = false;
  loadFiles();
}


void assess3Toggle1(boolean theFlag) {
  assess3Toggle1 = theFlag;
}

void assess3Toggle2(boolean theFlag) {
  assess3Toggle2 = theFlag;
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
  println("logincheck");
  
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
  
  //cp5.addScrollableList("loadFilesList")
  //  .setPosition(padding, height/2)
  //  .setLabel("Load session")
  //  .setSize(200, 100)
  //  .setBarHeight(20)
  //  .setItemHeight(20)
  //  .addItems(fileArray)
  //  ;
  //cp5.getController("loadFilesList").moveTo("overall");

  //cp5.addButton("deleteFile")
  //  .setBroadcast(false)
  //  .setLabel("delete")
  //  .setPosition(padding, height/2 + 100 + padding)
  //  .setSize(70, 20)
  //  .setValue(1)
  //  .setBroadcast(true)
  //  .getCaptionLabel().align(CENTER, CENTER)
  //  ;
  //cp5.getController("deleteFile").moveTo("overall");
  
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
    .setPosition(userTabsX, padding)
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
  //println(fileName);
  //println("data: " + directory2 + "/" + filenameString);

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
      personalAvg.setup(visWidth/2, visHeight/2);
      loadFile(currentItem);
      break;
    case "overall":
      trends.onClick();
      eegAct.onClick();
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
    case 'p':
      boxState = 100;
      break;
    case 's':
      boxState = 200;
      break;
    case 'a':
      if(currentPage == "newSession"){
        boxState = 300;
        assessQuestion = 1;
        if(assessQuestion == 1){
          cp5.getController("assess1").show();
          cp5.getController("assess1Bt").show();
        }
      }
      break;
    case 'm':
      simulateMindSet = !simulateMindSet;
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