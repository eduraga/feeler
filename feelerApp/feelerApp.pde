////////////////////////////////////////////////////////////////////
// FEELER | how you feel affects how you learn
// Initiated by Niklas Pöllönen and Régis Frias, http://www.regisfrias.com
// feelerSerial library by Niklas Pöllönen, http://www.pollonen.com
////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////
// Set up //////////////////////////////////////////////////////////

boolean debug = true;
boolean simulateMindSet = true;
boolean simulateBoxes = true;

float countDownStartMeditate = 2;
float countDownStartStudy = 2;

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
// Danger zone /////////////////////////////////////////////////////

import processing.net.*; 
import controlP5.*;
import java.util.*; 
import java.awt.Robot; 
import java.awt.AWTException;
import java.awt.Rectangle;

import java.util.Timer;
import java.util.TimerTask;
import java.text.DecimalFormat;

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException;
import java.nio.*;

import javax.swing.JOptionPane;

import processing.serial.*;
import pt.citar.diablu.processing.mindset.*;

import feelerSerial.*;

feelerSerial feelerS;
boolean boxInit = false;

ControlP5 cp5;

PFont font;

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
boolean registered = false;
boolean isNewUser = false;
boolean serverAvailable = true;
String currentUser = "";
String currentSession = "";
int currentItem;
String currentPassword = "";
Textfield username;
Textfield password;

final static int TIMER = 100;
static boolean isEnabled = true;

CountDown sw = new CountDown();
CountUp cu = new CountUp();
boolean recording = false; 

//UI variables
PImage logo;
OverallAvgs eegAvg, personalAssSesion, personalAvg;
LineChart trends, eegAct, personalExperience;
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
float e = 0;
float containerPosX;
float containerPosY;
int videoWidth = 640;
int videoHeight = 480;
int recControlersWidth = 300;
float upperBoundary;
float lowerBoundary;

PImage homeImg;

boolean assess3Toggle1 = true;
boolean assess3Toggle2 = true;
int assessQuestion = 0;
FeelingRadio feelingRadioMeditation, feelingRadioStudy, feelingRadioPlay;
String feelingAssessMeditation, feelingAssessStudy, feelingAssessPlay;
int assessRelaxationMeditation = 0;
int assessRelaxationStudy = 0;
int assessRelaxationPlay = 0;
int assessAttentionMeditation = 0;
int assessAttentionStudy = 0;
int assessAttentionPlay = 0;

PVector hoverUpLeft, hoverDownRight;

PImage screenshotModal;
PImage close;
PImage close1;
boolean modal = false;
float modalWidth;
float modalHeight;
PImage one;//Added by Eva
PImage two;//Added by Eva
PImage three;//Added by Eva
PImage meditatebox;//Added by Eva
PImage studybox;//Added by Eva
PImage playbox;//Added by Eva
PImage one_1;//Added by Eva
PImage one_2;//Added by Eva
PImage one_3;//Added by Eva

//Color
color graphBgColor = color(240);
color textDarkColor = color(100);
color textLightColor = color(180);
color attentionColor = color(255, 71, 0); //added by Eva
color relaxationColor = color(147, 192, 31); // added by Eva
//color attentionColor = color(234, 79, 51); 
//color relaxationColor = color(167, 196, 58);

// files handling
int listSize;
float[] attentionAverageList;
float[] relaxationAverageList;
float assessmentAttAvgs = 0;
float assessmentRlxAvgs = 0;

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
String[] screenshotsArray;

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
boolean mindSetOK = false;
boolean mindSetPortOk = false;
int mindSetId;
//async log 
Clock longTimer=new Clock();
Logger logger;
//logger.start();
public void setup() {
  logger=new Logger(10);
  font = createFont("GlacialIndifference-Regular-48", 12);
  surface.setTitle("Feeler");
  smooth();
  
  homeImg = loadImage("home.png");
  
  close = loadImage("close.png");
  close1 = loadImage("close1.png");
  
  trends = new LineChart();
  eegAct = new LineChart();
  personalExperience = new LineChart();
  
  hoverUpLeft = new PVector(0,0);
  hoverDownRight = new PVector(0,0);
  
  //size(1200, 850);
  //size(1000, 700);
  size(displayWidth, displayHeight);
  
  //fullScreen();
  surface.setResizable(true);
//double width = screenSize.getWidth();
//double height = screenSize.getHeight();
  //println((int)screenSize.getWidth());
  
  noStroke();
  textSize(12);

  userTabsX = width/2;
  
  visX = (width/3)/2; //change visualisation left position
  visY = headerHeight + padding + 100; //change visualisation top position
  //visY = headerHeight + padding + 60;// old
  visWidth = width - width/4; //change visualisation width
  visHeight = 300; //change visualisation width
  
  //don't change these unless you know what you're doing
  lowerBoundary = visHeight + visY + padding*3;
  upperBoundary = visY + padding*3;

  json = loadJSONObject("config.json");
  host = json.getString("host");
  port = json.getInt("port");
  loginAddress = json.getString("login-address");
  newUserAddress = json.getString("new-user-address");

  cp5 = new ControlP5(this);

  eegAvg = new OverallAvgs("eeg", "");
  //eegAvg = new OverallAvgs("eeg", "Values based on your EEG data");
  personalAssSesion = new OverallAvgs("assessment", "");
  //personalAssSesion = new OverallAvgs("assessment", "Values based on your personal experience");
  personalAvg = new OverallAvgs("eeg", "On average");

  eegAvg.setup(visWidth, visHeight);
  personalAssSesion.setup(visWidth, visHeight);

  //Create UI elements
  containerPosY = 350;//added by Eva
  //containerPosY = height/2 - videoHeight/2;
  containerPosX = width/2 - videoWidth/2;
  
  logo = loadImage("feeler-logo.png");
  
  feelingRadioMeditation = new FeelingRadio(20 + 80, 250 + 10, "Meditation");
  feelingRadioStudy = new FeelingRadio(20 + 80, 250 + 50 + padding*5 + 10, "Study");
  feelingRadioPlay = new FeelingRadio(20 + 80, 250 + 50*2 + padding*10 + 10, "Play");
  
  //Make a new feelerSerial
  feelerS = new feelerSerial(this); 
  
  thread("updateBoxData");

  // Feeler Serial stuff
  //debug mode
  //feelerS.debug();

  //Set the settings you want to send.
  //The settings are speeds(seconds) for the 3 different boxes.
  //first number speed for ledfade in box 1
  feelerS.setSettings(10000, 2000, 3000); //remove this line to use default settings.
  
  
  
  
  //PImage[] imgs = {loadImage("feeler-logo.png"), loadImage("feeler-logo.png"), loadImage("feeler-logo.png")};
  
  //cp5.addButton("homeBt")
  //  .setBroadcast(false)
  //  .setPosition(20, 20)
  //  .setSize(241, 63)
  //  .setLabel("Feeler")
  //  .setImages(imgs)
  //  .setValue(1)
  //  .setBroadcast(true)
  //  .getCaptionLabel().align(CENTER, CENTER)
  //  ;
  //cp5.getController("homeBt").moveTo("global");

  cp5.getTab("default")
    .activateEvent(true)
    .setLabel("home")
    .setId(1)
    ;
    
  cp5.getWindow().setPositionOfTabs(0, -200);

  cp5.addTab("login");
  cp5.getTab("login")
   .activateEvent(true)
   .setId(2)
   ;

  cp5.addTextlabel("label")
  .setText("Login")
  .setPosition(width/2 - 58, height/2 - 230)
  //.setPosition(width/2 - 60, height/2 - 150)
  .setColorValue(color(0))
  .setFont(createFont("font",40))
  ;
  cp5.getController("label").moveTo("login");

  username = cp5.addTextfield("username")
    .setPosition(width/2 - 135, height/2 - 80 -70)
    .setSize(300, 60)
    .setFont(createFont("font",14))// added by Eva
    .setColorCaptionLabel(color(0))// added by Eva
    .setColorLabel(color(0))
    .setColorValue(color(0))// added by Eva
    .setColorBackground(color(209))//Added by Eva
    .setColorForeground(color(209))
    .setColorActive(color(85,26,139))//Added by Eva
    
    .setLabel("username")
    .setFocus(true)
    ;
  username.setAutoClear(true);
  cp5.getController("username").moveTo("login");

  password = cp5.addTextfield("password")
    .setPosition(width/2 - 135, height/2 - 60)
    .setSize(300, 60)
    .setFont(createFont("font",14))// added by Eva
    .setColorCaptionLabel(color(0))// added by Eva
    .setColorLabel(color(0))
    .setColorValue(color(0))// added by Eva
    .setColorBackground(color(209))//Added by Eva
    .setColorForeground(color(209))
    .setColorActive(color(85,26,139))//Added by Eva
    .setPasswordMode(true)
    .setLabel("password")
    ;
  password.setAutoClear(true);
  cp5.getController("password").moveTo("login");

  cp5.addButton("submit")
    .setBroadcast(false)
    .setLabel("login")
    .setFont(createFont("font",14))
    .setPosition(width/2 - 135, height/2 + 40)
    .setColorForeground(color(145,44,238))//Added by Eva
    .setColorBackground(color(85,26,139))//Added by Eva
    .setColorActive(color(85,26,139))//Added by Eva
    .setSize(300, 60)
    //.setSize(240, 40)
    .setValue(1)
    .setBroadcast(true)
    .getCaptionLabel().align(CENTER, CENTER)
    ;
  cp5.getController("submit").moveTo("login");

  cp5.addButton("signup")
    .setBroadcast(false)
    .setLabel("signup")
    .setFont(createFont("font",14))
    .setColorForeground(color(145,44,238))//Added by Eva
    .setColorBackground(color(85,26,139))//Added by Eva
    .setColorActive(color(85,26,139))//Added by Eva
    .setPosition(width/2 - 135, height/2 + 120)
    //.setPosition(width/2 - 115, height/2 + 55)
    .setSize(300, 60)
    //.setSize(240, 40)
    .setValue(1)
    .setBroadcast(true)
    .getCaptionLabel().align(CENTER, CENTER)
    ;
  cp5.getController("signup").moveTo("login");

  cp5.addButton("loginBt")
     .setBroadcast(false)
    .setLabel("Let's go")
    .setFont(createFont("font",14))//Added by Eva
    .setColorForeground(color(145,44,238))//Added by Eva
    .setColorBackground(color(85,26,139))//Added by Eva
    .setColorActive(color(85,26,139))//Added by Eva
    .setPosition(width/2 - 135, height/2 + 270)
    .setSize(300, 60)
    .setValue(1)
    .setBroadcast(true)
    .getCaptionLabel().align(CENTER, CENTER)
    
  //cp5.addButton("loginBt") //old
    //.setBroadcast(false)
    //.setLabel("Login")
    //.setFont(createFont("font",12))//Added by Eva
    //.setColorForeground(color(145,44,238))//Added by Eva
    //.setColorBackground(color(85,26,139))//Added by Eva
    //.setColorActive(color(85,26,139))//Added by Eva
    //.setPosition(width - 180, 20)
    //.setSize(80, 30)
    //.setValue(1)
    //.setBroadcast(true)
    //.getCaptionLabel().align(CENTER, CENTER)
    //.toUpperCase(false)
    //.setFont(font)
    ;
  cp5.getController("loginBt").moveTo("default");

  cp5.addButton("logoutBt")
    .setBroadcast(false)
    .setLabel("Logout")
    //.setPosition(width - 80, 10)
    .setPosition(width - 180, padding)
     .setFont(createFont("font",12))//Added by Eva
    .setColorForeground(color(145,44,238))//Added by Eva
    .setColorBackground(color(85,26,139))//Added by Eva
    .setColorActive(color(85,26,139))//Added by Eva
    .setSize(buttonWidth, 30)
    .setValue(1)
    .setBroadcast(true)
    .getCaptionLabel().align(CENTER, CENTER)
    ;
  cp5.getController("logoutBt").moveTo("global");
  cp5.getController("logoutBt").hide();

  //Session
  cp5.addButton("startSession")
    .setBroadcast(false)
    .setLabel("Record")
    .setFont(createFont("font",16))//Added by Eva
    .setColorForeground(color(145,44,238))//Added by Eva
    .setColorBackground(color(85,26,139))//Added by Eva
    .setColorActive(color(85,26,139))//Added by Eva
    //.setColorForeground(color(153))//Added by Eva
    //.setColorBackground(color(85))//Added by Eva
    //.setColorActive(color(50))//Added by Eva
    .setPosition(padding + 80 + 80, headerHeight + padding * 11 + 30)
    .setSize(300, 60)
    .setValue(1)
    .setBroadcast(true)
    .getCaptionLabel().align(CENTER, CENTER)
    //.toUpperCase(false)
    ;
  cp5.getController("startSession").moveTo("global");
  cp5.getController("startSession").hide();

  cp5.addButton("playPauseBt")
    .setBroadcast(false)
    .setLabel("Pause")
    .setColorForeground(color(145,44,238))//Added by Eva
    .setColorBackground(color(85,26,139))//Added by Eva
    .setColorActive(color(85,26,139))//Added by Eva
    .setFont(createFont("font",16))//Added by Eva
    //.setColorForeground(color(153))//Added by Eva
    //.setColorBackground(color(85))//Added by Eva
    //.setColorActive(color(50))//Added by Eva
    .setPosition(width/2 - 90, containerPosY + padding * 3)//added by Eva
    //.setPosition(width/2 - 50, containerPosY + padding * 2)
    .setSize(80, 80)
    .setValue(1)
    .setBroadcast(true)
    .getCaptionLabel().align(CENTER, CENTER)
    ;
  cp5.getController("playPauseBt").moveTo("global");
  cp5.getController("playPauseBt").hide();
  
  cp5.addButton("stopBt")
    .setBroadcast(false)
    .setLabel("Stop")
    .setFont(createFont("font",16))//Added by Eva
    .setColorForeground(color(145,44,238))//Added by Eva
    .setColorBackground(color(85,26,139))//Added by Eva
    .setColorActive(color(85,26,139))//Added by Eva
    //.setColorForeground(color(153))//Added by Eva
    //.setColorBackground(color(85))//Added by Eva
    //.setColorActive(color(50))//Added by Eva
    .setPosition(width/2 + 10, containerPosY + padding * 3)//added by Eva
    //.setPosition(width/2, containerPosY + padding * 2)
    .setSize(80, 80)
    .setValue(1)
    .setBroadcast(true)
    .getCaptionLabel().align(CENTER, CENTER)
    ;
  cp5.getController("stopBt").moveTo("global");
  cp5.getController("stopBt").hide();
  
  
  cp5.addButton("endGame")
  .setBroadcast(false)
  .setLabel("End game")
  .setFont(createFont("font",16))//Added by Eva
  .setColorForeground(color(145,44,238))//Added by Eva
  .setColorBackground(color(85,26,139))//Added by Eva
  .setColorActive(color(85,26,139))//Added by Eva
  //.setColorForeground(color(153))//Added by Eva
  //.setColorBackground(color(85))//Added by Eva
  //.setColorActive(color(50))//Added by Eva
  .setPosition(width/2 - 60, containerPosY + padding * 3)//added by Eva
  //.setPosition(padding, headerHeight + padding * 4)
  .setSize(120, 80)
  //.setValue(1)
  .setBroadcast(true)
  .getCaptionLabel().align(CENTER, CENTER)
  ;
  cp5.getController("endGame").moveTo("global");
  cp5.getController("endGame").hide();
  
  // assessment 1/3
  cp5.addButton("assess1Bt")
    .setBroadcast(false)
    .setLabel("Next")
    .setFont(createFont("font",14))//Added by Eva
    .setColorForeground(color(145,44,238))//Added by Eva
    .setColorBackground(color(85,26,139))//Added by Eva
    .setColorActive(color(85,26,139))//Added by Eva
    .setPosition(padding + 260 + 80, headerHeight + padding * 29 + 10)
    .setSize(80, 40)
    .setValue(1)
    .setBroadcast(true)
    .getCaptionLabel().align(CENTER, CENTER)
    ;
  cp5.getController("assess1Bt").moveTo("global");
  cp5.getController("assess1Bt").hide();
  
  // assessment 2/3
  cp5.addSlider("assessRelaxationMeditation")
    //.setLabel("Meditation")//old label
    .setLabel("%")
    .setFont(createFont("font",20))//Added by Eva
    .setColorLabel(textDarkColor)
    .setSize(340,60)
    .setColorBackground(color(209))//Added by Eva
    .setColorActive(color(relaxationColor))//Added by Eva
    .setColorForeground(color(relaxationColor))//Added by Eva
    .setPosition(padding + 80, headerHeight + padding * 8 + 10)
    .setRange(0, 100)
    ;
  cp5.getController("assessRelaxationMeditation").moveTo("global");
  cp5.getController("assessRelaxationMeditation").hide();
  
  cp5.addSlider("assessRelaxationStudy")
  //.setLabel("Study")//old label
    .setLabel("%")
    .setFont(createFont("font",20))//Added by Eva
    .setColorLabel(textDarkColor)
    .setSize(340,60)
    .setColorBackground(color(209))//Added by Eva
    .setColorActive(color(relaxationColor))//Added by Eva
    .setColorForeground(color(relaxationColor))//Added by Eva
    .setPosition(padding + 80, headerHeight + padding * 13.6 + 10)
    .setRange(0, 100)
    ;
  cp5.getController("assessRelaxationStudy").moveTo("global");
  cp5.getController("assessRelaxationStudy").hide();
  
  cp5.addSlider("assessRelaxationPlay")
  //.setLabel("Play")//old label
    .setLabel("%")
    .setFont(createFont("font",20))//Added by Eva
    .setColorLabel(textDarkColor)
    .setSize(340,60)
    .setColorBackground(color(209))//Added by Eva
    .setColorActive(color(relaxationColor))//Added by Eva
    .setColorForeground(color(relaxationColor))//Added by Eva
    .setPosition(padding + 80, headerHeight + padding * 19.3 + 10)
    .setRange(0, 100)
    ;
  cp5.getController("assessRelaxationPlay").moveTo("global");
  cp5.getController("assessRelaxationPlay").hide();

  cp5.addButton("assess22Bt")
    .setBroadcast(false)
    .setLabel("Previous")
    .setFont(createFont("font",14))//Added by Eva
    .setColorForeground(color(145,44,238))//Added by Eva
    .setColorBackground(color(85,26,139))//Added by Eva
    .setColorActive(color(85,26,139))//Added by Eva
    .setPosition(padding + 160 + 80, headerHeight + padding * 23.2 + 10)
    .setSize(80, 40)
    .setValue(1)
    .setBroadcast(true)
    .getCaptionLabel().align(CENTER, CENTER)
    ;
  cp5.getController("assess22Bt").moveTo("global");
  cp5.getController("assess22Bt").hide();
  
  cp5.addButton("assess2Bt")
    .setBroadcast(false)
    .setLabel("Next")
    .setFont(createFont("font",14))//Added by Eva
    .setColorForeground(color(145,44,238))//Added by Eva
    .setColorBackground(color(85,26,139))//Added by Eva
    .setColorActive(color(85,26,139))//Added by Eva
    .setPosition(padding + 260 + 80, headerHeight + padding * 23.2 + 10)
    .setSize(80, 40)
    .setValue(1)
    .setBroadcast(true)
    .getCaptionLabel().align(CENTER, CENTER)
    ;
  cp5.getController("assess2Bt").moveTo("global");
  cp5.getController("assess2Bt").hide();
  
  // assessment 3/3
  cp5.addSlider("assessAttentionMeditation")
     //.setLabel("Meditation")//old label
    .setLabel("%")
    .setFont(createFont("font",20))//Added by Eva
    .setColorLabel(textDarkColor)
    .setSize(340,60)
    .setColorBackground(color(209))//Added by Eva
    .setColorActive(color(attentionColor))//Added by Eva
    .setColorForeground(color(attentionColor))//Added by Eva
    .setPosition(padding + 80, headerHeight + padding * 8 + 10)
    .setRange(0, 100)
    ;
  cp5.getController("assessAttentionMeditation").moveTo("global");
  cp5.getController("assessAttentionMeditation").hide();
  
  cp5.addSlider("assessAttentionStudy")
     //.setLabel("Study")//old label
    .setLabel("%")
    .setFont(createFont("font",20))//Added by Eva
    .setColorLabel(textDarkColor)
    .setSize(340,60)
    .setColorBackground(color(209))//Added by Eva
    .setColorActive(color(attentionColor))//Added by Eva
    .setColorForeground(color(attentionColor))//Added by Eva
    .setPosition(padding + 80, headerHeight + padding * 13.6 + 10)
    .setRange(0, 100)
    ;
  cp5.getController("assessAttentionStudy").moveTo("global");
  cp5.getController("assessAttentionStudy").hide();
  
  cp5.addSlider("assessAttentionPlay")
    //.setLabel("Play")//old label
    .setLabel("%")
    .setFont(createFont("font",20))//Added by Eva
    .setColorLabel(textDarkColor)
    .setSize(340,60)
    .setColorBackground(color(209))//Added by Eva
    .setColorActive(color(attentionColor))//Added by Eva
    .setColorForeground(color(attentionColor))//Added by Eva
    .setPosition(padding + 80, headerHeight + padding * 19.3 + 10)
    .setRange(0, 100)
    ;
  cp5.getController("assessAttentionPlay").moveTo("global");
  cp5.getController("assessAttentionPlay").hide();

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
  
  
  cp5.addButton("assess33Bt")
  .setBroadcast(false)
  .setLabel("Previous")
  .setFont(createFont("font",14))//Added by Eva
  .setColorForeground(color(145,44,238))//Added by Eva
  .setColorBackground(color(85,26,139))//Added by Eva
  .setColorActive(color(85,26,139))//Added by Eva
  .setPosition(padding + 160 + 80, headerHeight + padding * 23.2 + 10)
  .setSize(80, 40)
  //.setValue(1)
  .setBroadcast(true)
  .getCaptionLabel().align(CENTER, CENTER)
  ;
  cp5.getController("assess33Bt").moveTo("global");
  cp5.getController("assess33Bt").hide();
  
  cp5.addButton("assess3Bt")
  .setBroadcast(false)
  .setLabel("Submit")
  .setFont(createFont("font",14))//Added by Eva
  .setColorForeground(color(145,44,238))//Added by Eva
  .setColorBackground(color(85,26,139))//Added by Eva
  .setColorActive(color(85,26,139))//Added by Eva
  .setPosition(padding + 260 + 80, headerHeight + padding * 23.2 + 10)
  .setSize(80, 40)
  .setBroadcast(true)
  .getCaptionLabel().align(CENTER, CENTER)
  //.setValue(1)
  ;
  cp5.getController("assess3Bt").moveTo("global");
  cp5.getController("assess3Bt").hide();
  
  /////////////////////////////////

}

public void draw() {
  textFont(font);
  textAlign(LEFT);
  
  
  background(255);
  fill(0);
  image(logo, 100, 20);// added by Eva, margin left was before 20
  
  //draw all the controllers in the beginning so that everything else will be drawn on top of them
  //put this after something if that something should be below the controllers
  cp5.draw();
  
  if ( millis() % 100 == 0) {
    //feelerS.sendValues();
    try {
      feelerS.get();
    } catch (NullPointerException e) {
    }
    
  }
  
  if(
    mouseX > hoverUpLeft.x &&
    mouseX < hoverDownRight.x
    &&
    mouseY > hoverUpLeft.y &&
    mouseY < hoverDownRight.y
  ){
    cursor(HAND);
  } else {
    cursor(ARROW);
  }
  

  if (isLoggedIn) {
    pushStyle();
    textAlign(RIGHT);
    text("Hello, " + currentUser, width - 110, padding*3 + 10);
    popStyle();
  }

  if (isWrongPassword) {
    pushStyle();
    textAlign(CENTER);
    text("Wrong username or password", width/2, height/2 - 270);
    popStyle();
  }
  
  if (registered) {
    pushStyle();
    textAlign(CENTER);
    text("New user successfully registered!\nPlease log in.", width/2, height/2 - 270);
    popStyle();
  }
  
  if(!serverAvailable){
    pushStyle();
    textAlign(CENTER);
    text("Server not available", width/2, height/2 - 270);
    popStyle();
  }


  //Visualisation
  switch(currentPage) {
  case "home":
    if (!loading) {
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
    
    if(userFolder != null){
      text(userFolder, padding, height-110);
    }
    
    if (simulateMindSet) {
      text("generating simulated data", padding, height-130);
    }

    if (currentPage == "newSession") {
      String s2 = "Box state: " + boxState +
        "\nPress 'S' to study" +
        "\nPress 'A' to assess"
        ;
      text(s2, width/3 + padding*2, height-90, width/2, height-90);

      String s3 = "\nAssessment question 3a: " + assess3Toggle1 +
        "\nAssessment question 3b: " + assess3Toggle2
        ;
      text(s3, (width/3)*2 + padding*2, height-90, width/2, height-90);
    }
  }
  
  if (simulateMindSet) {
    simulate();
  }

  textAlign(CENTER);
  if (loading) {
    //text("Loading...", width/2 + 20, height/2);
    //textSize(12);
    //fill(textLightColor);
  }
  
  if(modal){
    if(
        mouseX >= modalWidth/4 - padding - 10 &&
        mouseX <= modalWidth/4 - padding - 10 + 30 &&
        mouseY >= modalHeight/4 - padding - 10 &&
        mouseY <= modalHeight/4 - padding - 10 + 30
    ){
      cursor(HAND);
      
    }
    
    fill(230);
    //fill(160);
    stroke(85,26,139);
    //strokeWeight(3);
    rect(modalWidth/4 - padding - 10, modalHeight/4 - padding - 10, modalWidth + padding*2 + 10 + 5, modalHeight + padding*2 + 10 +5);
    noStroke();
    image(screenshotModal, modalWidth/4, modalHeight/4 + 5, modalWidth, modalHeight);
    image(close,modalWidth/4 - padding - 10, modalHeight/4 - padding - 10);
    
  }
}


void cleanUpSurvey(){
    cp5.getController("session").hide();
    cp5.getController("endGame").hide();
    cp5.getController("assess1Bt").hide();
    cp5.getController("assessRelaxationMeditation").hide();
    cp5.getController("assessRelaxationStudy").hide();
    cp5.getController("assessRelaxationPlay").hide();
    cp5.getController("assess22Bt").hide();
    cp5.getController("assess2Bt").hide();
    cp5.getController("assessAttentionMeditation").hide();
    cp5.getController("assessAttentionStudy").hide();
    cp5.getController("assessAttentionPlay").hide();
    cp5.getController("assess3Toggle1").hide();
    cp5.getController("assess3Toggle2").hide();
    cp5.getController("assess33Bt").hide();
    cp5.getController("assess3Bt").hide();// added by Eva
    //cp5.addButton("assess3Bt").hide();
}

public void controlEvent(ControlEvent theControlEvent) {
  if (theControlEvent.isTab()) {
    println("got an event from tab : "+theControlEvent.getTab().getName()+" with id "+theControlEvent.getTab().getId());
  }

  switch(theControlEvent.getName()) {
  case "overall":
    println("overall page");
    currentPage = "overall";
    
    //clean up
    cleanUpSurvey();
    
    personalAssSesion.setup(visWidth, visHeight);
    personalAvg.setup(visWidth, visHeight);
    break;
  case "newSession":
    boxState = 0;
    sw.stop();
  
    if(!simulateBoxes){
      try{
        feelerS.init("/dev/tty.Feeler-RNI-SPP");
      } catch (NullPointerException e){
      }
    }
    println("newSession page");
    currentPage = "newSession";
    boxState = 0;
    break;
  case "startSession":
    feelerS.play();
    feelerS.setBox2LedSpeed(2000);
    datetimestr0 = millis() / 1000;
    println("startSession");
    sw.start(countDownStartMeditate);
    sessionPath = userFolder + "/" + nf(year(), 4)+"-"+nf(month(), 2)+"-"+nf(day(), 2)+"-"+nf(hour(), 2)+"-"+nf(minute(), 2)+"-"+nf(second(), 2);

    //create user folder
    File sessionFolder = new File(dataPath(sessionPath));
    sessionFolder.mkdir();
    File sessionImgFolder = new File(dataPath(sessionPath + "/screenshots"));
    sessionImgFolder.mkdir();
    String[] tempAssessment = {"", "", "", "50", "50", "50"};
    saveStrings(sessionPath + "/assessment.txt", tempAssessment);

    //filePath = absolutePath + "/user-data/" + currentUser + "/" + "assessment/"+nf(year(),4)+"."+nf(month(),2)+"."+nf(day(),2)+" "+nf(hour(),2)+"."+nf(minute(),2)+"."+nf(second(),2);
    //filename = absolutePath + "/user-data/" + currentUser + "/" + "log/"+nf(year(),4)+"."+nf(month(),2)+"."+nf(day(),2)+" "+nf(hour(),2)+"."+nf(minute(),2)+"."+nf(second(),2) + ".tsv";

    filename = sessionPath + "/brain-activity.tsv";

    output = createWriter(filename);
    output.println("time" + TAB + "delta" + TAB + "theta" + TAB + "lowAlpha" + TAB + "highAlpha" + TAB + "lowBeta" + TAB + "highBeta" + TAB + "lowGamma" + TAB + "midGamma" + TAB + "blinkSt" + TAB + "attention" + TAB + "meditation" + TAB + "timeline");
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
    cp5.getController("startSession").hide();
    
    cp5.getController("playPauseBt").hide();
    cp5.getController("stopBt").hide();
    
    cleanUpSurvey();
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
  currentPage = "home";
  //cp5.getTab("default").bringToFront();
  if (isLoggedIn) {
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
  modal = false;
  cp5.getController("overall").hide();
  cp5.getController("newSession").show();
  cp5.getTab("overall").bringToFront();
  cp5.getController("playPauseBt").hide();
  cp5.getController("stopBt").hide();
  cleanUpSurvey();
}


public void session(int theValue) {
  println("this session: " + currentSession);
  cp5.getController("session").hide();
  
  if(currentSession != ""){
    currentPage = "singleSession";
    cp5.getTab("singleSession").bringToFront();
    currentSession = sessionFolders[currentItem];
  }
  //currentItem = i;
  //trends.onClick();
  //eegAct.onClick();
}

public void export(int theValue) {
  selectFolder("Select a folder to save your data:", "folderSelected");
}

public void startSession(int theValue) {
  //currentPage = "meditate";
  boxState = 100;
  cp5.getController("newSession").hide();
  //cp5.getController("overall").show();
}

public void playPauseBt(int theValue){
  sw.playPause();
  println(recording);
  if(recording){
    cp5.getController("playPauseBt").setLabel("Pause");
  } else {
    cp5.getController("playPauseBt").setLabel("Play");
  }
}

public void stopBt(int theValue){
  boxState = 0;
  sw.stop();
}

public void endGame(int theValue){
  println("end game");
  assessQuestion = 1;
  cp5.getController("endGame").hide();
  cp5.getController("playPauseBt").hide();
  cp5.getController("stopBt").hide();
  cu.stop();
  boxState = 400;
  cp5.getController("assess1Bt").show();
}


public void assess1Bt(int theValue) {  
  if(feelingAssessMeditation == "" && feelingAssessStudy == "" && feelingAssessPlay == ""){
    final String[] options = {
      "Ok"
    };
    
    JOptionPane.showOptionDialog(null, "Please answer the survey before continuing", "Warning", JOptionPane.NO_OPTION, JOptionPane.QUESTION_MESSAGE, null, options, options[0]);
  } else {
    saveAssessmentTxt();
    assessQuestion = 2;
    cp5.getController("assessRelaxationMeditation").show();
    cp5.getController("assessRelaxationStudy").show();
    cp5.getController("assessRelaxationPlay").show();
    
    cp5.getController("assess1Bt").hide();
    cp5.getController("assess2Bt").show();
    cp5.getController("assess22Bt").show();
  }
}

public void assess22Bt(int theValue) {
  cp5.getController("assessRelaxationMeditation").hide();
  cp5.getController("assessRelaxationStudy").hide();
  cp5.getController("assessRelaxationPlay").hide();
  cp5.getController("assess22Bt").hide();
  cp5.getController("assess2Bt").hide();

  boxState = 400;
  assessQuestion = 1;
  cp5.getController("assess1Bt").show();
}

public void assess2Bt(int theValue) {
  if(int(assessRelaxationMeditation) == 0 && int(assessRelaxationStudy) == 0 && int(assessRelaxationPlay) == 0){
    final String[] options = {
      "Ok"
    };
    JOptionPane.showOptionDialog(null, "Please answer the survey before continuing", "Warning", JOptionPane.NO_OPTION, JOptionPane.QUESTION_MESSAGE, null, options, options[0]);
  } else {
      assessQuestion = 3;
      
      cp5.getController("assessRelaxationMeditation").hide();
      cp5.getController("assessRelaxationStudy").hide();
      cp5.getController("assessRelaxationPlay").hide();
      
      cp5.getController("assessAttentionMeditation").show();
      cp5.getController("assessAttentionStudy").show();
      cp5.getController("assessAttentionPlay").show();
      
      cp5.getController("assess2Bt").hide();
      cp5.getController("assess22Bt").hide();
      cp5.getController("assess33Bt").show();
      cp5.getController("assess3Bt").show();
  }
}

public void assess33Bt(int theValue) {
  assessQuestion = 2;
  
  cp5.getController("assessRelaxationMeditation").show();
  cp5.getController("assessRelaxationStudy").show();
  cp5.getController("assessRelaxationPlay").show();
  
  cp5.getController("assessAttentionMeditation").hide();
  cp5.getController("assessAttentionStudy").hide();
  cp5.getController("assessAttentionPlay").hide();
  
  cp5.getController("assess2Bt").show();
  cp5.getController("assess22Bt").show();
  cp5.getController("assess3Bt").hide();
  cp5.getController("assess33Bt").hide();
  
}

public void assess3Bt(int theValue) {
  if(int(assessAttentionMeditation) == 0 && int(assessAttentionStudy) == 0 && int(assessAttentionPlay) == 0){
    final String[] options = {
      "Ok"
    };
    JOptionPane.showOptionDialog(null, "Please answer the survey before continuing", "Warning", JOptionPane.NO_OPTION, JOptionPane.QUESTION_MESSAGE, null, options, options[0]);
  } else {
    saveAssessmentTxt();
    assessQuestion = 4;
    cu.start();
    
    cp5.getController("assessAttentionMeditation").hide();
    cp5.getController("assessAttentionStudy").hide();
    cp5.getController("assessAttentionPlay").hide();
    
    cp5.getController("assess3Bt").hide();
    cp5.getController("assess3Toggle1").hide();
    cp5.getController("assess3Toggle2").hide();
    cp5.getController("assess33Bt").hide();
    
    output.flush();
    output.close();
    
    feelingAssessMeditation = "";
    feelingAssessStudy = "";
    feelingAssessPlay = "";
    assessRelaxationMeditation = 0;
    assessRelaxationStudy = 0;
    assessRelaxationPlay = 0;
    assessAttentionMeditation = 0;
    assessAttentionStudy = 0;
    assessAttentionPlay = 0;
  }
}

void saveAssessmentTxt(){
  String[] assessment = {feelingAssessMeditation, feelingAssessStudy, feelingAssessPlay, str(assessRelaxationMeditation), str(assessRelaxationStudy), str(assessRelaxationPlay), str(assessAttentionMeditation), str(assessAttentionStudy), str(assessAttentionPlay)};
  // Writes the strings to a file, each on a separate line
  saveStrings(sessionPath + "/assessment.txt", assessment);
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
    
    currentPage = "overall";
    loadFiles();
    loading = false;
  } else {
    if (client.available() > 0) {
      serverAvailable = true;
      loginData = client.readString();
      println(loginData);
      String[] m = match(loginData, "<logintest>(.*?)</logintest>");
      if (m[1].equals("success")) {
        cp5.getTab("overall").bringToFront();
        isLoggedIn = true;
        isWrongPassword = false;
        registered = false;
        cp5.getController("logoutBt").show();
        addUserAreaControllers();

        currentPage = "overall";
        loadFiles();
        loading = false;
      } else if (m[1].equals("registered")) {
        registered = true;
        isWrongPassword = false;
        cp5.getTab("login").bringToFront();
      } else {
        println("wrong password");
        isLoggedIn = false;
        isWrongPassword = true;
      }
    } else {
      println("Server not available.");
      serverAvailable = false;
    }
  }
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
    .setId(6)
    ;

  //other controllers
  cp5.addButton("newSession")
    .setBroadcast(false)
    .setLabel("New session")
    .setColorForeground(color(145,44,238))//Added by Eva
    .setColorBackground(color(85,26,139))//Added by Eva
    .setColorActive(color(85,26,139))//Added by Eva
    .setFont(createFont("",12))//Added by Eva
    .setPosition(width - 180 - 110, padding)
    .setSize(100, 30)
    .setValue(1)
    .setBroadcast(true)
    .getCaptionLabel().align(CENTER, CENTER)
    
    ;
  cp5.getController("newSession").moveTo("global");

  cp5.addButton("overall")
    .setLabel("< Your activity")// before "review"
    .setFont(createFont("font",12))//Added by Eva 
    //.setColorBackground(color(255))
    //.setColorForeground(color(255))
    //.setColorLabel(textDarkColor)
    .setColorForeground(color(145,44,238))//Added by Eva
    .setColorBackground(color(85,26,139))//Added by Eva
    .setColorActive(color(85,26,139))//Added by Eva
    .setPosition(100, headerHeight + padding + 90)
    //.setPosition(width/2 - buttonWidth/2 - 1, padding)
    //.setPosition(visX - padding, visY - padding*2)
    //.setPosition(width - padding*3 - buttonWidth*3, padding)// upper position
    .setSize(120, 30)
    .setValue(1)
    .setBroadcast(true)
    .getCaptionLabel().align(CENTER, CENTER)
    ;
  cp5.getController("overall").moveTo("global");
  cp5.getController("overall").hide();
  
  cp5.addButton("session")
    .setBroadcast(false)
    .setLabel("< current session")
    .setFont(createFont("font",12))//Added by Eva 
    .setColorForeground(color(145,44,238))//Added by Eva
    .setColorBackground(color(85,26,139))//Added by Eva
    .setColorActive(color(85,26,139))//Added by Eva
    .setPosition(100 + 130, headerHeight + padding + 90)
    //.setPosition(width - padding*4 - buttonWidth*3 - 130, padding)// old
    //.setPosition(visX + 85, visY - padding*2 - 15)
    //.setFont(font)
    .setSize(170, 30)
    .setValue(1)
    .setBroadcast(true)
    .getCaptionLabel().align(CENTER, CENTER)
    ;
  cp5.getController("session").moveTo("global");
  cp5.getController("session").hide();
  
  cp5.addButton("export")
    .setBroadcast(false)
    .setLabel("export data")
    .setFont(createFont("font",12))//Added by Eva 
    .setColorForeground(color(145,44,238))//Added by Eva
    .setColorBackground(color(85,26,139))//Added by Eva
    .setColorActive(color(85,26,139))//Added by Eva
    .setPosition(width - 120 - 110, headerHeight + padding + 90)
    //.setPosition(width - padding - buttonWidth, padding*4)// old
    .setSize(120, 30)
    .setValue(1)
    .setBroadcast(true)
    .getCaptionLabel().align(CENTER, CENTER)
    ;
  cp5.getController("export").moveTo("singleSession");
  
  //avoid that controllers are drawn at the end of draw()
  cp5.setAutoDraw(false);
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
  
  switch(currentPage) {
    case "singleSession":
      eegAvg.onClick(mouseX, mouseY);
      personalAssSesion.onClick(mouseX, mouseY);
      cp5.getController("session").show();
      loadFile(currentItem);
      break;
    case "overall":
      trends.onClick();
      eegAct.onClick();
      break;
    case "eegActivity":
      trends.onClick();
      eegAct.onClick();
      break;
  }
  
  feelingRadioMeditation.click();
  feelingRadioStudy.click();
  feelingRadioPlay.click();
  
  if(modal){
    if(
        mouseX >= modalWidth/4 - padding - 10 &&
        mouseX <= modalWidth/4 - padding - 10 + 30 &&
        mouseY >= modalHeight/4 - padding - 10 &&
        mouseY <= modalHeight/4 - padding - 10 + 30
    ){
      modal = false;
    }
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
    case 's':
      sw.start(countDownStartMeditate);
      boxState = 200;
      break;
    case 'p':
      sw.stop();
      cp5.getController("playPauseBt").show();
      cp5.getController("stopBt").show();
      boxState = 300;
      break;
    case 'a':
      cp5.getController("playPauseBt").hide();
      sw.stop();
      
      if (currentPage == "newSession") {
        boxState = 400;
        assessQuestion = 1;
        if (assessQuestion == 1) {
          cp5.getController("assess1Bt").show();
        }
      }
      break;
    case 'm':
      simulateMindSet = !simulateMindSet;
    case 'q':
      sw.stop();
      cp5.getController("playPauseBt").hide();
      break;
    case 'w':
      sw.start(countDownStartStudy);
      break;
    case 'e':
      sw.playPause();
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
    println(e);
  }
  frame.setLocation(0, 0);
}


void folderSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
      
    //save brain activity
    File fin = new File(userFolder + "/" + sessionFolders[currentItem] + "/brain-activity.tsv");
    File fout = new File(savePath(selection.getAbsolutePath() + "/" + currentUser + "/" + sessionFolders[currentItem] + "/brain-activity.tsv"));
    
    try {
      FileInputStream fis  = new FileInputStream(fin);
      FileOutputStream fos = new FileOutputStream(fout);
        
      byte[] buf = new byte[1024];
      int i = 0;
      while((i=fis.read(buf))!=-1) {
        fos.write(buf, 0, i);
      }
      fis.close();
      fos.close();
    } catch (Exception e) {
      println( "Error occured at ... " );
      e.printStackTrace();
    } finally {
      // what to do when finished trying and catching ...               
    }

    //save assessment
    File fin2 = new File(userFolder + "/" + sessionFolders[currentItem] + "/assessment.txt");
    File fout2 = new File(savePath(selection.getAbsolutePath() + "/" + currentUser + "/" + sessionFolders[currentItem] + "/assessment.txt"));

    try {
      FileInputStream fis  = new FileInputStream(fin2);
      FileOutputStream fos = new FileOutputStream(fout2);
        
      byte[] buf = new byte[1024];
      int i = 0;
      while((i=fis.read(buf))!=-1) {
        fos.write(buf, 0, i);
      }
      fis.close();
      fos.close();
    } catch (Exception e) {
      println( "Error occured at ... " );
      e.printStackTrace();
    } finally {
      // what to do when finished trying and catching ...
    }
    
  }
}

void openModal(String img){
  screenshotModal = loadImage(img);
  modalWidth = screenshotModal.width/1.5;
  modalHeight = screenshotModal.height/1.5;
}


void updateBoxData(){
  while(true){
    if ( millis() % 500 == 0) {
      
      try{
        feelerS.sendValues();
      } catch (Exception e) {}
      
      try{
        feelerS.get();
      } catch (Exception e) {}
    }
  }
}

void exit() {
  println("exiting");
  if(!simulateMindSet){
    mindSet.quit();
  }

  println("closeWindow");
  super.exit();  
}