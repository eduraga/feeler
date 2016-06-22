public void loadFiles(){
  File directory1 = new java.io.File(sketchPath(""));
  absolutePath = directory1.getAbsolutePath();
  
  File tempUserDataFolder = new File(dataPath(absolutePath + "/user-data"));
  tempUserDataFolder.mkdir();
  
  userFolder = absolutePath + "/user-data/" + currentUser;
  
  File tempUserFolder = new File(dataPath(userFolder));
  tempUserFolder.mkdir();
  
  //find files in current user folder
  File userFolderTemp = new File(userFolder);
  String[] directoryArray = userFolderTemp.list();

  if(tempUserFolder.list().length > 0){
    println("Directory is not empty!");
    
    //filter session folders (folders starting with '2', from year two thousand something)
    //this means that in the year 3000 this code needs to be reviewed
    String sessionTempFolders = "";
    for(int i = 0; i < directoryArray.length; i++){
      String file = directoryArray[i];
      if(file.charAt(0) == '2'){
        sessionTempFolders += directoryArray[i];
        if(i < directoryArray.length) sessionTempFolders += " ";
      }
    }
    
    //put filtered folders in a new array
    sessionFolders = splitTokens(sessionTempFolders, " ");
    
    listSize = sessionFolders.length;
    attentionAverageList = new float[listSize];
    relaxationAverageList = new float[listSize];
    
    //then loop through them
    for(int i = 0; i < sessionFolders.length; i++){
      assessmentAttAvgs += float(loadStrings(userFolder + "/" + sessionFolders[i] + "/assessment.txt")[0])/sessionFolders.length;
      assessmentRlxAvgs += float(loadStrings(userFolder + "/" + sessionFolders[i] + "/assessment.txt")[1])/sessionFolders.length;
      
      loadFile(i);
    }
  } else {
    println("Directory is empty!");
  }
  
  trends.setup("averages");
  personalExperience.setup("personal");
}