package passwordrecovery;

public class RecoveryEmail {
    private String email;
    private String password;
    
    public RecoveryEmail() {
        email = "";
        password = "";
    }
    
    public void setEmail( String value ) {
        this.email = value;
    }

    public void setPassword( String value ) {
        this.email = value;
    }
      
    public String getEmail() { 
        return email;
    }
    
    public String getPassword() { 
        return password; 
    }
}
