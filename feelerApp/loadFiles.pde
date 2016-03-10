public void loadFiles(){
  File directory1 = new java.io.File(sketchPath(""));
  absolutePath = directory1.getAbsolutePath();
  String temp = absolutePath;
  //temp += "/log";
  temp += "/" + userDataFolder + "/" + currentUser;

  //create user folder
  File f1 = new File(dataPath(temp));
  f1.mkdir();

  temp += "/log";

  //create log folder
  File f2 = new File(dataPath(temp));
  f2.mkdirs();

  directory2 = new File(temp);
  fileArray = directory2.list();
  
  if(fileArray != null && fileArray.length > 0){
    for(int i = fileArray.length - listSize; i < fileArray.length; i++){
      fileNames = splitTokens(fileArray[i]);
      
      if(fileNames[0].charAt(0) != '.'){
        loadFile(i);
      }
    }
  }
  
  
  
}