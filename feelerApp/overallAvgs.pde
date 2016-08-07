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
    rectWidth = (_visWidth - dotSize/2)/2;
    rectHeight = _visHeight; 
  }
  
  void display(int i){
    
    if(type == "assessment"){
      thisX = visX + rectWidth + padding*3;
    } else {
      thisX = visX;
    }
    thisY = visY;
    
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
        fill(textDarkColor);
        textAlign(LEFT, CENTER);
        text("Your activity > " + fileDate[2] + "." + fileDate[1] + "." + fileDate[0] + ", " + fileDate[3] + ":" + fileDate[4] + ":" + fileDate[5], thisX, thisY - padding*2);
        
        rlxAvg = relaxationAverageList[i];
        attAvg = attentionAverageList[i];
        
      } else if(type == "assessment"){
        
  //cp5.getController("assessRelaxationMeditation").hide();
  //cp5.getController("assessRelaxationStudy").hide();
  //cp5.getController("assessRelaxationPlay").hide();
  
  //cp5.getController("assessAttentionMeditation").show();
  //cp5.getController("assessAttentionStudy").show();
  //cp5.getController("assessAttentionPlay").show();
  
        
        //rlxAvg = float(assessmentData[0]);
        if(assessmentData.length == 9){
         //attAvg = float(assessmentData[1]);
          rlxAvg = round((float(assessmentData[3]) + float(assessmentData[4]) + float(assessmentData[5]))/3);
          attAvg = round((float(assessmentData[6]) + float(assessmentData[7]) + float(assessmentData[8]))/3);
        }
          
      } else if(type == "personalAverage"){
        println("personalAverage");
        rlxAvg = assessmentAttAvgs;
        attAvg = assessmentRlxAvgs;
      }

      textAlign(CENTER, CENTER);
    
      fill(150);
      rect(thisX, thisY, map(rlxAvg, 0, 100, 0, rectWidth), rectHeight/2);
      fill(textDarkColor);
      text("Relaxation "+round(rlxAvg)+"%", thisX, thisY, rectWidth, rectHeight/2);
      
      fill(70);
      rect(thisX, thisY + rectHeight/2, map(attAvg, 0, 100, 0, rectWidth), rectHeight/2);
      fill(textDarkColor);
      text("Attention "+round(attAvg)+"%", thisX, thisY + rectHeight/2, rectWidth, rectHeight/2);
      
      fill(textDarkColor);
      textAlign(LEFT, CENTER);
      text(caption, thisX, thisY + rectHeight + padding*2);
    }
  }
  
  void onClick(int x, int y){
    hoverUpLeft.set(0,0);
    hoverDownRight.set(0,0);
    
    if(x >= this.thisX && x <= this.thisX + this.rectWidth){
      if(y >= this.thisY && y <= this.thisY + rectHeight){
        text("Loading...", width/2, height/2);
        
        if(type == "eeg"){
          currentPage = "eegActivity";
        } else if(type == "assessment"){
          currentPage = "assessmentActivity";
        }
      }
    }
  }
}