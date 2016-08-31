int[] boxStates = {0, 1, 2, 3};
boolean timerOn = false;

String filename;
PrintWriter output;
int datetimestr0;
int datetimestr =  0;

int attention = 0;
int meditation = 0;

long delta1 = 0;
long theta1 = 0;
long low_alpha1 = 0;
long high_alpha1 = 0;
long low_beta1 = 0;
long high_beta1 = 0;
long low_gamma1 = 0;
long mid_gamma1 = 0;

int blinkSt = 0;
int timeline = 0;

int triggerCounter = 0;
int triggerLow = 20;
int triggerMedium = 50;
int triggerHight = 80;

void newSession(){
  
  if(boxState == 200){
    screenshotThresholds();
  }
  
  if(debug || simulateMindSet || simulateBoxes){
    if(boxState >= 100){
      stroke(200);
      line(0, height/4, width, height/4);
      stroke(230);
      line(0, height/4 + height/8, width, height/4 + height/8);
      stroke(200);
      line(0, height/2, width, height/2);
      stroke(230);
      line(0, height/2 + height/4 - height/8, width, height/2 + height/4 - height/8);
      stroke(200);
      line(0, height/2 + height/4, width, height/2 + height/4);
      
      pushStyle();
      if(attention > triggerLow){
        if(attention < 75){
          fill(100,200,200);
        } else {
          fill(200,100,100);
        }
      } else {
        fill(100,100,200);
        cancelScreenshots();
      }
      
      ellipse(width/2, map(attention, 0, 100, height/2 + height/4, height/4), 20, 20);
  
      if(meditation > triggerLow){
        if(meditation < 75){
          fill(100,200,200);
        } else {
          fill(200,100,100);
        }
      } else {
        fill(100,100,200);
      }
      ellipse(width/2 + 40, map(meditation, 0, 100, height/2 + height/4, height/4), 20, 20);
      popStyle();
    }
  }
  
  if(feelerS.checkConnection()){
    text("Boxes: ok", width/2, visHeight);
  } else {
    text("Boxes: disconnected", width/2, visHeight);
  }
  
  
  
  switch(boxState){
    case 0:
      pageH1("New session");
      textSize(20); //added by Eva
      //fill(100);//added by Eva

      if (!mindSetOK && !simulateMindSet) {
         PImage one = loadImage("one.png");// Added by Eva
        image(one, padding + 80, headerHeight + padding + 40 + 30, 60, 60);// Added by Eva
        text("Connect the EEG headset", padding + 80 + 80, headerHeight + padding + 75 + 30);
       
         try {
           //mindSetPort = new Serial(this, Serial.list()[2]);
           mindSet = new MindSet(this, "/dev/cu.MindWaveMobile-DevA");
           println("port ok");
           mindSetOK = true;
         } catch (Exception e) {
           println("port not ok");
           mindSetOK = false;
         }
      } else if(!feelerS.checkConnection() && !simulateBoxes) {
        PImage one = loadImage("one.png");// Added by Eva
        image(one, padding + 80, headerHeight + padding + 40 + 30, 60, 60);// Added by Eva
        text("Connect the EEG headset", padding + 80 + 80, headerHeight + padding + 75 + 30);
        PImage learningGoal = loadImage("checked_big.png");
        image(learningGoal, padding + 340 +80, headerHeight + padding + 50 + 30, 35, 35);
        PImage two = loadImage("two.png");// Added by Eva
        image(two, padding + 80, headerHeight + padding*2 + 100 + 30, 60, 60);// Added by Eva
        text("Connect the boxes", padding + 80 + 80, headerHeight + padding + 155 + 30);
        image(learningGoal, padding + 280 + 80, headerHeight + padding*2 + 110 + 30, 35, 35);
        PImage three = loadImage("three.png");// Added by Eva
        image(three, padding + 80, headerHeight + padding*2 + 180 + 30, 60, 60);// Added by Eva
      } else {
        PImage one = loadImage("one.png");// Added by Eva
        //image(one, padding + 80, headerHeight + padding + 70, 60, 60);// Added by Eva
        image(one, padding + 80, headerHeight + padding + 40 + 30, 60, 60);// Added by Eva
        text("Connect the EEG headset", padding + 80 + 80, headerHeight + padding + 75 + 30);
        PImage learningGoal = loadImage("checked_big.png");
        image(learningGoal, padding + 340 + 80, headerHeight + padding + 50 + 30, 35, 35);
        PImage two = loadImage("two.png");// Added by Eva
        image(two, padding + 80, headerHeight + padding*2 + 100 + 30, 60, 60);// Added by Eva
        text("Connect the boxes", padding + 80 + 80, headerHeight + padding + 155 + 30);
        image(learningGoal, padding + 280 + 80, headerHeight + padding*2 + 110 + 30, 35, 35);
        PImage three = loadImage("three.png");// Added by Eva
        image(three, padding + 80, headerHeight + padding*2 + 180 + 30, 60, 60);// Added by Eva
        
        cp5.getController("startSession").show();
      }
      break;
    case 100:
      cp5.getController("startSession").hide();
      pageH1("New session");
      PImage one = loadImage("one.png");// Added by Eva
      image(one, padding + 80, headerHeight + padding + 40 + 30, 60, 60);// Added by Eva
      textSize(24); //added by Eva
      text("Meditate", padding + 80 + 80, headerHeight + padding + 60 + 30);
      recording = true;
      timerOn = true;
      timeline = 1;
      fill(textDarkColor);
      textSize(16); //added by Eva
      text("Sync your breathing with the box lighting", padding + 80 + 80, headerHeight + padding + 90 + 30);
      PImage meditatebox = loadImage("meditate_box.png");// Added by Eva
      image(meditatebox, padding + 80 + 80, headerHeight + padding + 120 + 30,270,386);// Added by Eva
      counterDisplay();
      
      feelerS.setBoxState(1);
      feelerS.setBox2LedState(0);
      
      if(sw.minute() == 0 && sw.second() == 0){
        println("End meditation");
        feelerS.setBoxState(3);
        sw.stop();
        boxState = 200;
        timerOn = false;
      }
      break;
    case 200:
      pageH1("New session");
      PImage two = loadImage("two.png");// Added by Eva
      image(two, padding + 80, headerHeight + padding + 40 + 30, 60, 60);// Added by Eva
      textSize(24); //added by Eva
      text("Study", padding + 80 + 80, headerHeight + padding + 60 + 30);
      fill(textDarkColor);
      textSize(16); //added by Eva
      text("Focus on your work. Let the time fly", padding + 80 + 80, headerHeight + padding + 90 + 30);
      PImage studybox = loadImage("study_box.png");// Added by Eva
      image(studybox, padding + 80 + 80, headerHeight + padding + 120 + 30,270,386);// Added by Eva
      timeline = 2;
      counterDisplay();
      
      feelerS.setBoxState(3);
      
      if(feelerS.getBoxesConnected() == 1 || simulateBoxes){
        int ledState = int(map(sw.getElapsedTime(), sw.countDownStart, 0, 1, 20));
        println("getElapsedTime: " + sw.getElapsedTime() + ", sw.countDownStart: " + sw.countDownStart);
        // increase this from 0 to 20
        feelerS.setBox2LedState(ledState);
        
        if(!timerOn){
          sw.start(countDownStartStudy);
          timerOn = true;
        //} else if(sw.minute() == 0 && sw.second() == 0){
        } else if(sw.getElapsedTime() <= 50){
          println("End study");
          cancelScreenshots();
          sw.stop();
          timerOn = false;
          boxState = 300;
        }
      }
        
      break;
    case 300:
      if(!recording) recording = true;
      pageH1("New session");
      PImage three = loadImage("three.png");// Added by Eva
      image(three, padding + 80, headerHeight + padding + 40 + 30, 60, 60);// Added by Eva
      textSize(24); //added by Eva
      text("Play", padding + 80 + 80, headerHeight + padding + 60 + 30);
      fill(textDarkColor);
      textSize(16); //added by Eva
      text("Repeat the light sequence as long as you can", padding + 80 + 80, headerHeight + padding + 90 + 30);
      PImage playbox = loadImage("play_box.png");// Added by Eva
      image(playbox, padding + 80 + 80, headerHeight + padding + 120 + 30,270,386);// Added by Eva
      timeline = 3;
      counterDisplay();
      
      feelerS.setBoxState(4);
      feelerS.setBox2LedState(0);
      
      if(!timerOn){
        cu.start();
        timerOn = true;
        cp5.getController("endGame").show();
      //} else if(cu.getElapsedTime() >= 50){
      //  println(cu.getElapsedTime());
      //  boxState = 350;
      //  cu.stop();
      //  timerOn = false;
      }
      break;
    case 400:
      recording = false;
      timeline = 4;
      
      pageH1("Personal experience");
      if(assessQuestion == 1){
        textSize(20);// added by Eva
        assess(assessQuestion, "/3 Select how you felt during:");
        
        feelingRadioMeditation.draw();
        feelingRadioStudy.draw();
        feelingRadioPlay.draw();
        
      } else if(assessQuestion == 2){
        textSize(20);// added by Eva
        assess(assessQuestion, "/3 Select how your level of relaxation during:");
        text("Meditation", padding + 80, 250 + 10); //added by Evad
        text("Study", padding + 80, 250 + 50 + padding*3 + 10); //added by Eva
        text("Play", padding + 80, 250 + 50*2 + padding*6.2 + 10); //added by Eva
      } else if(assessQuestion == 3){
        textSize(20);// added by Eva
        assess(assessQuestion, "/3 Select how your level of attention during:");
        text("Meditation", padding + 80, 250 + 10); //added by Evad
        text("Study", padding + 80, 250 + 50 + padding*3 + 10); //added by Eva
        text("Play", padding + 80, 250 + 50*2 + padding*6.2 + 10); //added by Eva
        hasFinished = false;
      } else if(assessQuestion == 4){
        textSize(20);// added by Eva
        textAlign(LEFT);
        assess(assessQuestion, "Answers saved!\nYour data is being loaded");   
        if(!timerOn){
          timerOn = true;
          //cp5.getController("stopBt").hide();
          //cp5.getController("playPauseBt").hide();
        } else if(cu.getElapsedTime() >= 3000){
          println("geral!!! " + cu.getElapsedTime());
          cu.stop();
          timerOn = false;
          currentPage = "overall";
          cp5.getController("overall").hide();
          cp5.getController("newSession").show();
          println("loadFiles");
          loadFiles();
        }
        //println(sw.getElapsedTime());
      }
      break;
    default:
      pageH1("Start a session");
      break;
  }
  
  if(recording){
      int datetimestr1 = minute()*60+second();
      datetimestr = datetimestr1 - datetimestr0;
      
      output.print(datetimestr);
      output.print(TAB);
      output.print(delta1);
      output.print(TAB);
      output.print(theta1);
      output.print(TAB);
      output.print(low_alpha1);
      output.print(TAB);
      output.print(high_alpha1);
      output.print(TAB);
      output.print(low_beta1);
      output.print(TAB);
      output.print(high_beta1);
      output.print(TAB);
      output.print(low_gamma1);
      output.print(TAB);
      output.print(mid_gamma1);
      output.print(TAB);
      output.print(blinkSt);
      output.print(TAB);
      output.print(attention);
      output.print(TAB);
      output.print(meditation);
      output.print(TAB);
      output.println(timeline);
  }
}

void assess(int questionNo, String question){
  text(question, padding + 15 + 80, headerHeight + padding + 60 + 30);//added by Eva
  //text(question, padding*2, headerHeight + padding*2);
  
  if(questionNo != 4){
    text(questionNo, padding + 80, headerHeight + padding + 60 + 30);//added by Eva
    //text(questionNo, padding, headerHeight + padding*2);
  } else {
    hasFinished = true;
    //currentPage = "eegActivity";
    //if(hasFinished == false){
    //  hasFinished = true;
    //  t.schedule(new TimerTask() {
    //    public void run() {
    //      println("trigger");
    //      hasFinished = true;
    //      print(" " + nf(3, 0, 2));
    //      currentPage = "eegActivity";
    //    }
    //  }, (long) (3*1e3));
    //}
  }
}


void counterDisplay(){
  pushStyle();
  textSize(100);
  textAlign(CENTER);
  //textAlign(10,10);
 
  
  String second;
  String minute;
  
  if( boxState != 300){
    second = new DecimalFormat("00").format(sw.second());
    minute = new DecimalFormat("00").format(sw.minute());
  } else {
    second = new DecimalFormat("00").format(cu.second());
    minute = new DecimalFormat("00").format(cu.minute());
  }

  if(boxState > 0){
    text(minute + ":" + second, width/2, containerPosY + padding);
  }
  popStyle();
}

void screenshotThresholds(){
    if(recording){
      if(attention > triggerLow || meditation > triggerLow){
        if (hasFinished) {
          triggerScreenshots(10);
        }
        //if ((frameCount & 0xF) == 0)   print('.');
      } else {
        cancelScreenshots();
      }
    }
}


/** 
 * TimerTask (v1.3)
 * by GoToLoop (2013/Dec)
 * 
 * forum.processing.org/two/discussion/1725/millis-and-timer
 */
final Timer t = new Timer();
boolean hasFinished = true;

void triggerScreenshots(final float sec) {
  hasFinished = false;
 
  t.schedule(new TimerTask() {
    public void run() {
      //print(" " + nf(sec, 0, 2));
      hasFinished = true;

      //feelerS.sendValues();
      //feelerS.get();
      println(", getBoxesConnected: " + feelerS.getBoxesConnected());
      //println(feelerS.checkConnection());
    }
  }, (long) (sec*1e3));
  

  //feelerS.sendValues();
  //feelerS.get();
  //println(", getBoxesConnected: " + feelerS.getBoxesConnected());
  
  //println("\n\nScreenshot scheduled for "
  //  + nf(10, 0, 2) + " secs.\n");
    
    //feelerS.sendValues();
    //feelerS.get();
    //println(feelerS.checkConnection());
    
    screenshot();
    PImage newImage = createImage(100, 100, RGB);
    newImage = screenshot.get();
    newImage.save(
          sessionPath + "/screenshots/" +
          String.valueOf(datetimestr + "-" + year()) + "-" + String.valueOf(month()) + "-" + String.valueOf(day()) + "-" + String.valueOf(hour()) + "-" + String.valueOf(minute()) + "-" + String.valueOf(second()) +
          "-screenshot.png"
    );
}
///////////////////////////////
void cancelScreenshots(){
  hasFinished = true;
}

//MindSet functions

float attoff = 0.01;
float medoff = 0.0;

void simulate() {
  if(recording){
    poorSignalEvent(int(random(200)));
    
    //simulate with noise
    attoff = attoff + .02;
    attentionEvent(int(noise(attoff) * 100));
    medoff = medoff + .01;
    meditationEvent(int(noise(medoff) * 100));
  
    //simulate with mouse
    //attentionEvent(int(map(mouseX, 0, width, 0, 100)));
    //meditationEvent(int(map(mouseY, height/2, height, 0, 100)));
    
    //attentionEvent(int(random(-50,10)));  
    //meditationEvent(int(random(-50,10)));
    
    eegEvent(int(random(20000)), int(random(20000)), int(random(20000)), 
    int(random(20000)), int(random(20000)), int(random(20000)), 
    int(random(20000)), int(random(20000)) );
  }
}

public void poorSignalEvent(int sig) {
  //signalWidget.add(200-sig);
}

public void attentionEvent(int attentionLevel) {
  //attentionWidget.add(attentionLevel);
  //println("attentionLevel: " + attentionLevel);
  attention = attentionLevel;
}


public void meditationEvent(int meditationLevel) {
  //meditationWidget.add(meditationLevel);
  //println("meditationLevel: " + meditationLevel);
  meditation = meditationLevel;
}

public void eegEvent(int delta, int theta, int low_alpha, 
int high_alpha, int low_beta, int high_beta, int low_gamma, int mid_gamma) {
  
  delta1 = delta;
  theta1 = theta;
  low_alpha1 = low_alpha;
  high_alpha1 = high_alpha;
  low_beta1 = low_beta;
  high_beta1 = high_beta;
  low_gamma1 = low_gamma;
  mid_gamma1 = mid_gamma;
  //deltaWidget.add(delta);
  //thetaWidget.add(theta);
  //lowAlphaWidget.add(low_alpha);
  //highAlphaWidget.add(high_alpha);
  //lowBetaWidget.add(low_beta);
  //highBetaWidget.add(high_beta);
  //lowGammaWidget.add(low_gamma);
  //midGammaWidget.add(mid_gamma);
} 

public void rawEvent(int[] raw){
  //data = raw;
  println(raw);
}