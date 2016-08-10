class LineChart {
  String type;
  int _listSize;
  int grainSize;
  int maxVal = 100;
  float stepSize;
  //int visX;
  
  float relaxEnd = 0;
  float studyEnd = 0;
  float playEnd = 0;

  FloatList thisX = new FloatList();
  FloatList previousX = new FloatList();
  FloatList thisAtt = new FloatList();
  FloatList previousAtt = new FloatList();
  FloatList thisRelax = new FloatList();
  FloatList previousRelax = new FloatList();
  StringList screenshots = new StringList();
  
  int currentImg;

  LineChart(){
  }
  
  void setup(String _type){
    type = _type;
    
    if(sessionFolders != null){
      if(type == "averages"){
        //visX = visY;
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
        //visX = visY + headerHeight + padding*2;
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
                     playEnd = thisX.get(j);
                   }
                   
                   if(data.data[j-grainSize][10] > 0) {
                     previousAtt.set(j, map(data.data[j-grainSize][10], 0, maxVal, lowerBoundary, upperBoundary));
                   } else {
                     previousAtt.set(j,lowerBoundary);
                   }
                   
                   if(data.data[j][10] > 0) {
                     thisAtt.set(j, map(data.data[j][10], 0, maxVal, lowerBoundary, upperBoundary));
                   } else {
                     thisAtt.set(j,lowerBoundary);
                   }
                   
                   if(data.data[j-grainSize][11] > 0) {
                     previousRelax.set(j, map(data.data[j-grainSize][11], 0, maxVal, lowerBoundary, upperBoundary));
                   } else {
                     previousRelax.set(j,lowerBoundary);
                   }
                   
                   if(data.data[j][11] > 0) {
                     thisRelax.set(j, map(data.data[j][11], 0, maxVal, lowerBoundary, upperBoundary));
                   } else {
                     thisRelax.set(j,lowerBoundary);
                   }
                   
                   //previousAtt.set(j,upperBoundary);
                   //thisAtt.set(j,upperBoundary);
                   //previousRelax.set(j,lowerBoundary);
                   //thisRelax.set(j,map(-60, 0, maxVal, lowerBoundary, upperBoundary));
                   
                   //previousAtt.set(j, map(100, maxVal, 0, lowerBoundary, upperBoundary));
                   //thisAtt.set(j, map(100, maxVal, 0, lowerBoundary, upperBoundary));
                   //previousRelax.set(j, map(100, maxVal, 0, lowerBoundary, upperBoundary));
                   //thisRelax.set(j, map(100, maxVal, 0, lowerBoundary, upperBoundary));
                   
                   
                   
                   
                   
                   /////////////////////////////// Image stuff
                   //////////////////////////////////////////////
                   
                   screenshots.set(j, "");
                   
                   File imgTempFolder = new File(userFolder + "/" + sessionFolders[currentItem] + "/screenshots");
                   screenshotsArray = imgTempFolder.list();
                   for(int k = 0; k < screenshotsArray.length; k++){
                     String screenshot = screenshotsArray[k]; 
                     String[] screenshotTimeId = splitTokens(screenshot, "-");
                     if(int(screenshotTimeId[0]) == int(data.data[j][0])){
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
      //visX = visY;
      _listSize = 1;
      stepSize = 1;      
    }
  }
  
  void display(){    
    fill(graphBgColor);
    rect(visX - padding, visX - padding, visWidth - dotSize/2 + padding*2, visHeight + dotSize/2 + padding*2);
    
    if(fileName != null && sessionFolders != null){
      displayData();
    } else {
        fill(textDarkColor);
        pushStyle();
        textAlign(CENTER);
        text("Eager to see some data?\nStart a New session", visX, visHeight/2 + visX, visWidth, visHeight);
        popStyle();
    }
    
    //Labels
    pushStyle();
    textAlign(LEFT, CENTER);
    fill(textDarkColor);
    text("100%", visX - padding/2, visX);
    text("50%", visX - padding/2, visX + visHeight/2 + dotSize/2);
    text("0%", visX - padding/2, visX + visHeight + dotSize/2);
    popStyle();
  }
  
  void displayData(){
      fill(textDarkColor);
      if(type == "averages"){
        pushStyle();
        textAlign(LEFT);
        text("Averaged values of the EEG data and your personal experience", visX - padding, visHeight + visX + padding * 5);
        popStyle();
      } else if(type == "values"){
        stroke(100,100);
        line(relaxEnd, visY + padding*3, relaxEnd, visY + padding*3 + visHeight);
        line(studyEnd, visY + padding*3, studyEnd, visY + padding*3 + visHeight);
        
        pushStyle();
        fill(textDarkColor);
        textAlign(CENTER, CENTER);
        text("Meditate", visX + padding, visY + padding*3, relaxEnd - (visX + padding), 20);
        text("Study", relaxEnd, visY + padding*3, studyEnd - relaxEnd, 20);
        //text("Play", studyEnd, visY + padding*3, playEnd - studyEnd, 20);
        popStyle();
      } else if(type == "personal"){
        pushStyle();
        textAlign(CENTER);
        fill(textDarkColor);
        text("Meditate", visX + padding, visY + padding*3, relaxEnd - (visX + padding), 20);
        text("Study", relaxEnd, visY + padding*3, studyEnd - relaxEnd, 20);
        //text("Play", studyEnd, visY + padding*3, playEnd - studyEnd, 20);
        popStyle();
      }
      
      
      fill(textDarkColor);
      if(fileName[0].charAt(0) != '.'){
        String[] fileDate = split(fileName[0], '-');
        
        float rlxAvg = 0;
        float attAvg = 0;
        
        if(type == "eeg"){
          pushStyle();
          fill(textDarkColor);
          textAlign(LEFT, CENTER);
          text(fileDate[2] + "." + fileDate[1] + "." + fileDate[0] + ", " + fileDate[3] + ":" + fileDate[4] + ":" + fileDate[5], visX + padding, visX - padding);
          popStyle();
          
          rlxAvg = relaxationAverageList[currentItem];
          attAvg = attentionAverageList[currentItem];
        }
      }

      if(type == "averages"){
        
        text("Your activity", visX, visX - padding*2);
        
        for(int i = 0; i < _listSize; i+=grainSize){
          float thisX = i * stepSize + visX + stepSize/2;
          float previousX = (i-1) * stepSize + visX + stepSize/2;

          if(sessionFolders[i].charAt(0) == '2'){
            pushStyle();
            textAlign(LEFT, CENTER);
            String[] fileDate = split(sessionFolders[i], '-');
            
            float attAvg = 0;
            float rlxAvg = 0;
            
            float prevAttAvg = 0;
            float prevRlxAvg = 0;
            
            attAvg = map(attentionAverageList[i], 100, 0, visX, visHeight + visX);
            rlxAvg = map(relaxationAverageList[i], 100, 0, visX, visHeight + visX);
            
            if(i>0){
              prevAttAvg = map(attentionAverageList[i-1], 100, 0, visX, visHeight + visX);
              prevRlxAvg = map(relaxationAverageList[i-1], 100, 0, visX, visHeight + visX);
            }
            
            if(mouseX >= thisX - dotSize/2 && mouseX <= thisX + dotSize/2){
              if(type == "averages"){
                hoverUpLeft.set(thisX - dotSize/2, visX);
                hoverDownRight.set(thisX + dotSize/2, visX + visHeight + dotSize/2);
                
                if(mouseY >= visX && mouseY <= visX + visHeight + dotSize/2){
                  fill(250);
                  rect(thisX - dotSize/2, visX, dotSize, visHeight + dotSize/2);
                  
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
              }
              noStroke();
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
            text(fileDate[2] + "." + fileDate[1], thisX, visHeight + visX + padding*2);
            text(fileDate[3] + ":" + fileDate[4], thisX, visHeight + visX + padding*3);
            popStyle();
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
          
          thisMeditate = map(float(assessmentData[i+3]), maxVal, 0, visX, visHeight + visX);
          thisStudy = map(float(assessmentData[i+6]), maxVal, 0, visX, visHeight + visX);
          
          if(i > 0){
            prevMeditate = map(float(assessmentData[i-1+3]), maxVal, 0, visX, visHeight + visX);
            prevStudy = map(float(assessmentData[i-1+6]), maxVal, 0, visX, visHeight + visX);

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
            if(mouseY >= visX + dotSize && mouseY <= visX + dotSize + visHeight){
              fill(250);
              rect(thisX - dotSize/2, visX + dotSize, dotSize, visHeight);
              
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
            playEnd = thisX + offset;
          }
        }
        

        String[] fileDate = split(fileName[0], '-');
        pushStyle();
        fill(textDarkColor);
        textAlign(LEFT);
        text("Your activity > " + fileDate[2] + "." + fileDate[1] + "." + fileDate[0] + ", " + fileDate[3] + ":" + fileDate[4] + ":" + fileDate[5] + " > Personal impressions", visX, visX - padding*2);
        popStyle();
        
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
    
        pushStyle();
        String[] fileDate = split(fileName[0], '-');
        fill(textDarkColor);
        textAlign(LEFT);
        text("Your activity > " + fileDate[2] + "." + fileDate[1] + "." + fileDate[0] + ", " + fileDate[3] + ":" + fileDate[4] + ":" + fileDate[5] + " > EEG data", visX, visX - padding*2);
        popStyle();
      }
  }
  
  void displayThumbs(int i){
    if(screenshots.get(i) != "" && screenshots.get(i) != null){
      if(
        mouseX > previousX.get(i)
        &&
        mouseX < thisX.get(i)
        &&
        mouseY > visX
        &&
        mouseY < visHeight + visX
      ){
        PImage screenshotImg = loadImage(screenshots.get(i));
        //imageMode(CENTER);
        currentImg = i;
        
        fill(255);
        stroke(textLightColor);
        rect(thisX.get(i) - screenshotImg.height/6 - padding, mouseY - padding, screenshotImg.width/4 + padding*2, screenshotImg.height/4 + padding*5);
        noStroke();
        image(screenshotImg, thisX.get(i) - screenshotImg.height/6, mouseY + padding*3, screenshotImg.width/4, screenshotImg.height/4);
        pushStyle();
        textAlign(LEFT);
        fill(attentionColor);
        text("Attention " + thisAtt.get(i), thisX.get(i) - screenshotImg.height/6, mouseY+padding);
        fill(relaxationColor);
        text("Relaxtation " + thisRelax.get(i), thisX.get(i) - screenshotImg.height/6, mouseY+padding*2);
        popStyle();
        
  
      } else {
      }
    }
  }
  
  void displayGeneral(int i){

    if(screenshots.get(i) != "" && screenshots.get(i) != null){
      fill(255, 100);
      rect(previousX.get(i), visX + padding, thisX.get(i) - previousX.get(i) - 1, visHeight);
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
                if(mouseY >= visX && mouseY <= visX + visHeight + dotSize/2){
                  currentPage = "singleSession";
                  cp5.getTab("singleSession").bringToFront();
                  currentSession = sessionFolders[i];
                  cp5.getController("overall").show();
                  cp5.getController("session").setLabel(sessionFolders[i]);
                  currentItem = i;
                }
              }
            }
            
            if(type == "values" && i == currentImg && mouseY >= visX && currentPage == "eegActivity"){
              modal = true;
              openModal(screenshots.get(currentImg));
            }
            
          }
        }
      }
    }
  }
}