public void avgGraph(){
  fill(graphBgColor);
  rect(visX - padding, visY - padding, visWidth - dotSize/2 + padding*2, visHeight + dotSize/2 + padding*2);
  
  textAlign(LEFT, CENTER);
  fill(textDarkColor);
  text("100%", visX - padding/2, visY);
  text("50%", visX - padding/2, visY + visHeight/2 + dotSize/2);
  text("0%", visX - padding/2, visY + visHeight + dotSize/2);
  
  for(int i = 0; i < listSize; i++){
    String[] fileNames = splitTokens(fileArray[i]);
    
    if(fileNames[0].charAt(0) != '.'){
      textAlign(LEFT, CENTER);
      
      String[] fileDate = split(fileNames[0], '.');
      
      float attAvg = map(attentionAverageList[i], 100, 0, visY, visHeight + visY);
      float rlxAvg = map(relaxationAverageList[i], 100, 0, visY, visHeight + visY);
      
      float thisX = i * visWidth/listSize + visX;
      float thisRlxY = rlxAvg;
      float thisAttY = attAvg;
      
      if(mouseX >= thisX - dotSize/2 && mouseX <= thisX + dotSize/2){
        
        if(mouseY >= visY && mouseY <= visY + visHeight + dotSize/2){
          if(mousePressed){
            println("clicou");
            println(i + fileArray.length - listSize, cp5.get(ScrollableList.class, "loadFilesList").getItem(i + fileArray.length - listSize));
            currentPage = "singleSession";
            cp5.getTab("singleSession").bringToFront();
            currentSession = fileArray[i];
            currentItem = i;
            println(currentSession);
          }
          
          fill(250);
          rect(thisX - dotSize/2, visY, dotSize, visHeight + dotSize/2);
        }
        
        if(mouseY >= thisRlxY - dotSize/2 && mouseY <= thisRlxY + dotSize/2){
          fill(textDarkColor);
          //rect(thisX - dotSize/2, rlxAvg - dotSize/2, dotSize, dotSize); // boundin box
          text(round(relaxationAverageList[i])+"%", thisX + 10, rlxAvg - dotSize);
        }
        if(mouseY >= thisAttY - dotSize/2 && mouseY <= thisAttY + dotSize/2){
          fill(textDarkColor);
          //rect(thisX - dotSize/2, attAvg - dotSize/2, dotSize, dotSize); // boun box
          text(round(attentionAverageList[i])+"%", thisX + 10, attAvg - dotSize);
        }
        noStroke();
      }
      
      fill(150);
      ellipse(thisX, attAvg, dotSize, dotSize);
      
      fill(70);
      ellipse(thisX, rlxAvg, dotSize, dotSize);
      
      fill(textDarkColor);
      textAlign(CENTER, CENTER);
      text(fileDate[2] + "." + fileDate[1], thisX, visHeight + visY + 40);
    }
  }
  
  fill(textDarkColor);
  textAlign(LEFT);
  text("Averaged values of EEG data", visX, visHeight + visY + 60);
}