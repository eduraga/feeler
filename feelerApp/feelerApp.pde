import controlP5.*;
ControlP5 cp5;

import processing.net.*;

JSONObject json;

String encodedAuth = "";
Client client;
String data;

boolean isLoggedIn = false;
String currentUser = "";
String currentPassword = "";
Textfield username;
Textfield password;

final static int TIMER = 100;
static boolean isEnabled = true;

String host;
int port;
String address;

void setup() {
  size(700,400);
  noStroke();
  cp5 = new ControlP5(this);
  
  json = loadJSONObject("config.json");

  host = json.getString("host");
  port = json.getInt("port");
  address = json.getString("address");

  ///////////////////////////////////////
  // tabs (pages) setup
  // if you want to receive a controlEvent when
  // a  tab is clicked, use activeEvent(true)
     
  cp5.getTab("default")
     .activateEvent(true)
     .setLabel("home")
     .setColorBackground(color(230))
     .setColorForeground(color(200))
     .setColorLabel(color(0))
     .setColorActive(color(100))
     .setColorValue(color(0))
     .setId(1)
     //.setWidth(0)
     ;
  
  cp5.addTab("login")
     .setColorBackground(color(100))
     .setColorLabel(color(255))
     .setColorActive(color(100))
     ;
  cp5.getTab("login")
     .activateEvent(true)
     .setId(2)
     //.setWidth(0)
     ;

  cp5.addTab("overall")
     .setColorBackground(color(200))
     .setColorLabel(color(255))
     .setColorActive(color(100))
     ;
  cp5.getTab("overall")
     .activateEvent(true)
     .setId(3)
     //.setWidth(0)
     ;
  
  // custom tab controllers
  cp5.addButton("loginBt")
     .setBroadcast(false)
     .setPosition(width - 100, 20)
     .setSize(80,40)
     .setValue(1)
     .setBroadcast(true)
     .getCaptionLabel().align(CENTER,CENTER)
     ;
  cp5.getController("loginBt").moveTo("global");

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
  

  ///////////////////////////////////////
  // login page controllers
  
  username = cp5.addTextfield("username")
     .setPosition(width/2 - 100, height/2 - 40)
     .setSize(200, 20)
     .setLabel("email")
     .setFocus(true)
     ;
  username.setAutoClear(true);
  cp5.getController("username").moveTo("login");
  
  password = cp5.addTextfield("password")
     .setPosition(width/2 - 100, height/2)
     .setSize(200, 20)
     .setPasswordMode(true)
     .setLabel("password")
     .setFocus(true)
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
}

void draw() {
  background(255);
  
  fill(0);
  
  if(isLoggedIn){
    textAlign(RIGHT);
    text("Hello, " + currentUser, width - 20, 20);
  }
}

void controlEvent(ControlEvent theControlEvent) {
  if (theControlEvent.isTab()) {
    println("got an event from tab : "+theControlEvent.getTab().getName()+" with id "+theControlEvent.getTab().getId());
  }
  
  if (theControlEvent.isAssignableFrom(Textfield.class)) {
    Textfield t = (Textfield)theControlEvent.getController();
    
    if(t.getName() == "username"){
      currentUser = t.getStringValue();
    }
    if(t.getName() == "password"){
      currentPassword = t.getStringValue();
    }
    
    println(host + ", " + port + ", " + address);
    
    client = new Client(this, host, port);
    client.write("POST "+address+" HTTP/1.0\r\n");
    //client.write("Host: api.imagga.com\r\n");
    //client.write("Authorization: Basic " + encodedAuth + "\r\n");
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

    // Textfield.isAutoClear() must be true
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

public void homeBt(int theValue) {
  cp5.getTab("default").bringToFront();
}

public void loginBt(int theValue) {
  cp5.getTab("login").bringToFront();
}

void submit(int theValue) {
  username.submit();
  password.submit();
  thread("timer"); // from forum.processing.org/two/discussion/110/trigger-an-event
}

void loginCheck(){
  //println(client.readString());
  if (client.available() > 0) {    // If there's incoming data from the client...
    data = client.readString();   // ...then grab it and print it
    //println(data);
    String[] m = match(data, "<tag>(.*?)</tag>");
    //println("Found '" + m[1] + "' inside the tag.");
    if(m[1].equals("success")){
      println("success");
      cp5.getController("loginBt").hide();
      cp5.getTab("overall").bringToFront();
      //cp5.getController("username").hide();
      //cp5.getController("password").hide();
      //cp5.getController("submit").hide();
      isLoggedIn = true;
      
    } else {
      println("wrong password");
      isLoggedIn = false;
    }
  }
}

void timer() {
  while (isEnabled) {
    delay(TIMER);
    isEnabled = false;
    loginCheck();
  }
}