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
      text("The screen will change according to the amount of time dedicated to this module.\nOnce time is over, an animation showing how to connect the modules would appear.",
            padding, headerHeight + padding + 40);
      break;
    case 200:
      pageH1("Study");
      text("The screen will change according to the amount of time dedicated to this module.\nOnce time is over, an animation showing how to connect the modules would appear.",
            padding, headerHeight + padding + 40);
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
      break;
    default:
      pageH1("Start a session");
      break;
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