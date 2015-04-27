<%-- 
    Document   : RegistrationSuccessful
    Created on : 19-Feb-2015, 14:48:04
    Author     : ajh3
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
        <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>
    </head>
    <body>
        <div class="container">
         <%
            //Setting up the bean to setup the connection to the database
            
             foo.DatabaseClass db = new foo.DatabaseClass();
             // database information
             db.setup("mysql89268-UccProject.j.layershift.co.uk","2016_UCC", "root","HMoHCBzrnu");
             String student = "student";
             
        //getting the attributes from the bean
        String User_Type =(String) session.getAttribute("user_type");
        int Student_ID = (Integer) session.getAttribute("UserID");
        String modules[] = request.getParameterValues("module");
        //if the user is a student
        if(User_Type.equals(student)){
        //make sure they entered modules so it can be inserted.
        if (modules != null && modules.length != 0) {         
            for (int i = 0; i < modules.length; i++) {
               db.Insert("INSERT INTO Student_modules"
                + "(Student_ID,"
                + "Module)"
                + "VALUES("
                + "'"+Student_ID+"',"
                + "'"+modules[i]+"');");
            }
        }
        }else{//person must be a lecturer, also check to see if they entered modules as well. if they have entered modules insert the modules.
            String department = request.getParameter("department_id");
           if (modules != null && modules.length != 0) {         
            for (int i = 0; i < modules.length; i++) {
               db.Insert("INSERT INTO Staff_Lecturing"
                + "(Staff_ID, Department, Teaches_module)"
                + "VALUES('"+Student_ID+"','"+department+"',"+modules[i]+"');");
            }
        } 
        }
         %>
          <div class="container">
            <div class="panel panel-info">
                <div class="panel-heading">
                    <h3 class="panel-title">Successfully updated the database with your module selection.</h3>
                </div>
                <div class="panel-body">
                    <a href="index.html">Log in Page</a>
                </div>
             </div>   
        </div>
          <footer class="footer">
      <div class="container">
        <p class="text-muted">Copyright notice - Group 6</p>
      </div>
    </footer>
    </body>
</html>
