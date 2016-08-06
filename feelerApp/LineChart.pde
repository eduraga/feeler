class LineChart {
  String type;
  int _listSize;
  int grainSize;
  int maxVal = 100;
  float stepSize;
  int _visY;
  
  float relaxEnd = 0;
  float studyEnd = 0;
  float assessEnd = 0;

  FloatList thisX = new FloatList();
  FloatList previousX = new FloatList();
  FloatList thisAtt = new FloatList();
  FloatList previousAtt = new FloatList();
  FloatList thisRelax = new FloatList();
  FloatList previousRelax = new FloatList();
  StringList screenshots = new StringList();

  LineChart(){
  }
  
  void setup(String _type){
    type = _type;
    _visY = visY;
    
    if(sessionFolders != null){
      if(type == "averages"){
        //_visY = visY;
        grainSize = 1;
        if(sessionFolders.length < 10){
         _listSize = listSize;
        } else {
         _listSize = sessionFolders.length;
        }
      } else if (type == "personal") {
        grainSize = 1;
        _listSize = 3;
      } else if (type == "values") {
        grainSize = 40;
        //_visY = visY + headerHeight + padding*2;
        //_listSize = sessionFolders.length;
    
        //for(int i = 0; i < _listSize; i++){
         //if(sessionFolders[i].charAt(0) == '2'){
             if(data.data != null){
               _listSize = data.data.length;
               
               for (int j = 0; j < _listSize; j+=grainSize) {
                 
                 if (data.data[j][12] > 0 && j > grainSize) {
                   
                   thisX.set(j, j * (visWidth - padding*2)/data.data.length + visX + padding);
                   previousX.set(j, (j-grainSize) * (visWidth - padding*2)/data.data.length + visX + padding);
                   
                   if(data.data[j][12] == 1){
                     fill(250);
                     relaxEnd = thisX.get(j);
                   }
                   if(data.data[j][12] == 2){
                    fill(230);
                    studyEnd = thisX.get(j);
                   }
                   if(data.data[j][12] == 3){
                     fill(210);
                     assessEnd = thisX.get(j);
                   }
                   
                   previousAtt.set(j, map(data.data[j-grainSize][10], maxVal, 0, _visY, visHeight + _visY));
                   thisAtt.set(j, map(data.data[j][10], maxVal, 0, _visY, visHeight + _visY));
                   previousRelax.set(j, map(data.data[j-grainSize][11], maxVal, 0, _visY, visHeight + _visY));
                   thisRelax.set(j, map(data.data[j][11], maxVal, 0, _visY, visHeight + _visY));
                   
                   /////////////////////////////// Image stuff
                   //////////////////////////////////////////////
                   
                   screenshots.set(j, "");
                   
                   File imgTempFolder = new File(userFolder + "/" + sessionFolders[currentItem] + "/screenshots");
                   screenshotsArray = imgTempFolder.list();
                   for(int k = 0; k < screenshotsArray.length; k++){
                     String screenshot = screenshotsArray[k]; 
                     String[] screenshotTimeId = splitTokens(screenshot, "-");
                     
                     if(int(screenshotTimeId[0]) == int(data.data[j][0])){
                       println("j:" + j + ", k: " + k + ", data: " + int(data.data[j][0]) + ", time: " + screenshotTimeId[0]);
                       screenshots.set(j, imgTempFolder + "/" +screenshotsArray[k]);
                     }
                   }
                   
                 }
               }
             }
          //}
        
        //}
        
        

      }
      stepSize = visWidth/_listSize;
    } else {
      //_visY = visY;
      _listSize = 1;
      stepSize = 1;      
    }
    
    

    
  }
  
  void display(){    
    fill(graphBgColor);
    rect(visX - padding, _visY - padding, visWidth - dotSize/2 + padding*2, visHeight + dotSize/2 + padding*2);
    
    if(fileName != null && sessionFolders != null){
      displayData();
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
  
  void displayData(){
      fill(textDarkColor);
      if(type == "averages"){
        textAlign(LEFT);
        text("Averaged values of the EEG data and your personal experience", visX - padding, visHeight + _visY + padding * 5);
      } else if(type == "values"){
        textAlign(CENTER, CENTER);
        
        stroke(100,100);
        line(relaxEnd, _visY, relaxEnd, _visY + visHeight);
        line(studyEnd, _visY, studyEnd, _visY + visHeight);
        
        pushStyle();
        fill(textDarkColor);
        textAlign(CENTER);
        text("Meditate", visX + padding, _visY, relaxEnd - (visX + padding), 20);
        text("Study", relaxEnd, _visY, studyEnd - relaxEnd, 20);
        text("Play", studyEnd, _visY, assessEnd - studyEnd, 20);
        popStyle();
      } else if(type == "personal"){
        pushStyle();
        textAlign(CENTER);
        fill(textDarkColor);
        text("Meditate", visX + padding, _visY, relaxEnd - (visX + padding), 20);
        text("Study", relaxEnd, _visY, studyEnd - relaxEnd, 20);
        text("Play", studyEnd, _visY, assessEnd - studyEnd, 20);
        popStyle();
      }

      if(type == "averages"){
        for(int i = 0; i < _listSize; i+=grainSize){
          float thisX = i * stepSize + visX + stepSize/2;
          float previousX = (i-1) * stepSize + visX + stepSize/2;

          if(sessionFolders[i].charAt(0) == '2'){
            textAlign(LEFT, CENTER);
            String[] fileDate = split(sessionFolders[i], '-');
            
            float attAvg = 0;
            float rlxAvg = 0;
            
            float prevAttAvg = 0;
            float prevRlxAvg = 0;
            
            attAvg = map(attentionAverageList[i], 100, 0, _visY, visHeight + _visY);
            rlxAvg = map(relaxationAverageList[i], 100, 0, _visY, visHeight + _visY);
            
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
              
              pushStyle();
              fill(255);
              stroke(textLightColor);
              rect(mouseX, mouseY, 120, 60);
              
              fill(attentionColor);
              text("Attention: " + round(attentionAverageList[i]), mouseX + padding, mouseY + padding);
              fill(relaxationColor);
              text("Relaxation: " + round(relaxationAverageList[i]), mouseX + padding, mouseY + padding * 2);
              popStyle();
            }
            
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
            
          }
            
        }
        
      } else if(type == "personal"){
        for(int i = 0; i < _listSize; i+=grainSize){
          float thisX = i * stepSize + visX + stepSize/2;
          float previousX = (i-1) * stepSize + visX + stepSize/2;
          float prevMeditate = 0;
          float thisMeditate = 0;
          float prevStudy = 0;
          float thisStudy = 0;
          
          thisMeditate = map(float(assessmentData[i+3]), maxVal, 0, _visY, visHeight + _visY);
          thisStudy = map(float(assessmentData[i+6]), maxVal, 0, _visY, visHeight + _visY);
          
          if(i > 0){
            prevMeditate = map(float(assessmentData[i-1+3]), maxVal, 0, _visY, visHeight + _visY);
            prevStudy = map(float(assessmentData[i-1+6]), maxVal, 0, _visY, visHeight + _visY);

            stroke(relaxationColor);
            line(
                  previousX,
                  prevMeditate,
                  thisX,
                  thisMeditate
            );
            stroke(attentionColor);
            line(
                previousX,
                prevStudy,
                thisX,
                thisStudy
            );
          }
          noStroke();
          
          if(mouseX >= thisX - dotSize/2 && mouseX <= thisX + dotSize/2){

            fill(250);
            rect(thisX - dotSize/2, _visY + dotSize, dotSize, visHeight);
            
            pushStyle();
            fill(255);
            stroke(textLightColor);
            rect(mouseX, mouseY, 120, 60);
            fill(attentionColor);
            text("Attention: " + assessmentData[i+3], mouseX + padding, mouseY + padding);
            fill(relaxationColor);
            text("Relaxation: " + assessmentData[i+6], mouseX + padding, mouseY + padding * 2);
            popStyle();
          }
          
          fill(relaxationColor);
          ellipse(thisX, thisMeditate, dotSize, dotSize);
          
          fill(attentionColor);
          ellipse(thisX, thisStudy, dotSize, dotSize);
          
          float offset = (thisX - previousX)/2;

          if(i == 0){
            relaxEnd = thisX + offset;            
          }
          if(i == 1){
            studyEnd = thisX + offset;
          }
          if(i == 2){
            assessEnd = thisX + offset;
          }
        }
      } else {
        for(int i = 0; i < _listSize; i+=grainSize){
          if(i >= grainSize){
            displayGeneral(i);
          }
        }
        
        for(int i = 0; i < _listSize; i+=grainSize){
          if(i >= grainSize){
            displayThumbs(i);
          }
        }
      }
  }
  
  
  void displayThumbs(int i){
    if(screenshots.get(i) != "" && screenshots.get(i) != null){
      if(
        mouseX > previousX.get(i)
        &&
        mouseX < thisX.get(i)
        &&
        mouseY > _visY
        &&
        mouseY < visHeight + _visY
      ){
        PImage screenshotImg = loadImage(screenshots.get(i));
        imageMode(CENTER); 
        image(screenshotImg, thisX.get(i), mouseY + screenshotImg.height/8 + padding, screenshotImg.width/4, screenshotImg.height/4);
        imageMode(CORNER);
      }
    }
  }
  
  void displayGeneral(int i){

    if(screenshots.get(i) != "" && screenshots.get(i) != null){
      fill(255, 100);
      rect(previousX.get(i), _visY + padding, thisX.get(i) - previousX.get(i) - 1, visHeight);
    }
    
    String currentScreenshot = "";
    noFill();
    
    stroke(attentionColor);
    line(
         previousX.get(i),
         previousAtt.get(i),
         thisX.get(i),
         thisAtt.get(i)
    );
    stroke(relaxationColor);
    line(
         previousX.get(i),
         previousRelax.get(i),
         thisX.get(i),
         thisRelax.get(i)
    );
    noStroke();
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