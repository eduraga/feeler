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

void newSession(){  
  switch(boxState){
    case 0:
      cp5.getController("startSession").show();
      pageH1("Start a session");
      text("Once you press play, your mental activity will be recorded.\nThe recording will continue uninterrupted while you relax, study and assess\nyour activity.",
            padding, headerHeight + padding + 40);
      break;
    case 100:
      cp5.getController("startSession").hide();
      pageH1("Relax");
      isRecordingMind = true;
      timeline = 1;
      
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
      
      if(attention > 25){
        
        if (hasFinished) {
          final float waitTime = 10;
          triggerAttentionScreenshots(waitTime);
       
          println("\n\nScreenshot scheduled for "
            + nf(waitTime, 0, 2) + " secs.\n");
            
            screenshot();
            PImage newImage = createImage(100, 100, RGB);
            newImage = screenshot.get();
            newImage.save(
                  sessionPath + "/screenshots/" +
                  String.valueOf(year()) + "-" + String.valueOf(month()) + "-" + String.valueOf(day()) + "-" + String.valueOf(hour()) + "-" + String.valueOf(minute()) + "-" + String.valueOf(second()) +
                  "-screenshot.png"
            );
            
        }
       
        if ((frameCount & 0xF) == 0)   print('.');
        
        if(attention < 75){
          fill(100,200,200);
          //thread("attentionTrigger1");
        } else {
          fill(200,100,100);
        }
      } else {
        fill(100,100,200);
        thread("attentionTrigger2");
        cancelAttentionScreenshots();

      }
      ellipse(width/2, map(attention, 0, 100, height/2 + height/4, height/4), 20, 20);

      if(meditation > 25){
        if(meditation < 75){
          fill(100,200,200);
        } else {
          fill(200,100,100);
        }
      } else {
        fill(100,100,200);
      }
      ellipse(width/2 + 40, map(meditation, 0, 100, height/2 + height/4, height/4), 20, 20);
      
      fill(textDarkColor);
      text("The screen will change according to the amount of time dedicated to this module.\nOnce time is over, an animation showing how to connect the modules would appear.",
            padding, headerHeight + padding + 40);

      break;
    case 200:
      pageH1("Study");
      text("The screen will change according to the amount of time dedicated to this module.\nOnce time is over, an animation showing how to connect the modules would appear.",
            padding, headerHeight + padding + 40);
      timeline = 2;
      break;
    case 300:
      pageH1("Assess");
      if(assessQuestion == 1){
        assess(assessQuestion, "How attentive were you during the session?");
      } else if(assessQuestion == 2){
        assess(assessQuestion, "How relaxed were you during the session?");
      } else if(assessQuestion == 3){
        assess(assessQuestion, "Your performance");
      } else if(assessQuestion == 4){
        assess(assessQuestion, "Answers saved!");
      }
      timeline = 3;
      break;
    default:
      pageH1("Start a session");
      break;
  }
  
  if(isRecordingMind){
      int datetimestr1 = minute()*60+second();
      int datetimestr = datetimestr1 - datetimestr0;
      
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
  if(questionNo != 4){
    text(questionNo, padding, headerHeight + padding*2);
  }
  
  text(question, padding*2, headerHeight + padding*2);
  
  if(questionNo == 3){
    text("Did you have a goal during the session?", padding*2, headerHeight + padding*3.5);
    text("If yes, did you reach it?", padding*2, headerHeight + padding*5);
  }
}


void attentionTrigger1() {
  
  if(triggerCounter % 200 == 0){
    println("Image has been saved.");
    //println(sessionPath + "/" + String.valueOf(year()) + "-" + String.valueOf(month()) + "-" + String.valueOf(day()) + "-" + String.valueOf(hour()) + "-" + String.valueOf(minute()) + "-" + String.valueOf(second()) + "-screenshot.png");
    
    screenshot();
    
    //try {
    //  println("geral");
    //  //Robot robot_Screenshot = new Robot();
    //  //Rectangle rectangle = new Rectangle(0, 0, displayWidth, displayHeight);
    //  //robot_Screenshot.setAutoWaitForIdle(true);
      
    //  //bufferedImage = robot_Screenshot.createScreenCapture(rectangle);
      
    //  //robot_Screenshot.createScreenCapture(rectangle);
    //  //println(bufferedImage);
    //  //screenshot = new PImage(robot_Screenshot.createScreenCapture(rectangle));
    //}
    //catch (AWTException e) {
    //  println(e);
    //}
    //frame.setLocation(0, 0);
    
    //screenshot();
    //PImage newImage = createImage(100, 100, RGB);
    //newImage = screenshot.get();
    //newImage.save(
    //            sessionPath + "/screenshots/" + 
    //            String.valueOf(year()) + "-" + String.valueOf(month()) + "-" + String.valueOf(day()) + "-" + String.valueOf(hour()) + "-" + String.valueOf(minute()) + "-" + String.valueOf(second()) +
    //            ".png"
    //);
    
    triggerCounter = 0;
  }
  
  triggerCounter++;
}

void attentionTrigger2() {
  triggerCounter = 0;
}

static final void logger(String log) {
  println(log);
}


/** 
 * TimerTask (v1.3)
 * by GoToLoop (2013/Dec)
 * 
 * forum.processing.org/two/discussion/1725/millis-and-timer
 */
final Timer t = new Timer();
boolean hasFinished = true;

void triggerAttentionScreenshots(final float sec) {
  hasFinished = false;
 
  t.schedule(new TimerTask() {
    public void run() {
      print(" " + nf(sec, 0, 2));
      hasFinished = true;
    }
  }
  , (long) (sec*1e3));
}
///////////////////////////////
void cancelAttentionScreenshots(){
  hasFinished = true;
}




//MindSet functions

void exit() {
  println("Exiting");
  mindSet.quit();
  super.exit();
}


float attoff = 0.01;
float medoff = 0.0;

void simulate() {
  poorSignalEvent(int(random(200)));
  
  //attoff = attoff + .02;
  //attentionEvent(int(noise(attoff) * 40));
  attentionEvent(int(map(mouseX, 0, width, 0, 100)));
  medoff = medoff + .01;
  meditationEvent(int(noise(medoff) * 40));
  
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