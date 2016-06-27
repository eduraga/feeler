class LineChart {
  String type;
  int _listSize;
  int grainSize = 40;
  int maxVal = 100;
  float stepSize;
  int _visY;

  LineChart(){
  }
  
  void setup(String _type){
    
    type = _type;
    _visY = visY;
    
    if(sessionFolders != null){
      if(type == "averages"){
        //_visY = visY;
        if(sessionFolders.length < 10){
         _listSize = listSize;
        } else {
         _listSize = sessionFolders.length;
        }
      } else if (type == "personal") {
        //_visY = visY + visHeight/2;
        _listSize = 3;
      } else {
        _visY = visY + headerHeight + padding*2;
        _listSize = sessionFolders.length;
      }
      stepSize = visWidth/_listSize;
    } else {
      //_visY = visY;
      _listSize = 1;
      stepSize = 1;
    }
    
  }
  
  void display(){
    
    float relaxEnd = 0;
    float studyEnd = 0;
    float assessEnd = 0;
    
    String currentScreenshot = "";
    
    fill(graphBgColor);
    rect(visX - padding, _visY - padding, visWidth - dotSize/2 + padding*2, visHeight + dotSize/2 + padding*2);
    
    if(fileName != null && sessionFolders != null){
      for(int i = 0; i < _listSize; i++){
        if(sessionFolders[i].charAt(0) == '2'){
          textAlign(LEFT, CENTER);
          String[] fileDate = split(sessionFolders[i], '-');
          
          float thisX = i * stepSize + visX + stepSize/2;
          float previousX = (i-1) * stepSize + visX + stepSize/2;
          
          float attAvg = map(attentionAverageList[i], 100, 0, _visY, visHeight + _visY);
          float rlxAvg = map(relaxationAverageList[i], 100, 0, _visY, visHeight + _visY);
          float prevAttAvg = 0;
          float prevRlxAvg = 0;
          
          if(i>0){
            prevAttAvg = map(attentionAverageList[i-1], 100, 0, _visY, visHeight + _visY);
            prevRlxAvg = map(relaxationAverageList[i-1], 100, 0, _visY, visHeight + _visY);
          }
          
          if(mouseX >= thisX - dotSize/2 && mouseX <= thisX + dotSize/2){
            if(type == "averages"){
              hoverUpLeft.set(thisX - dotSize/2, _visY);
              hoverDownRight.set(thisX + dotSize/2, _visY + visHeight + dotSize/2);
              
              if(mouseY >= _visY && mouseY <= _visY + visHeight + dotSize/2){
                fill(250);
                rect(thisX - dotSize/2, _visY, dotSize, visHeight + dotSize/2);
              }
            }
            noStroke();
          }
          
          if(type == "averages"){
            
            if(attentionAverageList[i] > 0){
              fill(attentionColor);
              ellipse(thisX, attAvg, dotSize, dotSize);
            }
            
            if(relaxationAverageList[i] > 0){
              fill(relaxationColor);
              ellipse(thisX, rlxAvg, dotSize, dotSize);
            }
            
            
            fill(textDarkColor);
            textAlign(CENTER, CENTER);
            text(fileDate[2] + "." + fileDate[1], thisX, visHeight + _visY + padding*2);
            text(fileDate[3] + ":" + fileDate[4], thisX, visHeight + _visY + padding*3);
          } else if(type == "personal"){
            
              pushStyle();
              textAlign(CENTER);
              fill(textDarkColor);
              if(i == 0){
                text("Meditate", thisX, _visY);
              }
              if(i == 1){
                text("Study", thisX, _visY);
              }
              if(i == 2){
                text("Play", thisX, _visY);
              }
              popStyle();
            
              float prevMeditate = map(float(assessmentData[i-1+3]), maxVal, 0, _visY, visHeight + _visY);
              float thisMeditate = map(float(assessmentData[i+3]), maxVal, 0, _visY, visHeight + _visY);
              
              float prevStudy = map(float(assessmentData[i-1+6]), maxVal, 0, _visY, visHeight + _visY);
              float thisStudy = map(float(assessmentData[i+6]), maxVal, 0, _visY, visHeight + _visY);
              
              stroke(relaxationColor);
              line(
                    previousX,
                    prevMeditate,
                    thisX,
                    thisMeditate
              );
              
              if(i > 0){
                stroke(attentionColor);
                line(
                    previousX,
                    prevStudy,
                    thisX,
                    thisStudy
                );
              }
              
              noStroke();
              
              fill(relaxationColor);
              ellipse(thisX, thisMeditate, dotSize, dotSize);
              
              fill(attentionColor);
              ellipse(thisX, thisStudy, dotSize, dotSize);
            
            
          } else {
            noFill();
            if(i>=0 && data.data != null){
              for (int j = 0; j < data.data.length; j+=grainSize) {
                if (data.data[j][12] > 0 && j>0) {
  
                  thisX = j * (visWidth - padding*2)/data.data.length + visX + padding;
                  previousX = (j-grainSize) * (visWidth - padding*2)/data.data.length + visX + padding;
                  
                  if(data.data[j][12] == 1){
                    fill(250);
                    relaxEnd = thisX;
                  }
                  if(data.data[j][12] == 2){
                   fill(230);
                   studyEnd = thisX;
                  }
                  if(data.data[j][12] == 3){
                    fill(210);
                    assessEnd = thisX;
                  }
                  noStroke();
                  //rect(previousX, _visY, grainSize, visHeight);
  
                  stroke(attentionColor);
                  line(
                        previousX,
                        map(data.data[j-grainSize][10], maxVal, 0, _visY, visHeight + _visY),
                        thisX,
                        map(data.data[j][10], maxVal, 0, _visY, visHeight + _visY)
                  );
                  stroke(relaxationColor);
                  line(
                        previousX,
                        map(data.data[j-grainSize][11], maxVal, 0, _visY, visHeight + _visY),
                        thisX,
                        map(data.data[j][11], maxVal, 0, _visY, visHeight + _visY)
                  );
                  

                  
                  fill(255, 100);
                  noStroke();
                  rect(previousX, _visY, grainSize/2, visHeight + dotSize/2);

                  File imgTempFolder = new File(userFolder + "/" + sessionFolders[currentItem] + "/screenshots");
                  screenshotsArray = imgTempFolder.list();
                  for(int k = 0; k < screenshotsArray.length; k++){
                    String screenshot = screenshotsArray[k]; 
                    String[] screenshotTimeId = splitTokens(screenshot, "-");
                    if(int(screenshotTimeId[0]) == int(data.data[j][0])){
                      if(
                        mouseX > previousX
                        &&
                        mouseX < thisX
                        &&
                        mouseY > _visY
                        &&
                        mouseY < visHeight + _visY
                      ){
                        currentScreenshot = imgTempFolder + "/" +screenshot;
                      }
                      
                      pushStyle();
                      fill(190);
                      rect(previousX, visHeight + _visY + padding/2, thisX - previousX, padding);
                      popStyle();
                    }
                  }
                  
                  
                }
              }

              if(currentScreenshot != ""){
                PImage screenshotImg = loadImage(currentScreenshot);
                image(screenshotImg, mouseX - (screenshotImg.width/4)/2, mouseY, screenshotImg.width/4, screenshotImg.height/4);
              }
              


            }
            
            noStroke();
          }
        }
      }
      
     
      pushStyle();
      textAlign(LEFT);
      for(int i = 0; i < _listSize; i++){
        if(sessionFolders[i].charAt(0) == '2'){
          
          float thisX = i * stepSize + visX + stepSize/2;
          
          if(mouseX >= thisX - dotSize/2 && mouseX <= thisX + dotSize/2 && mouseY >= _visY && mouseY <= _visY + visHeight + dotSize/2){
            if(type == "personal"){
  
              fill(255);
              stroke(textDarkColor);
              rect(mouseX, mouseY - 70, 120, 70);
              noStroke();
              
              fill(textDarkColor);
              
              text("Meditation: " + round(float(assessmentData[i+3]))+"%", mouseX + padding/2, mouseY - 70 + padding);
              text("Attention: " + round(float(assessmentData[i+6]))+"%", mouseX + padding/2, mouseY - 70 + padding*2);
              text("Feeling: " + assessmentData[i], mouseX + padding/2, mouseY - 70 + padding*3);
            } else {
                
              fill(255);
              stroke(textDarkColor);
              rect(mouseX, mouseY - 50, 120, 50);
              noStroke();
              
              fill(textDarkColor);
              text("Meditation: " + round(relaxationAverageList[i])+"%", mouseX + padding/2, mouseY - 50 + padding);
              text("Attention: " + round(attentionAverageList[i])+"%", mouseX + padding/2, mouseY - 50 + padding*2);
            }
            
          }
        }
      }
      popStyle();
      
      fill(textDarkColor);
      if(type == "averages"){
        textAlign(LEFT);
        text("Averaged values of the EEG data and your personal experience", visX - padding, visHeight + _visY + padding * 5);
      } else if(type == "values"){
        textAlign(CENTER, CENTER);
        text("RELAX", visX + padding, _visY, relaxEnd - (visX + padding), 20);
        text("STUDY", relaxEnd, _visY, studyEnd - relaxEnd, 20);
        text("ASSESS", studyEnd, _visY, assessEnd - studyEnd, 20);
      }
    } else {
        fill(textDarkColor);
        textAlign(CENTER);
        text("Eager to see some data?\nStart a New session", visX, visHeight/2 + _visY, visWidth, visHeight);
    }
    
    //Labels
    textAlign(LEFT, CENTER);
    text("100%", visX - padding/2, _visY);
    text("50%", visX - padding/2, _visY + visHeight/2 + dotSize/2);
    text("0%", visX - padding/2, _visY + visHeight + dotSize/2);
  }
  
  void onClick(){
    hoverUpLeft.set(0,0);
    hoverDownRight.set(0,0);
    
    if(sessionFolders != null){
      println(mouseX + " " + (visX - padding));
      println(mouseY + " " + (visY - padding) + " " + ((_visY - padding) + visHeight));
      
      if(sessionFolders.length == 0){
      } else {
        String lines[] = loadStrings(userFolder + "/" + sessionFolders[currentItem] + "/assessment.txt");
        assessmentData = lines;
      }
      
      if(fileName != null){
        for(int i = 0; i < _listSize; i++){
          if(fileName[0].charAt(0) != '.'){
            float thisX = i * stepSize + visX + stepSize/2;
            if(mouseX >= thisX - dotSize/2 && mouseX <= thisX + dotSize/2){
              if(type == "averages"){
                if(mouseY >= _visY && mouseY <= _visY + visHeight + dotSize/2){
                  currentPage = "singleSession";
                  cp5.getTab("singleSession").bringToFront();
                  currentSession = sessionFolders[i];
                  currentItem = i;
                }
              }
            }
          }
        }
      }
    }
  }
}