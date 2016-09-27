class FileNameManager {
  //String path=sketchPath();
  HashMap<String, String> elements = new HashMap<String, String>();
  FileNameManager() {
    initElementsMap();
  }
  FileNameManager(String path) {
    //path=sketchPath();
    initElementsMap();
  }
  private void initElementsMap() {


    //here you can define the folder & file structure for data storage. 
    //words that start with $ will be replaced for the homonimous hashmap indexes
    //the hashes in caps are the ones that need runtime update
    elements.put("LOGFOLDERNAME", "undefined");
    elements.put("CURRENTUSER", "undefined");
    //variables in caps are updated in runtime
    //variables ending in path are for full absolute paths to a folder
    //variables ending in folder are for folder names and not absolute paths
    //variables ending in filename are for filenames without the path
    //variables ending in file are for filenames with path
    String sp=sketchPath("");
    char ch=sp.charAt(sp.length()-1);
    println(ch);
    //remove possible trailing slashes from sp
    if (ch=='\\'||ch=='/') {
      sp=sp.substring(0, sp.length()-1);
    }
    elements.put("dataRootPath", sp);

    //note that usersData and user-Data are different
    elements.put("usersDataFolder", "user-data");
    elements.put("usersDataPath", "$dataRootPath/$usersDataFolder");

    elements.put("user-dataFolder", "$CURRENTUSER");
    elements.put("user-dataPath", "$usersDataPath/$user-dataFolder");

    //folder and path where we are storing the session data such as experience.txt and brain-activity.tsv
    elements.put("currentLogFolder", "$LOGFOLDERNAME");
    elements.put("currentLogPath", "$user-dataPath/$LOGFOLDERNAME");

    elements.put("SCREENSHOTNAME", "undefined");
    elements.put("screenshotPath", "$currentLogPath/screenshots");
    elements.put("screenshotFile", "$screenshotPath/$SCREENSHOTNAME");

    elements.put("brainActivityFile", "$currentLogPath/brain-activity.tsv");
    elements.put("asessmentFile", "$currentLogPath/assessment.txt");
  }
  void updateUserFolder() {
    elements.put("CURRENTUSER", currentUser);
  }
  //change the folder to which we are logging

  //update the LOGFOLDERNAME var
  String newLogFolder() {



    String newFolderName= nf(year(), 4)+"-"+nf(month(), 2)+"-"+nf(day(), 2)+"-"+nf(hour(), 2)+"-"+nf(minute(), 2)+"-"+nf(second(), 2);


    elements.put("LOGFOLDERNAME", newFolderName);

    return elements.get("sessionDataFolder");
  }

  //update the SCREENSHOTNAME var
  String newScreenshotFile() {
    String newScreenshotName= String.valueOf((int) (longTimer.get()) 
      + "-" + year()) + "-" 
      + String.valueOf(month()) + "-" 
      + String.valueOf(day()) + "-" 
      + String.valueOf(hour()) + "-" 
      + String.valueOf(minute()) 
      + "-" + String.valueOf(second()) 
      + "-screenshot.png";
    elements.put("SCREENSHOTNAME", newScreenshotName);
    return parsePath("screenshotFile");
  }
  String getCurrentUserPath() {
    return parsePath("user-dataPath");
  }
  String getLogPath() {
    return parsePath("currentLogPath");
  }
  String getBrainActivityFile() {
    return parsePath("brainActivityFile");
  }
  String getOther(String which) {
    return parsePath(which);
  }
  //get a list of existing files at "which" path
  String [] getFileListAt(String which) {
    File where=new File(parsePath(which));
    String[]l=where.list();
    if (l==null) {
      println("'"+which+"' contained no files, for it resolves to '"+parsePath(which)+"'");
      l=new String[0];
    }
    return l;
  }
  //will return a path string replacing the $ with the values of $
  String parsePath(String which) {
    //so actually the updateUserFolder should happen on login/logout. But here is more traceable.
    updateUserFolder();
    
    String str=elements.get(which);
    //fall back to the raw which string
    if (str==null)
      str=which;


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
      if (recursion>maxRecursion) {
        println("Darn! either there is a reference to an unexistent name, or there is a circular reference in variable names. check it.");
        break;
      }
    }
    
    return str;
  }
}