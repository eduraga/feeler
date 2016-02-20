public void overallAvgs(int i){
  
  int rectWidth = (visWidth - dotSize/2)/2 + padding*2;
  
  fill(graphBgColor);
  rect(visX - padding, visY - padding, rectWidth, visHeight + padding*2);
  fill(250);
  rect(visX, visY, rectWidth - padding*2, visHeight);

  String[] fileNames = splitTokens(fileArray[i]);
  
  if(fileNames[0].charAt(0) != '.'){
    String[] fileDate = split(fileNames[0], '.');
    
    fill(70);
    textAlign(LEFT, CENTER);
    text("Session" + fileDate[2] + "." + fileDate[1] + "." + fileDate[0], visX, visY - padding*2);
    
    //float attAvg = map(attentionAverageList[i], 100, 0, visY, visHeight + visY);
    //float rlxAvg = map(relaxationAverageList[i], 100, 0, visY, visHeight + visY);
    
    float rlxAvg = map(relaxationAverageList[i], 0, 100, 0, rectWidth/2);
    float attAvg = map(attentionAverageList[i], 0, 100, 0, rectWidth/2);
    
    textAlign(CENTER, CENTER);
  
    fill(150);
    rect(visX, visY, rlxAvg, visHeight/2);
    fill(0);
    text("Relaxation "+round(relaxationAverageList[i])+"%", visX, visY, visWidth/2, visHeight/2);
    
    fill(70);
    rect(visX, visY + visHeight/2, attAvg, visHeight/2);
    fill(0);
    text("Attention "+round(attentionAverageList[i])+"%", visX, visY + visHeight/2, visWidth/2, visHeight/2);
    
    fill(70);
    textAlign(LEFT, CENTER);
    text("Values based on your EEG data", visX, visY + visHeight + padding*2);
  }

}