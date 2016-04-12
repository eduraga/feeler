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




//MindSet functions

void exit() {
  println("Exiting");
  mindSet.quit();
  super.exit();
}

void simulate() {
  poorSignalEvent(int(random(200)));
  attentionEvent(int(random(100)));
  meditationEvent(int(random(100)));
  eegEvent(int(random(20000)), int(random(20000)), int(random(20000)), 
  int(random(20000)), int(random(20000)), int(random(20000)), 
  int(random(20000)), int(random(20000)) );
}

public void poorSignalEvent(int sig) {
  println("sig: " + sig);
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