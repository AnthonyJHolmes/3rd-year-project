
package foo;

/**
 * Class full of different queries
 * @author ajh3
 */
import java.sql.*;
import java.text.*;
import java.io.*;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import org.json.simple.JSONObject;

public class DatabaseClass {

    private Statement statementObject;
    private Connection connectionObject;
    private String dbserver;
    private String DSN;
    private String username;
    private String password;
    private boolean setup = false;

    public String setup(String dbserver, String DSN, String username, String password) {
        this.dbserver = dbserver;
        this.DSN = DSN;
        this.username = username;
        this.password = password;
        String URL = "jdbc:mysql://" + dbserver + "/" + DSN;

        try {// Initialiase drivers
            Class.forName("com.mysql.jdbc.Driver");
        } catch (Exception exceptionObject) {
            writeLogSQL(URL + " caused error " + exceptionObject.getMessage() + " Error dbclass.setup.1. ");
            return ("Failed to load JDBC/ODBC driver. Error dbclass.setup.1 PLEASE report this error");
        }
        try {
            // Establish connection to database
            connectionObject = DriverManager.getConnection(URL, username, password);
            setup = true;
        } catch (SQLException exceptionObject) {
            writeLogSQL(URL + " caused error " + exceptionObject.getMessage() + " Error dbclass.setup.2");
            return ("Problem with setting up " + URL + " Error dbclass.setup.2 PLEASE report this error");
        }

        return "";
    } // DatabaseConnectorNew constructor

    public boolean issetup() {
        return setup;
    }

    public void Close() {
        try {
            // Establish connection to database
            connectionObject.close();
        } catch (SQLException exceptionObject) {
            System.out.println("Problem with closing up ");
            writeLogSQL("closing caused error " + exceptionObject.getMessage());
        }
    } //CloseDatabaseConnection

    public void Insert(String SQLinsert) {

        // Setup database connection details
        try {
            // Setup statement object
            statementObject = connectionObject.createStatement();

            // execute SQL commands to insert data
            statementObject.executeUpdate(SQLinsert);
            writeLogSQL(SQLinsert + " Executed OK");
        } catch (SQLException exceptionObject) {
            System.out.println(SQLinsert + " - Problem is : " + exceptionObject.getMessage());
            writeLogSQL(SQLinsert + " caused error " + exceptionObject.getMessage());
        }
    } // End Insert
    
    public void Update(String SQLupdate) {

        // Setup database connection details
        try {
            // Setup statement object
            statementObject = connectionObject.createStatement();

            // execute SQL commands to update data
            statementObject.executeUpdate(SQLupdate);
            writeLogSQL(SQLupdate + " Executed OK");
        } catch (SQLException exceptionObject) {
            System.out.println(SQLupdate + " - Problem is : " + exceptionObject.getMessage());
            writeLogSQL(SQLupdate + " caused error " + exceptionObject.getMessage());
        }
    } // End update
    public void Delete(String SQLdelete) {

        // Setup database connection details
        try {
            // Setup statement object
            statementObject = connectionObject.createStatement();

            // execute SQL commands to delete data
            statementObject.executeUpdate(SQLdelete);
            writeLogSQL(SQLdelete + " Executed OK");
        } catch (SQLException exceptionObject) {
            System.out.println(SQLdelete + " - Problem is : " + exceptionObject.getMessage());
            writeLogSQL(SQLdelete + " caused error " + exceptionObject.getMessage());
        }
    } // End delete
    public String[] SelectRow(String SQLquery, String rowName) {
        String Result[];
        // Send an SQL query to a database and return the *single column* result in an array of strings
        try {// Make connection to database
            statementObject = connectionObject.createStatement();
            ResultSet statementResult = statementObject.executeQuery(SQLquery); //Should connection be left open?
            ResultSetMetaData rsmd = statementResult.getMetaData();
            int nrOfColumns = rsmd.getColumnCount();
            Result = new String[nrOfColumns];
            statementResult.next();
            int currentCounter = 0;
            while (statementResult.next()) // While there are rows to process
            {
                // Get the first cell in the current row                
                Result[currentCounter] = statementResult.getString(rowName);
            }
            // Close the link to the database when finished

        } catch (Exception e) {
            System.err.println("Select problems with SQL " + SQLquery);
            System.err.println("Select problem is " + e.getMessage());
            Result = new String[0]; //Need to setup result array to avoid initialisation error
            writeLogSQL(SQLquery + " caused error " + e.getMessage());
        }
        writeLogSQL(SQLquery + "worked ");
        return Result;
    } // End SelectRow
    /**
     * Count the number of rows that exist where there is a time slot over lapping
     * @param SQLquery
     * @param date
     * @param time_start
     * @param time_end
     * @param user
     * @return true if a time doesnt exist otherwise false
     * @throws SQLException
     * @throws ParseException 
     */
    public boolean SelectCount(String SQLquery, String date, String time_start, String time_end, int user) throws SQLException, ParseException{
         SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Calendar cal = Calendar.getInstance();
        boolean numOfRows = true; //true being that there is a free slot specified by the user.
        
        try {
            //we send a query initially to see if it falls directly on the same day and time
            statementObject = connectionObject.createStatement();
            ResultSet rs = statementObject.executeQuery(SQLquery);
            if(!rs.next()){
                System.err.println(numOfRows);
                return numOfRows;
            }
            else{
                ArrayList<String> al = new ArrayList<String>();
                //this is the query that compares the time where the time might be overlapping on the same date
                String query2 = "SELECT  mt.start_date, mt.reoccur " +
                                "FROM Modules_and_tutorials mt, Student_modules stm " +
                                "WHERE stm.Module = mt.module_code AND " +
                                "stm.Student_ID = "+user+" AND " +
                                "(mt.time_start = '"+time_start+"' OR mt.time_finish = '"+time_end+"') AND"
                        + "(mt.time_start >='"+time_start+"' AND mt.time_start <='"+time_end+"') AND"
                        + "(mt.time_finish >='"+time_start+"' AND mt.time_finish <='"+time_end+"');";
                
                
                
                ResultSet rs2 = statementObject.executeQuery(query2);
                //get the next 12 weeks of dates
                while(rs2.next()){
                    String start_date = rs2.getString("start_date");
                    int reoccur = rs2.getInt("reoccur");
                        
                    al.add(start_date);
                    for(int i =0; i<reoccur; i++){
                        cal.setTime(sdf.parse(start_date));
                        cal.add(Calendar.DATE, 7);
                        start_date = sdf.format(cal.getTime());
                        al.add(start_date);
                        
                    }
                    
                }
                //if our date clashes then there is a problem
                for(String somedate : al){
                    if(somedate == null ? date == null : somedate.equals(date)){
                        numOfRows = false;
                    }
                    
                }
                               
            }
        } catch (SQLException e) {
            System.err.println(e);
        } finally {
            if (statementObject != null) {
                statementObject.close();
            }
        }
        
       
        return numOfRows;// return a boolean
    }

    public String[] SelectRow(String SQLquery) {
        String Result[];
        // Send an SQL query to a database and return the *single column* result in an array of strings
        try {// Make connection to database
            statementObject = connectionObject.createStatement();

            ResultSet statementResult = statementObject.executeQuery(SQLquery); //Should connection be left open?

            ResultSetMetaData rsmd = statementResult.getMetaData();
            int nrOfColumns = rsmd.getColumnCount();

            Result = new String[nrOfColumns];

            statementResult.next();

            int currentCounter = 0;

            while (currentCounter < nrOfColumns) // While there are rows to process
            {
                // Get the first cell in the current row
                Result[currentCounter] = statementResult.getString(currentCounter + 1);
                currentCounter++;

            }
            // Close the link to the database when finished

        } catch (Exception e) {
            System.err.println("Select problems with SQL " + SQLquery);
            System.err.println("Select problem is " + e.getMessage());
            Result = new String[0]; //Need to setup result array to avoid initialisation error
            writeLogSQL(SQLquery + " caused error " + e.getMessage());
        }
        writeLogSQL(SQLquery + "worked ");
        return Result;
    } // End SelectRow
     
    public String[] SelectColumn(String SQLquery) {
        String Result[];
        // Send an SQL query to a database and return the *single column* result in an array of strings
        try {// Make connection to database
            statementObject = connectionObject.createStatement(); //Should connection be left open?

            ResultSet statementResult = statementObject.executeQuery(SQLquery);

            // Start solution from http://www.coderanch.com/t/303346/JDBC/java/find-number-rows-resultset
            int rowcount = 0;
            if (statementResult.last()) {
                rowcount = statementResult.getRow();
                statementResult.beforeFirst(); // not rs.first() because the rs.next() below will move on, missing the first element
            }
            // End solution from http://www.coderanch.com/t/303346/JDBC/java/find-number-rows-resultset

            Result = new String[rowcount];

            int currentCounter = 0;

            while (statementResult.next()) // While there are rows to process
            {
                // Get the first cell in the current row
                Result[currentCounter] = statementResult.getString(1);
                currentCounter++;

            }
            // Close the link to the database when finished
        } catch (Exception e) {
            System.err.println("Select problems with SQL " + SQLquery);
            System.err.println("Select problem is " + e.getMessage());
            Result = new String[0]; //Need to setup result array to avoid initialisation error
            writeLogSQL(SQLquery + " caused error " + e.getMessage());
        }
        writeLogSQL(SQLquery + "worked ");
        return Result;
    } // End Select
    public boolean emailExists(String email) {
        String umailString = "@umail.ucc.ie";
        int umailIndex = email.indexOf(umailString);
        String comparison = "";
        String comparedTo = "";
        if(umailIndex != -1) {
            // If false the email the user supplied is a umail email, which should be compared with the user ID in the DB
            // Get the user ID from the umail email address and store it in comparison string
            comparison = email.substring(0, umailIndex );
            comparedTo = "Student_or_staff_number";
        } else {
            // The email the user supplied is a non-umail email
            comparison = email;
            comparedTo = "Alternate_email";
        }
        String SQLQuery = ("SELECT * FROM User_details WHERE "
                    + comparedTo + " = '" + comparison + "';");
        // Setup database connection details
        try {
            // Setup statement object
            statementObject = connectionObject.createStatement();
            // execute SQL commands to query data
            ResultSet resultSet = statementObject.executeQuery(SQLQuery);
            writeLogSQL(SQLQuery +" Executed OK");
            
            if (resultSet.next()) {
            // If true, the email/user ID does exist in the database
                return true;
            } else {
            // If false, the email/user ID does not exist in the database
                return false;
            }
        }
            
        catch (SQLException exceptionObject) {
            System.out.println(SQLQuery +" - Problem is : " + exceptionObject.getMessage());
            writeLogSQL(SQLQuery + " caused error " + exceptionObject.getMessage());
            return false;
            }
        }
    
    public String recoverPassword(String email) {
        String umailString = "@umail.ucc.ie";
        int umailIndex = email.indexOf(umailString);
        String comparison = "";
        String comparedTo = "";
        if(umailIndex != -1) {
            // If false the email the user supplied is a umail email, which should be compared with the user ID in the DB
            // Get the user ID from the umail email address and store it in comparison string
            comparison = email.substring(0, umailIndex );
            comparedTo = "Student_or_staff_number";
        } else {
            // The email the user supplied is a non-umail email
            comparison = email;
            comparedTo = "Alternate_email";
        }
        String SQLQuery = ("SELECT * FROM User_details WHERE "
                    + comparedTo + " = '" + comparison + "';");
        // Setup database connection details
        try {
            // Setup statement object
            statementObject = connectionObject.createStatement();
            // execute SQL commands to query data
            ResultSet resultSet = statementObject.executeQuery(SQLQuery);
            writeLogSQL(SQLQuery +" Executed OK");
            String password = resultSet.getString("User_password");
            
            return password;
        }
            
        catch (SQLException exceptionObject) {
            System.out.println(SQLQuery +" - Problem is : " + exceptionObject.getMessage());
            writeLogSQL(SQLQuery + " caused error " + exceptionObject.getMessage());
            return "";
            }
        }
    
    
    
    
    public void writeLogSQL(String message) {
        PrintStream output;
        try {
            output = new PrintStream(new FileOutputStream("sql-logfile.txt", true));
            output.println(new java.util.Date() + " " + message);
            System.out.println(new java.util.Date() + " " + message);
            output.close();
        } catch (IOException ieo) {
        }
    } // End writeLog
} //End dblib

