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
 * Get the users personal events
 * @author ajh3
 */
@WebServlet(urlPatterns = {"/UsereventsJsonServlet"})
public class UsereventsJsonServlet extends HttpServlet {
//database connection variables
    private Statement statementObject;
    private Connection connectionObject;
    private String dbserver;
    private String DSN;
    private String username;
    private String password;
    private boolean setup = false;
/**
 * Set up the connection to the database
 * @param dbserver
 * @param DSN
 * @param username
 * @param password
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
 * Log file used for maintainance
 * @param message of success or failure of connections to the database
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
        //new arraylist, set up the session, get the users ID
        List l = new ArrayList();
        HttpSession session = request.getSession();
        String userID = (String) session.getAttribute("user");
        //setup("cs1.ucc.ie", "2016_rwh1", "rwh1", "mohxelai");
        //connect to Database
        setup("mysql89268-UccProject.j.layershift.co.uk","2016_UCC", "root","HMoHCBzrnu");
        try {
            //Get all of the personal events that the user is currently doing
            statementObject = connectionObject.createStatement();
            ResultSet rs = statementObject.executeQuery("SELECT Date, Time_start, Time_finish, Description FROM User_events"
                    + " WHERE Student_or_staff_number = " + userID + ";");

            while (rs.next()) {
                //while there is more than one personal event add them to the list
                String description = rs.getString("Description");
                String date = rs.getString("Date");
                String time_start = rs.getString("Time_start");
                String time_finish = rs.getString("Time_finish");
                CalendarDTO a = new CalendarDTO();
                a.setStart(date + " " + time_start);
                a.setEnd(date + " " + time_finish);
                a.setTitle(description);
                l.add(a);
               
            }

        } catch (SQLException e) {
            System.err.println(e);
        }
        //send the list back as a JSON format 
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.write(new Gson().toJson(l));

    }

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
