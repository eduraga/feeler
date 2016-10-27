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
    rectWidth = (_visWidth - dotSize)/2 - 100;
    //rectWidth = (_visWidth - dotSize/2)/2;
    rectHeight = _visHeight + 50;
    //rectHeight = _visHeight; 
  }
  
  void display(int i){
    if(type == "assessment"){
      thisX = visX + rectWidth + padding*6;// commented by Eva
      //thisY = visHeight; // added by Eva
      
    } else {
      //thisX = visX + rectWidth;
      thisX = visX - 30;
    }
    thisY = visX + padding*7; // added by Eva, this modifies y position of the square barcharts
    //thisY = visY;
    
    if(
      mouseX > thisX - padding && mouseX < rectWidth + padding*4 + thisX - padding
      &&
      mouseY > thisY - padding && mouseY < thisY - padding + rectHeight + padding*2
    ){
      hoverUpLeft.set(thisX - padding, thisY - padding);
      hoverDownRight.set(rectWidth + padding*2 + thisX - padding, thisY - padding + rectHeight + padding*2);
      //fill(209);
      fill(color(85,26,139));
      //fill(textLightColor);//commented by Eva
    } else {
       fill(209);
      //fill(graphBgColor);
      
    }
    
    rect(thisX - padding - 1 + 10, thisY - padding - 1, rectWidth + padding - 12, rectHeight + padding - 12);
    //rect(thisX - padding, thisY - padding, rectWidth + padding*2, rectHeight + padding*2);// old
    fill(250);// commented by Eva
    rect(thisX - 7, thisY - 10 - 7, rectWidth, rectHeight);//moves inside rectangles
    
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
        text("Your activity / " + fileDate[2] + "." + fileDate[1] + "." + fileDate[0] + ", " + fileDate[3] + ":" + fileDate[4] + ":" + fileDate[5], thisX - 40, headerHeight + padding + 60);
        //text("Your activity / " + fileDate[2] + "." + fileDate[1] + "." + fileDate[0] + ", " + fileDate[3] + ":" + fileDate[4] + ":" + fileDate[5], thisX - 110, headerHeight + padding + 60);
        pageH2("EEG data");// added by Eva
        pageH3("Personal experience");// added by Eva
        pageH4("Values based on your EEG data");// added by Eva
        pageH5("Values based on your personal experience");// added by Eva
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
      rect(thisX - 7, thisY - 10 - 7, map(rlxAvg, 0, 100, 0, rectWidth), rectHeight/2);
      //rect(thisX, thisY, map(rlxAvg, 0, 100, 0, rectWidth), rectHeight/2);//old
      fill(50);
      //fill(textDarkColor);
      textSize(24);// added by eva
      text("Relaxation "+round(rlxAvg)+"%", thisX - 100, thisY - 10, rectWidth, rectHeight/2);
      
      fill(attentionColor);
      rect(thisX - 7, thisY + rectHeight/2 - 10 - 7, map(attAvg, 0, 100, 0, rectWidth), rectHeight/2);
      //rect(thisX, thisY + rectHeight/2, map(attAvg, 0, 100, 0, rectWidth), rectHeight/2);//old
      fill(50);
      //fill(textDarkColor);
      text("Attention "+round(attAvg)+"%", thisX - 100, thisY + rectHeight/2 - 10, rectWidth, rectHeight/2);
      
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