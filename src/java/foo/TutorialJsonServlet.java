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
 * Returns all of the tutorials for which  a user is doing
 * @author ajh3
 */
//servlet pattern
@WebServlet(urlPatterns = {"/TutorialJsonServlet"})
public class TutorialJsonServlet extends HttpServlet {
    //database connection variables
    private Statement statementObject;
    private Connection connectionObject;
    private String dbserver;
    private String DSN;
    private String username;
    private String password;
    private boolean setup = false;
    /**
     * Setting up the connection to the server
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
 * Log file creation and maintainance
 * @param message - message to write to log file
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
        //create a new list, set up the session, get the user ID
        List l = new ArrayList();
        HttpSession session = request.getSession();
        String userID = (String) session.getAttribute("user");
        int ID = Integer.parseInt(userID);
        //get all of the modules that the user is doing
        foo.FetchDBValues fetch = new foo.FetchDBValues();
        //setup("cs1.ucc.ie", "2016_rwh1", "rwh1", "mohxelai");
        setup("mysql89268-UccProject.j.layershift.co.uk","2016_UCC", "root","HMoHCBzrnu");
        String[] arrayOfModules = fetch.fetchModules(ID);
        int x = 0;
        //set up the calendar for reoccurance
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Calendar cal = Calendar.getInstance();
        for (String module : arrayOfModules) {
            CalendarDTO c = new CalendarDTO();
            CalendarDTO d = new CalendarDTO();

            try {
                //for each module get the corresponding tutorial for which they are enrolled in 
                statementObject = connectionObject.createStatement();
                ResultSet rs = statementObject.executeQuery("SELECT id, module_code, start_date, time_start, time_finish, reoccur FROM Modules_and_tutorials"
                        + " WHERE module_code ='" + module + "' AND module_type = 'tutorial';");

                while (rs.next()) {
                    String title = rs.getString("module_code");
                    String date = rs.getString("start_date");
                    String time_start = rs.getString("time_start");
                    String time_finish = rs.getString("time_finish");
                    int id = rs.getInt("id");
                    int reoccur = rs.getInt("reoccur");
                    //store the values to variables
                    if (l.contains(c)) {
                       for (x = 0; x < reoccur; x++) {
                           //reoccur for the number of weeks. 
                            cal.setTime(sdf.parse(date));
                            cal.add(Calendar.DATE, 7);
                            date = sdf.format(cal.getTime());
                            CalendarDTO a = new CalendarDTO();
                            a.setStart(date + " " + time_start);
                            a.setEnd(date + " " + time_finish);
                            a.setTitle(title+ " - tutorial");
                            a.setId(id);
                            //add to list to be sent back
                            l.add(a);
                        }
                    } 
                    else {
                        for (x = 0; x < reoccur; x++) {
                            cal.setTime(sdf.parse(date));
                            cal.add(Calendar.DATE, 7);
                            date = sdf.format(cal.getTime());
                            CalendarDTO a = new CalendarDTO();
                            a.setStart(date + " " + time_start);
                            a.setEnd(date + " " + time_finish);
                            a.setTitle(title+ " - tutorial");
                            a.setId(id);
                            //add to list to be sent back
                            l.add(a);
                        }
                    }

                }

//exception handling
            } catch (SQLException e) {
                System.err.println(e);
            } catch (ParseException ex) {
                Logger.getLogger(TutorialJsonServlet.class.getName()).log(Level.SEVERE, null, ex);
            }



        }

//return the list as a JSON format to the calendar
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
