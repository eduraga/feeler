void assessmentActivity(){
  //personalAssSesion.display(currentItem);
  //personalAvg.display(currentItem);
  personalExperience.display();
  
  if(
    boolean(loadStrings(":)"+loaDir.getLogPath())[2])
    &&
    boolean(loadStrings(":)"+loaDir.getLogPath())[3])
  ){
    PImage learningGoal = loadImage("checked_small.png");
    image(learningGoal, visX + (visWidth/2 - dotSize/2)/2 + padding*2, 430);
  }
  
}