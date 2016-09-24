
class FileNameManager {
  String path=sketchPath();
  HashMap<String, String> elements = new HashMap<String, String>();
  File file=new File(path);
  FileNameManager() {
  }
  FileNameManager(String path) {
    path=sketchPath();
    updatePath();
  }
  private void initElementsMap() {
    //here you can define the folder & file structure for data storage. 
    //words that start with $ will be replaced for the homonimous hashmap indexes
    //the hashes in caps are the ones that need runtime update
    
    elements.put("LOGFOLDERNAME","%s");
    elements.put("SCREENSHOTNAME","%s");
    
    elements.put("dataPath",path+"/user-data");
    elements.put("userPath","$dataPath/$currentUser");
    elements.put("currentLogFolder","$LOGFOLDERNAME");
    elements.put("sessionDataFolder", "$datapath/$currentLogFolder");
    elements.put("screenshotFolder", "$datapath/$currentLogFolder");
    elements.put("screenshotFile", "$screenshotFolder/$SCREENSHOTNAME");
  }
   //change the folder to which we are logging
  String newLogFolder(){
    return 
  }
  private String slashPath(String in) {
    in.replace("\\", "/");
    if (in.charAt(in.length()-1)=='/') {
      return in;
    } else {
      return in+"/";
    }
  }
  boolean setBasePath(String p) {
    path=p;
    return updatePath();
  }
  boolean updatePath() {
    println("path points to"+file);
    file=new File(path);
    return  file.exists();
  }
  String getString() {
    return path;
  }
  File getFile() {
    return file;
  }
}