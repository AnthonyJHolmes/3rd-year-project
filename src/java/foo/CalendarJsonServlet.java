package foo;
import com.google.gson.Gson;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.simple.JSONObject;

/**
 * This Servlet gets all of the users modules from the MySQL database and sends them back into an array
 * the array is processed and each modules relevant date is incrementing by the amount of times it occurs( usually 12)
 * The array of modules and the dates and times are then stored in a new array before being sent to the full calendar in  a JSON format.
 * @author ajh3
 */
//servlet pattern used in the home.jsp file
@WebServlet(urlPatterns = {"/CalendarJsonServlet"})
public class CalendarJsonServlet extends HttpServlet {
//declaring the variables
    private Statement statementObject;
    private Connection connectionObject;
    private String dbserver;
    private String DSN;
    private String username;
    private String password;
    private boolean setup = false;
/**
 * Setting up the database 
 * @param dbserver - Server at which the database is at
 * @param DSN- Database name
 * @param username - username to the database
 * @param password - password for the database
 * @return 
 */
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
/**
 * Writing a log file for errors and successful connections to the database
 * @param message 
 */
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

    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //response.setContentType("text/html;charset=UTF-8");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //Setting up a new array list, Setting up the session and getting the users current session ID
        List l = new ArrayList();
        HttpSession session = request.getSession();
        String userID = (String) session.getAttribute("user");
        int ID = Integer.parseInt(userID);
        //setting up the connection to the database
        foo.FetchDBValues fetch = new foo.FetchDBValues();
        //setup("cs1.ucc.ie", "2016_rwh1", "rwh1", "mohxelai");
        setup("mysql89268-UccProject.j.layershift.co.uk","2016_UCC", "root","HMoHCBzrnu");
        //getting the array of modules
        String[] arrayOfModules = fetch.fetchModules(ID);
        int x = 0;
        //setting up the date format for the reoccurance
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Calendar cal = Calendar.getInstance();
        //for each module that the user does
        for (String module : arrayOfModules) {
            //create two instances
            CalendarDTO c = new CalendarDTO();
            CalendarDTO d = new CalendarDTO();

            try {
                //try the query which gets nearly all of the information from the table
                statementObject = connectionObject.createStatement();
                ResultSet rs = statementObject.executeQuery("SELECT id, module_code, start_date, time_start, time_finish, reoccur FROM Modules_and_tutorials"
                        + " WHERE module_code ='" + module + "'AND module_type = 'lecture';");

                while (rs.next()) {
                    //set the values to variables
                    String title = rs.getString("module_code");
                    String date = rs.getString("start_date");
                    String time_start = rs.getString("time_start");
                    String time_finish = rs.getString("time_finish");
                    int id = rs.getInt("id");
                    int reoccur = rs.getInt("reoccur");
//if the instance c is already in the list l 
                    if (l.contains(c)) {
                        //add the initial module
                        d.setId(id);
                        d.setTitle(title);
                        d.setStart(date + " " + time_start);
                        d.setEnd(date + " " + time_finish);
                        l.add(d);
                        //we need 11 more weeks of modules
                        for (x = 0; x < reoccur; x++) {
                            cal.setTime(sdf.parse(date));
                            //increment the date by 7 days so it will fall on the same time as next week
                            cal.add(Calendar.DATE, 7);
                            date = sdf.format(cal.getTime());
                            //we create a new instance here 
                            CalendarDTO a = new CalendarDTO();
                            //add the information to the list.
                            a.setStart(date + " " + time_start);
                            a.setEnd(date + " " + time_finish);
                            a.setTitle(title);
                            a.setId(id);
                            l.add(a);
                        }
                    } 
                    else {
                        //similar to above but it does not exist already so we need to add it again
                        //we do this for modules that fall twice a week.
                        c.setId(id);
                        c.setStart(date + " " + time_start);
                        c.setEnd(date + " " + time_finish);
                        c.setTitle(title);
                        l.add(c);
                        for (x = 0; x < reoccur; x++) {
                            cal.setTime(sdf.parse(date));
                            cal.add(Calendar.DATE, 7);
                            date = sdf.format(cal.getTime());
                            CalendarDTO a = new CalendarDTO();
                            a.setStart(date + " " + time_start);
                            a.setEnd(date + " " + time_finish);
                            a.setTitle(title);
                            a.setId(id);
                            l.add(a);
                        }
                    }

                }

//exception handling
            } catch (SQLException e) {
                System.err.println(e);
            } catch (ParseException ex) {
                Logger.getLogger(CalendarJsonServlet.class.getName()).log(Level.SEVERE, null, ex);
            }



        }

//return the list to the full calendar in a JSON format
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.write(new Gson().toJson(l));

    }
//not used but required in the file
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}
