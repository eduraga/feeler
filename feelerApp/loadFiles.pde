public void loadFiles(){
  File directory1 = new java.io.File(sketchPath(""));
  absolutePath = directory1.getAbsolutePath();
  String temp = absolutePath;
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
  
  listSize = fileArray.length;
  
  attentionAverageList = new float[listSize];
  relaxationAverageList = new float[listSize];
  
  eegAct = new LineChart("values");  if(fileArray != null && fileArray.length > 0){
    for(int i = fileArray.length - listSize; i < fileArray.length; i++){
      loadFile(i);
   }
  }
  
  trends = new LineChart("averages");
  eegAct = new LineChart("values");
}