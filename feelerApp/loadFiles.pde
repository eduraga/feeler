public void loadFiles(){
  File directory1 = new java.io.File(sketchPath(""));
  absolutePath = directory1.getAbsolutePath();
  
  userFolder = absolutePath + "/user-data/" + currentUser;
  
  File tempUserFolder = new File(dataPath(userFolder));
  tempUserFolder.mkdir();
  
  //find files in current user folder
  File userFolderTemp = new File(userFolder);
  String[] directoryArray = userFolderTemp.list();
  
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
    loadFile(i);
  }
  
  trends.setup("averages");

}