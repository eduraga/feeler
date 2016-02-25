public void overallAvgs(int i, String position, String caption){
  
  int thisX;
  
  int rectWidth = (visWidth - dotSize/2)/2 + padding*2;
  
  if(position == "right"){
    thisX = visX + rectWidth + padding;
  } else {
    thisX = visX;
  }
  
  fill(graphBgColor);
  rect(thisX, visY - padding, rectWidth, visHeight + padding*2);
  fill(250);
  rect(thisX + padding, visY, rectWidth - padding*2, visHeight);

  String[] fileNames = splitTokens(fileArray[i]);
  
  if(fileNames[0].charAt(0) != '.'){
    String[] fileDate = split(fileNames[0], '.');
    
    if(position == "left"){
      fill(textDarkColor);
      textAlign(LEFT, CENTER);
      text("Session" + fileDate[2] + "." + fileDate[1] + "." + fileDate[0], thisX, visY - padding*2);
    }
   
    float rlxAvg = map(relaxationAverageList[i], 0, 100, 0, rectWidth/2);
    float attAvg = map(attentionAverageList[i], 0, 100, 0, rectWidth/2);
    
    textAlign(CENTER, CENTER);
  
    fill(150);
    rect(thisX + padding, visY, rlxAvg, visHeight/2);
    fill(textDarkColor);
    text("Relaxation "+round(relaxationAverageList[i])+"%", thisX + padding, visY, visWidth/2, visHeight/2);
    
    fill(70);
    rect(thisX + padding, visY + visHeight/2, attAvg, visHeight/2);
    fill(textDarkColor);
    text("Attention "+round(attentionAverageList[i])+"%", thisX + padding, visY + visHeight/2, visWidth/2, visHeight/2);
    
    fill(textDarkColor);
    textAlign(LEFT, CENTER);
    text(caption, thisX, visY + visHeight + padding*2);
  }
}