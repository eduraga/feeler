void assessmentActivity(){
  pageH1("Relaxation and Attention levels");
  personalAssSesion.display(currentItem);
  personalAvg.display(currentItem);
  
  
  textAlign(LEFT);
  textSize(28);
  text("Learning goals", padding, 400);
  textSize(12);
  if(
    boolean(loadStrings(userFolder + "/" + sessionFolders[currentItem] + "/assessment.txt")[2])
    &&
    boolean(loadStrings(userFolder + "/" + sessionFolders[currentItem] + "/assessment.txt")[3])
  ){
    PImage learningGoal = loadImage("learning-goal.png");
    image(learningGoal, visX + (visWidth/2 - dotSize/2)/2 + padding*2, 430);
  }
  
}