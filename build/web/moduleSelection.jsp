<%-- 
    Document   : moduleSelection
    Created on : 19-Feb-2015, 14:05:50
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
             //db.setup("cs1.ucc.ie","2016_rwh1", "rwh1","mohxelai");
             db.setup("mysql89268-UccProject.j.layershift.co.uk","2016_UCC", "root","HMoHCBzrnu");
        //getting the attributes from the bean
        
        int Student_ID = (Integer) session.getAttribute("UserID");
        String stream = request.getParameter("stream");
        String course_code =(String) session.getAttribute("course_code");
        String year = (String) session.getAttribute("year");
        String[] modules;
        db.Insert("INSERT INTO Student_education"
                + "(Student_ID,"
                + "Course_code,"
                + "Stream,"
                + "Current_year)"
                + "VALUES("
                + "'"+Student_ID+"',"
                + "'"+course_code+"',"
                + "'"+stream+"',"
                + "'"+year+"');");
        //get the stream student ID, course code and year
        //insert into student education table
        //get all the modules related to the stream selected with the same year
        //
        modules=db.SelectColumn("SELECT DISTINCT module_code FROM Modules_and_tutorials WHERE Stream = '"+stream+"' AND year ='"+year+"' AND course_code = '"+course_code+"' ORDER BY module_code ASC;");
            %>
          <div class="container">
            <div class="panel panel-info">
                <div class="panel-heading">
                    <h3 class="panel-title">Stream selection was successful.</h3>
                </div>
                <div class="panel-body">
                    <form action="RegistrationSuccessful.jsp">
                        <div class="form-group">
                            <label>Select Modules to be scheduled under:</label>
                       <%for(String module :modules){%>
                       <label class="checkbox-inline">
                         <input type="checkbox" name="module" value="<%=module%>"><%=module%> 
                       </label>
                       <%}%>
                       <br>
                       <button type="submit" class="btn btn-default">Submit </button>
                        </div> 
                    </form>
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
