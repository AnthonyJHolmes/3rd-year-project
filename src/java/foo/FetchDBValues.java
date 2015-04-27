package foo;
/**
 * Queries the database.  Ran out of time to merge the code together. only contains a method to get the users modules
 * @author ajh3
 */
import java.util.*;


public class FetchDBValues {
    DatabaseClass db = new DatabaseClass();
    int Student_ID=0;
    
    /**
     * Fetches the modules for which a user is currently doing
     * @param userID User ID
     * return a String array containing all the modules of what a user is doing.
     */
    public String[] fetchModules(int userID){
        //db.setup("cs1.ucc.ie","2016_rwh1", "rwh1","mohxelai");
        db.setup("mysql89268-UccProject.j.layershift.co.uk","2016_UCC", "root","HMoHCBzrnu");
        String array[] = null;
        //get all the modules that the current user is doing
        array= db.SelectColumn("SELECT Module FROM Student_modules WHERE Student_ID = " +userID +""); 
    return array;
    }
  
}
