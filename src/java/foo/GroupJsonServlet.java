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
 * This is a combination of modules, tutorials and personal events for all users within a group.
 * This servlet is used to send back  a JSON format of all of the events to the full calendar
 * @author ajh3
 */
@WebServlet(urlPatterns = {"/GroupJsonServlet"})
public class GroupJsonServlet extends HttpServlet {
//database variables
    private Statement statementObject;
    private Connection connectionObject;
    private String dbserver;
    private String DSN;
    private String username;
    private String password;
    private boolean setup = false;
/**
 * Setting up the connection to the database
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
 * @param message for error or success of queries to the database
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
        //Create a new array list, Set up the session and retrieve the group that was selected.
        List listOfEvents = new ArrayList();
        HttpSession session = request.getSession();
        String groupName = (String) session.getAttribute("groupSelected");
        //Because i have queries in different files ( my mistake) I need to set up multi connections.
        //setup("cs1.ucc.ie", "2016_rwh1", "rwh1", "mohxelai");
        setup("mysql89268-UccProject.j.layershift.co.uk","2016_UCC", "root","HMoHCBzrnu");
        foo.DatabaseClass db = new foo.DatabaseClass();
        //db.setup("cs1.ucc.ie", "2016_rwh1", "rwh1", "mohxelai");
        db.setup("mysql89268-UccProject.j.layershift.co.uk","2016_UCC", "root","HMoHCBzrnu");
        
        foo.FetchDBValues fetch = new foo.FetchDBValues();
        //get the array of users in a group
        String[] users = db.SelectColumn("SELECT ID_number FROM Groups WHERE Group_name = '" + groupName + "';");  
        //for each user
        for (String u : users) {
           
            int user = Integer.parseInt(u);
            //get the modules that they do
            String[] arrayOfModules = fetch.fetchModules(user);
            int x = 0;
            //set up the calendar for the reoccurance
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Calendar cal = Calendar.getInstance();
            for (String module : arrayOfModules) {
                CalendarDTO c = new CalendarDTO();
                CalendarDTO d = new CalendarDTO();

                try {
                    //get their modules dates and times etc.
                    statementObject = connectionObject.createStatement();
                    ResultSet rs = statementObject.executeQuery("SELECT id, module_code, start_date, time_start, time_finish, reoccur FROM Modules_and_tutorials"
                            + " WHERE module_code ='" + module + "'AND module_type = 'lecture';");

                    while (rs.next()) {
                        String title = rs.getString("module_code");
                        String date = rs.getString("start_date");
                        String time_start = rs.getString("time_start");
                        String time_finish = rs.getString("time_finish");
                        int id = rs.getInt("id");
                        int reoccur = rs.getInt("reoccur");
//add them to the list of events to be sent back
                        if (listOfEvents.contains(c)) {
                            d.setId(id);
                            d.setTitle(title);
                            d.setStart(date + " " + time_start);
                            d.setEnd(date + " " + time_finish);
                            listOfEvents.add(d);
                            //reoccur the events for however many weeks it reoccurs
                            for (x = 0; x < reoccur; x++) {
                                cal.setTime(sdf.parse(date));
                                cal.add(Calendar.DATE, 7);
                                date = sdf.format(cal.getTime());
                                CalendarDTO a = new CalendarDTO();
                                a.setStart(date + " " + time_start);
                                a.setEnd(date + " " + time_finish);
                                a.setTitle(title);
                                a.setId(id);
                                listOfEvents.add(a);
                            }
                        } else {
                            c.setId(id);
                            c.setStart(date + " " + time_start);
                            c.setEnd(date + " " + time_finish);
                            c.setTitle(title);
                            listOfEvents.add(c);
                            for (x = 0; x < reoccur; x++) {
                                cal.setTime(sdf.parse(date));
                                cal.add(Calendar.DATE, 7);
                                date = sdf.format(cal.getTime());
                                CalendarDTO a = new CalendarDTO();
                                a.setStart(date + " " + time_start);
                                a.setEnd(date + " " + time_finish);
                                a.setTitle(title);
                                a.setId(id);
                                listOfEvents.add(a);
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


         x = 0;//used for the comparison of the reoccurance variable
        
        for (String module : arrayOfModules) {
            CalendarDTO c = new CalendarDTO();
            
            try {
                //get the same users tutorials 
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
//add the events of tutorials for the user
                    if (listOfEvents.contains(c)) {
                        //reoccur for the amount of weeks 
                       for (x = 0; x < reoccur; x++) {
                            cal.setTime(sdf.parse(date));
                            cal.add(Calendar.DATE, 7);
                            date = sdf.format(cal.getTime());
                            CalendarDTO a = new CalendarDTO();
                            a.setStart(date + " " + time_start);
                            a.setEnd(date + " " + time_finish);
                            a.setTitle(title+ " - tutorial");
                            a.setId(id);
                            listOfEvents.add(a);//add the events
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
                            listOfEvents.add(a);
                        }
                    }

                }


            } catch (SQLException e) {
                System.err.println(e);
            } catch (ParseException ex) {
                Logger.getLogger(TutorialJsonServlet.class.getName()).log(Level.SEVERE, null, ex);
            }



        }
        try {
            //get the users personal events
            statementObject = connectionObject.createStatement();
            ResultSet rs = statementObject.executeQuery("SELECT Date, Time_start, Time_finish, Description FROM User_events"
                    + " WHERE Student_or_staff_number = " + user + ";");

            while (rs.next()) {
                //while there is more than one event
                String description = rs.getString("Description");
                String date = rs.getString("Date");
                String time_start = rs.getString("Time_start");
                String time_finish = rs.getString("Time_finish");
                CalendarDTO a = new CalendarDTO();
                a.setStart(date + " " + time_start);
                a.setEnd(date + " " + time_finish);
                a.setTitle(description);
                listOfEvents.add(a);
               
            }
//exception handling
        } catch (SQLException e) {
            System.err.println(e);
        }



        }//end of a user
        //return in a JSON format
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.write(new Gson().toJson(listOfEvents));

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
