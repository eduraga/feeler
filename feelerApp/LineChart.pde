class LineChart {
  String type;

  LineChart(String _type){
    type = _type;
  }
  
  void display(){
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
        
        float thisX = i * visWidth/listSize + visX;
        float previousX = (i-1) * visWidth/listSize + visX;
        
        float attAvg = map(attentionAverageList[i], 100, 0, visY, visHeight + visY);
        float rlxAvg = map(relaxationAverageList[i], 100, 0, visY, visHeight + visY);
        
        float prevAttAvg = map(attentionAverageList[i-1], 100, 0, visY, visHeight + visY);
        float prevRlxAvg = map(relaxationAverageList[i-1], 100, 0, visY, visHeight + visY);
        
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
          
          if(mouseY >= rlxAvg - dotSize/2 && mouseY <= rlxAvg + dotSize/2){
            fill(textDarkColor);
            //rect(thisX - dotSize/2, rlxAvg - dotSize/2, dotSize, dotSize); // boundin box
            text(round(relaxationAverageList[i])+"%", thisX + 10, rlxAvg - dotSize);
          }
          if(mouseY >= attAvg - dotSize/2 && mouseY <= attAvg + dotSize/2){
            fill(textDarkColor);
            //rect(thisX - dotSize/2, attAvg - dotSize/2, dotSize, dotSize); // bouning box
            text(round(attentionAverageList[i])+"%", thisX + 10, attAvg - dotSize);
          }
          noStroke();
        }
        
        if(type == "averages"){
          fill(attentionColor);
          ellipse(thisX, attAvg, dotSize, dotSize);
          
          fill(relaxationColor);
          ellipse(thisX, rlxAvg, dotSize, dotSize);
          
          fill(textDarkColor);
          textAlign(CENTER, CENTER);
          text(fileDate[2] + "." + fileDate[1], thisX, visHeight + visY + 40);
        } else {
          noFill();
          if(i>0){
            stroke(attentionColor);
            line(previousX, prevAttAvg, thisX, attAvg);
            stroke(relaxationColor);
            line(previousX, prevRlxAvg, thisX, rlxAvg);
          }
          noStroke();
        }

      }
    }
    
    fill(textDarkColor);
    textAlign(LEFT);
    text("Averaged values of EEG data", visX, visHeight + visY + 60);
  }
}