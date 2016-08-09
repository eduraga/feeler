/*
Communication stuff
 
 setup: feelerS.play();
 
 // create a thread to check if boxes are connected
 // feelerS.isConnected();
 feelerS.getButton1();
 4. play: set countUp, unlimited
 
 */

/*
0: connecting
on a new thread:
feelerS.setSettings(10000, 2000, 3000);
feelerS.init("/dev/tty.Feeler-RNI-SPP");
feelerS.setBoxState(0);
isConnected = true;

1: meditating (5 minutes)
feelerS.setBoxState(2);
end of meditation

2: show picture of connecting boxes
wait for:
if feelerS.getBoxStateInput() == 3 then:

3: boxes are connected, go to study
feelerS.setBox2LedSpeed(studyTime/20);
studyTime/20
after each cycle
feelerS.setBox2LedState(currentLed++);
end of study:
feelerS.setBoxState(4);
currentLed = 0;
feelerS.setBox2LedState(0);

4: show image of connecting boxes
if feelerS.getBoxStateInput() == 5 then:

5: start play mode
if feelerS.getBoxStateInput() == 6 then:
end of play
feelerS.setBoxState(6);

*/
int[] boxStates = {0, 1, 2, 3};

boolean isRecordingMind = false;
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
  
  switch(boxState){
    case 0:
      pageH1("New session");

      if (!mindSetOK && !simulateMindSet) {
         text("1. Connect the EEG headset", padding, headerHeight + padding + 40);
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
        text("1. Connect the EEG headset", padding, headerHeight + padding + 40);
        PImage learningGoal = loadImage("learning-goal.png");
        image(learningGoal, padding + 170, headerHeight + padding + 20, 30, 30);
        text("2. Connect the boxes", padding, headerHeight + padding + 60);
      } else {
        text("1. Connect the EEG headset", padding, headerHeight + padding + 40);
        PImage learningGoal = loadImage("learning-goal.png");
        image(learningGoal, padding + 170, headerHeight + padding + 20, 30, 30);
        text("2. Connect the boxes", padding, headerHeight + padding + 60);
        image(learningGoal, padding + 130, headerHeight + padding*2 + 20, 30, 30);
        
        cp5.getController("startSession").show();
      }
      break;
    case 100:
      cp5.getController("startSession").hide();
      pageH1("Meditate");
      isRecordingMind = true;
      timerOn = true;
      timeline = 1;
      fill(textDarkColor);
      text("Sync your breathing with the box lighting", padding, headerHeight + padding + 20);
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
      pageH1("Study");
      text("Focus on your work. Let the time fly", padding, headerHeight + padding + 20);
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
      pageH1("Play");
      text("Repeat the light sequence as long as you can", padding, headerHeight + padding + 20);
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
      isRecordingMind = false;
      timeline = 4;
      
      pageH1("Assess your personal experience");
      if(assessQuestion == 1){
        assess(assessQuestion, "1/3 Select how you felt during:");
        
        feelingRadioMeditation.draw();
        feelingRadioStudy.draw();
        feelingRadioPlay.draw();
        
      } else if(assessQuestion == 2){
        assess(assessQuestion, "2/3 Select how your level of relaxation during:");
      } else if(assessQuestion == 3){
        assess(assessQuestion, "3/3 Select how your level of attention during");
        hasFinished = false;
      } else if(assessQuestion == 4){
        assess(assessQuestion, "Answers saved!\nYour data is being loaded.");        
        if(!timerOn){
          timerOn = true;
          //cp5.getController("stopBt").hide();
          //cp5.getController("playPauseBt").hide();
        } else if(cu.getElapsedTime() >= 3000){
          println("geral!!! " + cu.getElapsedTime());
          cu.stop();
          timerOn = false;
          currentPage = "overall";
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
  
  if(isRecordingMind && recording){
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
  text(question, padding*2, headerHeight + padding*2);
  
  if(questionNo != 4){
    text(questionNo, padding, headerHeight + padding*2);
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
  textSize(38);
  textAlign(CENTER);
  
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