public void loadFiles(){
  File directory1 = new java.io.File(sketchPath(""));
  absolutePath = directory1.getAbsolutePath();
  String temp = absolutePath;
  //temp += "/log";
  temp += "/" + userDataFolder + "/" + currentUser;

  //create user folder
  File f1 = new File(dataPath(temp));
  f1.mkdir();

  //temp += "/log";
  String log = temp + "/log";
  String assess = temp + "/assessment";

  //create log folder
  File f2 = new File(dataPath(log));
  f2.mkdirs();

  directory2 = new File(log);
  assessmentFolder = new File(assess);
  
  fileArray = directory2.list();
  fileAssessmentArray = assessmentFolder.list();
  
  if(fileArray != null && fileArray.length > 0){
    for(int i = fileArray.length - listSize; i < fileArray.length; i++){
      String extension = fileArray[i].substring(fileArray[i].lastIndexOf(".") + 1, fileArray[i].length());
      fileNames = splitTokens(fileArray[i]);

      if(fileNames[0].charAt(0) != '.' && new String("tsv").equals(extension)){
        loadFile(i);
      }
    }
  }
}