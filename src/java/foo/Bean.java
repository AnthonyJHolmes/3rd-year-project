
package foo;

/**
 *
 * 
 * 
 * This is the Java Bean for handling the registration of users to the system.
 * Contains a lot of getters and setters which you would typically find in a java bean
 * 
 * 
 * 
 * 
 * @author ajh3
 */
import java.util.*;
public class Bean {
    /*
     * Declaring my variables
     */
  private int UID;
  private String firstName;
  private String lastName;
  private String email;
  private String password1;
  private String password2;
  private Hashtable errors;
  
  
  
  /**
   * This method tests for errors from the form registration
   * @return true if there are no errors otherwise false meaning there is an error
   */
  public boolean validate() {
    boolean allOk=true;
   
    if (firstName.equals("")) {
      errors.put("firstName","Please enter your first name");
      firstName="";
      allOk=false;
    }
    
    if (lastName.equals("")) {
      errors.put("lastName","Please enter your last name");
      lastName="";
      allOk=false;
    }
    if (email.equals("") || (email.indexOf('@') == -1)) {
      errors.put("email","Please enter a valid email address");
      email="";
      allOk=false;
    }
    if (password1.equals("") ) {
      errors.put("password1","Please enter a valid password");
      password1="";
      allOk=false;
    }
    if (!password1.equals("") && (password2.equals("") || 
        !password1.equals(password2))) {
      errors.put("password2","Please confirm your password");
      password2="";
      allOk=false;
    }

    
    
    return allOk;
  }
  /**
   * Trims and retrieves the errors messages 
   * @param s
   * @return 
   */
  public String getErrorMsg(String s) {
    String errorMsg =(String)errors.get(s.trim());
    return (errorMsg == null) ? "":errorMsg;
  }
  /**
   * Initialising my bean variable to empty strings or 0
   */
  public Bean() {
    UID=0;  
    firstName="";  
    lastName="";
    email="";  
    password1="";
    password2="";    
    errors = new Hashtable();
  }
  //The next 50 lines are getters and setters for the relevant variables.
  public int getUID(){
      return UID;
  }
  public String getFirstName() {
    return firstName;
  }
  
  public String getLastName() {
    return lastName;
  }
  public String getEmail() {
    return email;
  }
  public String getPassword1() {
    return password1;
  }
  public String getPassword2() {
    return password2;
  }
  
  
  
  public void setUID(int UID){
      this.UID = UID;
  }
  public void setFirstName(String fname) {
    firstName =fname;
  }
  
  public void setLastName(String lname) {
    lastName =lname;
  }
  public void setEmail(String eml) {
    email=eml;
  } 
  public void  setPassword1(String p1) {
    password1=p1;
  }
  public void  setPassword2(String p2) {
    password2=p2;
  }
  
  public void setErrors(String key, String msg) {
    errors.put(key,msg);
  }
  
}
