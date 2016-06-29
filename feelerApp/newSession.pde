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

boolean isRecordingMind = false;

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
  
  if(boxState == 100 || boxState == 200 || boxState == 300){
    screenshotThresholds();
  }
  
  switch(boxState){
    case 0:
      if(mindSetOK || simulateMindSet){
        cp5.getController("startSession").show();
      }
      
      pageH1("New session");
      //text("Once you press play, your mental activity will be recorded.\nThe recording will continue uninterrupted while you relax, study and assess\nyour activity.", padding, headerHeight + padding + 40);

      if (!mindSetOK && !simulateMindSet) {
         textAlign(LEFT);
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
      } else {
        text("1. Connect the EEG headset", padding, headerHeight + padding + 40);
        PImage learningGoal = loadImage("learning-goal.png");
        image(learningGoal, padding + 170, headerHeight + padding + 20, 30, 30);
        text("2. Connect the boxes", padding, headerHeight + padding + 60);
      }
      break;
    case 100:
      cp5.getController("startSession").hide();
      pageH1("Meditate");
      isRecordingMind = true;
      timeline = 1;
      fill(textDarkColor);
      text("Sync your breathing with the box lighting", padding, headerHeight + padding + 20);
      counterDisplay();
      if(sw.minute() == 0 && sw.second() == 0){
        println("End meditation");
        sw.start();
        boxState = 200;
      }
      break;
    case 200:
      pageH1("Study");
      text("Focus on your work. Let the time fly", padding, headerHeight + padding + 20);
      timeline = 2;
      counterDisplay();
      if(sw.minute() == 0 && sw.second() == 0){
        println("End study");
        sw.start();
        boxState = 300;
      }
      break;
    case 300:
      pageH1("Play");
      text("Repeat the light sequence as long as you can", padding, headerHeight + padding + 20);
      timeline = 3;
      counterDisplay();
      
      if(sw.minute() == 0 && sw.second() == 0){
        println("End play");
        sw.stop();
        boxState = 400;
        assessQuestion = 1;
        cp5.getController("assess1Bt").show();
      }
      break;
    case 400:
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
      }
      timeline = 4;
      recording = false;
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
    if(hasFinished == false){
      hasFinished = true;
      t.schedule(new TimerTask() {
        public void run() {
          println("trigger");
          hasFinished = true;
          print(" " + nf(3, 0, 2));
          currentPage = "eegActivity";
        }
      }, (long) (3*1e3));
    }
  }
}


void counterDisplay(){
  pushStyle();
  textSize(38);
  textAlign(CENTER);
  
  String second = new DecimalFormat("00").format(sw.second());
  String minute = new DecimalFormat("00").format(sw.minute());
  
  text(minute + ":" + second, width/2, containerPosY + padding);
  popStyle();
}

void screenshotThresholds(){

    if(debug){
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
    }
    
    if(recording){
      if(attention > triggerLow || meditation > triggerLow){
        if (hasFinished) {
          triggerScreenshots(10);
        }
        if ((frameCount & 0xF) == 0)   print('.');
      } else {
        cancelScreenshots();
      }
    }
    
    if(debug){
      
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
      print(" " + nf(sec, 0, 2));
      hasFinished = true;
    }
  }, (long) (sec*1e3));
  
  println("\n\nScreenshot scheduled for "
    + nf(10, 0, 2) + " secs.\n");
    
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

void exit() {
  if(!simulateMindSet){
    println("Exiting");
    mindSet.quit();
    super.exit();
  }
}


float attoff = 0.01;
float medoff = 0.0;

void simulate() {
  poorSignalEvent(int(random(200)));
  
  //simulate with noise
  //attoff = attoff + .02;
  //attentionEvent(int(noise(attoff) * 100));
  //medoff = medoff + .01;
  //meditationEvent(int(noise(medoff) * 100));

  //simulate with mouse
  attentionEvent(int(map(mouseX, 0, width, 0, 100)));
  meditationEvent(int(map(mouseY, height/2, height, 0, 100)));
  
  //attentionEvent(int(random(100)));  
  //meditationEvent(int(random(100)));
  
  eegEvent(int(random(20000)), int(random(20000)), int(random(20000)), 
  int(random(20000)), int(random(20000)), int(random(20000)), 
  int(random(20000)), int(random(20000)) );
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