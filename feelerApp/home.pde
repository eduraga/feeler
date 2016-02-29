void home(){
  int smallRectW = videoWidth/3 - padding/2;
  int smallRectH = 100;
  int containerHeight = videoHeight + smallRectH + padding;
  
  if(e < -1 || e > 1){
    
    if(containerPosY > containerHeight/4 - padding){
      containerPosY = containerHeight/4 - padding;
    } else if(containerPosY < -containerHeight/10 + padding){
      containerPosY = -containerHeight/10 + padding;
    }
    containerPosY -= e;
  }
  
  fill(210);
  rect(containerPosX, containerPosY, videoWidth, videoHeight);
  rect(containerPosX, containerPosY + videoHeight + padding, smallRectW, smallRectH);
}