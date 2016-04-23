class LineChart {
  String type;
  int _listSize;
  int grainSize = 40;

  LineChart(){
  }
  
  void setup(String _type){
    
    type = _type;
    if(type == "averages"){
      if(sessionFolders.length < 10){
       _listSize = listSize;
      } else {
       _listSize = 10;
      }
    } else {
      _listSize = 2;
    }
    
  }
  
  void display(){

    float relaxEnd = 0;
    float studyEnd = 0;
    float assessEnd = 0;
    
    String currentScreenshot = "";
    
    fill(graphBgColor);
    rect(visX - padding, visY - padding, visWidth - dotSize/2 + padding*2, visHeight + dotSize/2 + padding*2);
    
    if(fileName != null){
      for(int i = 0; i < _listSize; i++){
        if(fileName[0].charAt(0) != '.'){
          textAlign(LEFT, CENTER);
          
          String[] fileDate = split(fileName[0], '-');
          
          float thisX = i * visWidth/_listSize + visX;
          float previousX = (i-1) * visWidth/_listSize + visX;
          
          float attAvg = map(attentionAverageList[i], 100, 0, visY, visHeight + visY);
          float rlxAvg = map(relaxationAverageList[i], 100, 0, visY, visHeight + visY);
          float prevAttAvg = 0;
          float prevRlxAvg = 0;
          
          if(i>0){
            prevAttAvg = map(attentionAverageList[i-1], 100, 0, visY, visHeight + visY);
            prevRlxAvg = map(relaxationAverageList[i-1], 100, 0, visY, visHeight + visY);
          }
          
          if(mouseX >= thisX - dotSize/2 && mouseX <= thisX + dotSize/2){
            if(type == "averages"){
              if(mouseY >= visY && mouseY <= visY + visHeight + dotSize/2){
                fill(250);
                rect(thisX - dotSize/2, visY, dotSize, visHeight + dotSize/2);
              }
            }
            
            if(mouseY >= rlxAvg - dotSize/2 && mouseY <= rlxAvg + dotSize/2){
              //noFill();
              //stroke(0);
              //rect(thisX - dotSize/2, rlxAvg - dotSize/2, dotSize, dotSize); // boundin box
              fill(textDarkColor);
              text(round(relaxationAverageList[i])+"%", thisX + 10, rlxAvg - dotSize);
            }
            if(mouseY >= attAvg - dotSize/2 && mouseY <= attAvg + dotSize/2){
              //noFill();
              //stroke(0);
              //rect(thisX - dotSize/2, attAvg - dotSize/2, dotSize, dotSize); // bouning box
              fill(textDarkColor);
              text(round(attentionAverageList[i])+"%", thisX + 10, attAvg - dotSize);
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
            text(fileDate[2] + "." + fileDate[1], thisX, visHeight + visY + 40);
          } else {
            noFill();
            if(i>0 && data.data != null){
              for (int j = 0; j < data.data.length; j+=grainSize) {
                if (data.data[j][12] > 0 && j>0) {
                  
                  ////////////////////////////////////////////////////////////
                  int maxVal = 100; //TODO: what's the maximum value for the EEG?
                  ////////////////////////////////////////////////////////////
  
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
                  //rect(previousX, visY, grainSize, visHeight);
  
                  stroke(attentionColor);
                  line(
                        previousX,
                        map(data.data[j-grainSize][10], maxVal, 0, visY, visHeight + visY),
                        thisX,
                        map(data.data[j][10], maxVal, 0, visY, visHeight + visY)
                  );
                  stroke(relaxationColor);
                  line(
                        previousX,
                        map(data.data[j-grainSize][11], maxVal, 0, visY, visHeight + visY),
                        thisX,
                        map(data.data[j][11], maxVal, 0, visY, visHeight + visY)
                  );
                  
                  if(
                    mouseX > previousX
                    &&
                    mouseX <= thisX
                    &&
                    mouseY > visX - padding
                    &&
                    mouseY < visHeight + visX - padding
                  ){
                    
                    fill(255, 100);
                    noStroke();
                    rect(previousX, visY, grainSize/2, visHeight + dotSize/2);
                    
                    //fill(textDarkColor);
                    //text(int(data.data[j][0]), mouseX, mouseY - 20);

                    File imgTempFolder = new File(userFolder + "/" + sessionFolders[currentItem] + "/screenshots");
                    screenshotsArray = imgTempFolder.list();
                    for(int k = 0; k < screenshotsArray.length; k++){
                      String screenshot = screenshotsArray[k]; 
                      String[] screenshotTimeId = splitTokens(screenshot, "-");
                      if(int(screenshotTimeId[0]) == int(data.data[j][0])){
                        //println("screenshot["+k+"]:" + screenshotTimeId[0]);
                        currentScreenshot = imgTempFolder + "/" +screenshot;
                      }
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
      
      fill(textDarkColor);
      if(type == "averages"){
        textAlign(LEFT);
        text("Averaged values of EEG data", visX, visHeight + visY + 60);
      } else if(type == "values"){
        textAlign(CENTER, CENTER);
        text("RELAX", visX + padding, visY, relaxEnd - (visX + padding), 20);
        text("STUDY", relaxEnd, visY, studyEnd - relaxEnd, 20);
        text("ASSESS", studyEnd, visY, assessEnd - studyEnd, 20);
      }
    } else {
        textAlign(CENTER);
        text("It seems you have no data yet.\nGo ahead and start a new session to generate some.", visX, visHeight/2 + visY, visWidth, visHeight);
    }
    
    //Labels
    textAlign(LEFT, CENTER);
    text("100%", visX - padding/2, visY);
    text("50%", visX - padding/2, visY + visHeight/2 + dotSize/2);
    text("0%", visX - padding/2, visY + visHeight + dotSize/2);
  }
  
  void onClick(){
    
    if(sessionFolders.length == 0){
    } else {
      String lines[] = loadStrings(userFolder + "/" + sessionFolders[currentItem] + "/assessment.txt");
      assessmentData = lines;
    }
    
    if(fileName != null){
      for(int i = 0; i < _listSize; i++){
        if(fileName[0].charAt(0) != '.'){
          float thisX = i * visWidth/_listSize + visX;
          if(mouseX >= thisX - dotSize/2 && mouseX <= thisX + dotSize/2){
            if(type == "averages"){
              if(mouseY >= visY && mouseY <= visY + visHeight + dotSize/2){
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