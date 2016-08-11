void home(){
  int smallRectW = (videoWidth - padding*2)/3;
  int smallRectH = 140;
  int containerHeight = videoHeight + smallRectH + padding;

   if(e > 0){
       if(containerPosY < -containerHeight/4 + padding){
         containerPosY = -containerHeight/4 + padding;
       }
   } else if (e < 0) {
       if(containerPosY > containerHeight/5 - padding){
         containerPosY = containerHeight/5 - padding;
       }
   }
   
   containerPosY -= e;
   e = 0;
   
   image(homeImg, (width - homeImg.width)/2, visY);
  
  //fill(210);
  //rect(containerPosX, containerPosY, videoWidth, videoHeight);
  
  //rect(containerPosX, containerPosY + videoHeight + padding*3, smallRectW, smallRectH);
  //rect(containerPosX + smallRectW + padding, containerPosY + videoHeight + padding*3, smallRectW, smallRectH);
  //rect(containerPosX + (smallRectW + padding)*2, containerPosY + videoHeight + padding*3, smallRectW, smallRectH);
  
  //fill(textDarkColor);
  //textAlign(LEFT);
  //text("1. Capture data about your mental states", containerPosX, containerPosY + videoHeight + padding, smallRectW, smallRectH);
  //text("2. Focus on a task at a time", containerPosX + smallRectW + padding, containerPosY + videoHeight + padding, smallRectW, smallRectH);
  //text("3. Review and reflect", containerPosX + (smallRectW + padding)*2, containerPosY + videoHeight + padding, smallRectW, smallRectH);
  
  //textAlign(CENTER, CENTER);
  //text("EEG monitoring device", containerPosX, containerPosY + videoHeight + padding*3, smallRectW, smallRectH);
  //text("Feeler modules", containerPosX + smallRectW + padding, containerPosY + videoHeight + padding*3, smallRectW, smallRectH);
  //text("Feeler modules", containerPosX + (smallRectW + padding)*2, containerPosY + videoHeight + padding*3, smallRectW, smallRectH);
}