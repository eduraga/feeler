public void avgGraph(){
  fill(240);
  rect(visX, visY, visWidth - dotSize/2, visHeight + dotSize/2);
  
  fill(0);
  
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
        
        if(mousePressed){
          println("clicou");
          println(i + fileArray.length - listSize, cp5.get(ScrollableList.class, "loadFilesList").getItem(i + fileArray.length - listSize));
        }

        
        fill(250);
        rect(thisX - dotSize/2, visY, dotSize, visHeight + dotSize/2);
        
        fill(100);
        if(mouseY >= thisRlxY - dotSize/2 && mouseY <= thisRlxY + dotSize/2){
          //rect(thisX - dotSize/2, rlxAvg - dotSize/2, dotSize, dotSize); // bounding box
          text(round(relaxationAverageList[i]), thisX + 10, rlxAvg - dotSize);
        }
        if(mouseY >= thisAttY - dotSize/2 && mouseY <= thisAttY + dotSize/2){
          //rect(thisX - dotSize/2, attAvg - dotSize/2, dotSize, dotSize); // bounding box
          text(round(attentionAverageList[i]), thisX + 10, attAvg - dotSize);
        }
        noStroke();
      }
      
      fill(150);
      ellipse(thisX, attAvg, dotSize, dotSize);
      
      fill(70);
      ellipse(thisX, rlxAvg, dotSize, dotSize);
      
      textAlign(CENTER, CENTER);
      text(fileDate[2] + "." + fileDate[1], thisX, visHeight + visY + 40);
    }
  }
}