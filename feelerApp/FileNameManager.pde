
class FileNameManager {
  String path=sketchPath();
  HashMap<String, String> elements = new HashMap<String, String>();
  FileNameManager() {
    initElementsMap();
  }
  FileNameManager(String path) {
    path=sketchPath();
    initElementsMap();
  }
  private void initElementsMap() {
    //here you can define the folder & file structure for data storage. 
    //words that start with $ will be replaced for the homonimous hashmap indexes
    //the hashes in caps are the ones that need runtime update
    
    
    elements.put("LOGFOLDERNAME","undefined");
    elements.put("CURRENTUSER","undefined");
    
    //variables ending in path are for full absolute paths to a folder
    //variables ending in folder are for folder names and not absolute paths
    //variables ending in filename are for filenames without the path
    //variables ending in file are for filenames with path
    
    //folder:
    //screenshots
    //path:
    //c:/users/anita/documents/feeler/user-data/screenshots
    elements.put("userDataFolder","user-data");
    elements.put("userDataPath",path+"/$userDataFolder");
    
    elements.put("userPath","$dataPath/$CURRENTUSER");
    
    //folder and path where we are storing the session data such as experience.txt and brain-activity.tsv
    elements.put("currentLogFolder","$LOGFOLDERNAME");
    elements.put("currentLogPath", "$datapath/$currentLogFolder");

    elements.put("SCREENSHOTNAME","undefined");
    elements.put("screenshotPath", "$datapath/$currentLogFolder/screenshots");
    elements.put("screenshotFile", "$screenshotPath/$SCREENSHOTNAME");
    
    elements.put("brainActivityFile", "$currentLogFolder/brain-activity.tsv");
    elements.put("asessmentFile", "$currentLogFolder/assessment.txt");
  }
  void updateUserFolder(){
    elements.put("CURRENTUSER","%currentUser");
  }
  //change the folder to which we are logging

  
  String newLogFolder(){
    
    String newFolderName= String.valueOf((int) (longTimer.get()) 
    + "-" + year()) + "-" 
    + String.valueOf(month()) + "-" 
    + String.valueOf(day()) + "-" 
    + String.valueOf(hour()) + "-" 
    + String.valueOf(minute()) 
    + "-" + String.valueOf(second()) 
    + "-screenshot.png";
    
    
    elements.put("LOGFOLDERNAME",newFolderName);
    
    return elements.get("sessionDataFolder");
  }
  String getLogFolder(){
    return elements.get("screenshotFile");
  }
  String newScreenshotName(){
    String newScreenshotName= String.valueOf((int) (longTimer.get()) 
    + "-" + year()) + "-" 
    + String.valueOf(month()) + "-" 
    + String.valueOf(day()) + "-" 
    + String.valueOf(hour()) + "-" 
    + String.valueOf(minute()) 
    + "-" + String.valueOf(second()) 
    + "-screenshot.png";
    elements.put("SCREENSHOTNAME",newScreenshotName);
    return parsePath("screenshotFile");
  }
  //will return a path string replacing the $ with the values of $
  String parsePath(String which){
    String str=elements.get(which);
    
    
    //String str = "Hello $myKey1, welcome to Stack Overflow. Have a nice $myKey2";
    //HashMap<String, String> map = new HashMap<String, String>();
    int maxRecursion=100;
    int recursion=0;
    //map.put("myKey1", "DD84 $myKey2");
    //map.put("myKey2", "day $myKey1");
    while (str.contains("$")) {
      
      for (HashMap.Entry<String, String> entry : elements.entrySet()) {
        str = str.replace("$" + entry.getKey() + "", entry.getValue());
      }
      recursion++;
      if(recursion>maxRecursion){
        println("Darn! there is a circular reference in variable names. check it.");
        break;
      }
    }
    println(str);        

    
    updateUserFolder();
    return str;
  }
  
  /*private String slashPath(String in) {
    in.replace("\\", "/");
    if (in.charAt(in.length()-1)=='/') {
      return in;
    } else {
      return in+"/";
    }
  }*/
}