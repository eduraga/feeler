class OverallAvgs{
  int thisX;
  int thisY;
  int rectWidth;
  int rectHeight;
  String type;
  String caption;
  
  OverallAvgs(String _type, String _caption){
    type = _type;
    caption = _caption;
  }
  
  void setup(int _visWidth, int _visHeight){
    rectWidth = (_visWidth - dotSize)/2 - 50;
    //rectWidth = (_visWidth - dotSize/2)/2;
    rectHeight = _visHeight + 50;
    //rectHeight = _visHeight; 
  }
  
  void display(int i){
    if(type == "assessment"){
      thisX = visX + rectWidth + padding*4;
      thisY = visHeight; // added by Eva
      
    } else {
      thisX = visX - 30;
    }
    thisY = visX - padding + 60; // added by Eva, this modifies y position of the square barcharts
    //thisY = visY;
    
    if(
      mouseX > thisX - padding && mouseX < rectWidth + padding*2 + thisX - padding
      &&
      mouseY > thisY - padding && mouseY < thisY - padding + rectHeight + padding*2
    ){
      hoverUpLeft.set(thisX - padding, thisY - padding);
      hoverDownRight.set(rectWidth + padding*2 + thisX - padding, thisY - padding + rectHeight + padding*2);
      fill(textLightColor);
    } else {
      fill(graphBgColor);
    }
    
    rect(thisX - padding, thisY - padding, rectWidth + padding*2, rectHeight + padding*2);
    fill(250);
    rect(thisX, thisY, rectWidth, rectHeight);
    
    if(fileName[0].charAt(0) != '.'){
      String[] fileDate = split(fileName[0], '-');
      
      float rlxAvg = 0;
      float attAvg = 0;
      
      if(type == "eeg"){
        pushStyle();
        fill(50);
        //fill(textDarkColor);
        pageH1("Review");// added by Eva
        textAlign(LEFT, CENTER);
        textSize(20);// addded by Eva session data
        text("Your activity > " + fileDate[2] + "." + fileDate[1] + "." + fileDate[0] + ", " + fileDate[3] + ":" + fileDate[4] + ":" + fileDate[5], 100, headerHeight + padding + 60);
        //text("Your activity > " + fileDate[2] + "." + fileDate[1] + "." + fileDate[0] + ", " + fileDate[3] + ":" + fileDate[4] + ":" + fileDate[5], thisX, thisY - padding*2);
        pageH2("EEG data");// added by Eva
        pageH3("Personal experience");// added by Eva
        popStyle();
       
        if(relaxationAverageList[i] > 0) {
          rlxAvg = relaxationAverageList[i];
        } else {
          rlxAvg = 0;
        }
        
        if(attentionAverageList[i] > 0) {
          attAvg = attentionAverageList[i];
        } else {
          attAvg = 0;
        }
      } else if(type == "assessment"){
        if(assessmentData.length == 9){
          rlxAvg = round((float(assessmentData[3]) + float(assessmentData[4]) + float(assessmentData[5]))/3);
          attAvg = round((float(assessmentData[6]) + float(assessmentData[7]) + float(assessmentData[8]))/3);
        }
          
      } else if(type == "personalAverage"){
        println("personalAverage");
        rlxAvg = assessmentAttAvgs;
        attAvg = assessmentRlxAvgs;
      }

      pushStyle();
      textAlign(CENTER, CENTER);
    
      fill(relaxationColor);
      rect(thisX, thisY, map(rlxAvg, 0, 100, 0, rectWidth), rectHeight/2);
      fill(50);
      //fill(textDarkColor);
      textSize(24);// added by eva
      text("Relaxation "+round(rlxAvg)+"%", thisX, thisY, rectWidth, rectHeight/2);
      
      fill(attentionColor);
      rect(thisX, thisY + rectHeight/2, map(attAvg, 0, 100, 0, rectWidth), rectHeight/2);
      fill(50);
      //fill(textDarkColor);
      text("Attention "+round(attAvg)+"%", thisX, thisY + rectHeight/2, rectWidth, rectHeight/2);
      
      fill(textDarkColor);
      textAlign(LEFT, CENTER);
      textSize(12);
      text(caption, thisX, thisY + rectHeight + padding*2);
      popStyle();
    }
  }
  
  void onClick(int x, int y){
    hoverUpLeft.set(0,0);
    hoverDownRight.set(0,0);
    
    if(x >= this.thisX && x <= this.thisX + this.rectWidth){
      if(y >= this.thisY && y <= this.thisY + rectHeight){
        text("Loading...", width/2 + 10, height/2);
        textSize(20);//to change
        
        if(type == "eeg"){
          currentPage = "eegActivity";
        } else if(type == "assessment"){
          currentPage = "assessmentActivity";
        }
      }
    }
  }
}