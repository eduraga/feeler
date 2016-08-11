void assessmentActivity(){
  pageH1("Personal experience");
  //personalAssSesion.display(currentItem);
  //personalAvg.display(currentItem);
  personalExperience.display();
  
  if(
    boolean(loadStrings(userFolder + "/" + sessionFolders[currentItem] + "/assessment.txt")[2])
    &&
    boolean(loadStrings(userFolder + "/" + sessionFolders[currentItem] + "/assessment.txt")[3])
  ){
    PImage learningGoal = loadImage("learning-goal.png");
    image(learningGoal, visX + (visWidth/2 - dotSize/2)/2 + padding*2, 430);
  }
  
}