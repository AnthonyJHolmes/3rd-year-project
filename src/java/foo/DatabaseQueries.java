
package foo;

/**
 *
 * A few other queries I kept these separate at first but ran out of time to merge the two files
 * @author ajh3
 */
public class DatabaseQueries {
  DatabaseClass database;
  //database set up
    public void setup()
        {
        database = new DatabaseClass();
        //database.setup("cs1.ucc.ie","2016_rwh1", "rwh1","mohxelai");
        database.setup("mysql89268-UccProject.j.layershift.co.uk","2016_UCC", "root","HMoHCBzrnu");
        }
    /**
     * A new person has registered. Their details have been added to the database
     * @param UID - user ID
     * @param name - first name
     * @param surname - surname
     * @param email - alternate email
     * @param User_type - student or lecturer
     * @param password  - password
     */
    public void insertNewPerson(Integer UID,String name, String surname, String email,
            String User_type,String password)
    {
         database.Insert("INSERT INTO User_details"
                 + "(Student_or_staff_number, "                 
                 + "First_name, "                
                 + "Last_name, "               
                 + "Alternate_email, "
                 + "User_type, "
                 + "User_password)"
                 
                 + " VALUES("
                 + "" +UID+","                
                 + "'" +name+"',"                
                 + "'" +surname+"',"                
                 + "'" +email+"',"
                 + "'" +User_type+"',"               
                 + "'" +password+"');");       
    }
    /**
     * Logs the user in. Checks to see if the user exists
     * @param username - user ID
     * @param password - Password
     * @return true if the persons details are correct. Otherwise false
     */
    
    public boolean logUserIn(String username, String password){

        boolean isLoggedIn = false;
        String[] SelectRow = database.SelectRow("SELECT * FROM User_details WHERE Student_or_Staff_number ="+username+" AND User_password ="+password+";");
        if(SelectRow !=null|| SelectRow.length !=0){
            
            for(String everything: SelectRow){
                
                isLoggedIn= true;
            }
            return isLoggedIn;
        }else{
            System.err.println("Not a user");
            return isLoggedIn;
        }
        
        
    }
    /**
     * Insert a new person into the group
     * @param groupName - group name
     * @param userID - individual user ID
     * @param year  - year of which the person who created the group is in.
     */
    public void insertIntoGroup(String groupName,Integer userID, Integer year)
    {
         database.Insert("INSERT INTO Groups"
                 + "(Group_name, "                 
                 + "ID_number, "                
                 + "Year)"
                 
                 + " VALUES("
                 + "'" +groupName+"',"                
                 + "" +userID+","                
                 + "" +year+");");       
    }
    /**
     * Gets the user type - student or lecturer, needed throughout some parts of querying the database
     * @param userID - users ID
     * @return a String array with the users type.
     */
    public String[] getUserType(Integer userID){
        String[] result =null;
         result = database.SelectRow("SELECT User_type FROM User_details WHERE Student_or_staff_number ="+userID+";");
        
        
        return result;
    }
}
