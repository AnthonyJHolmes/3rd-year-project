<%-- 
    Document   : adminHome
    Created on : 1-March - 2015
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
        <!-- Custom CSS -->
        <link href="css/sb-admin.css" rel="stylesheet">

        <!-- Custom Fonts -->
        <link href="font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">

        <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
        <!--[if lt IE 9]>
            <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
            <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
        <![endif]-->
        <title>Admin</title>
        
    </head>
    <body>
        <div id="wrapper">

            <%
//allow access only if session exists
                String user = null;
                String[] userT = null;
                foo.DatabaseQueries details = new foo.DatabaseQueries();
                details.setup();
                
                
                if (session.getAttribute("user") == null) {
                    response.sendRedirect("login.jsp");
                } else {
                    user = (String) session.getAttribute("user");
                    
                }
                String userName = null;
                String sessionID = null;
                Cookie[] cookies = request.getCookies();
                if (cookies != null) {
                    for (Cookie cookie : cookies) {
                        if (cookie.getName().equals("user")) {
                            userName = cookie.getValue();
                        }
                        if (cookie.getName().equals("JSESSIONID")) {
                            sessionID = cookie.getValue();
                        }
                    }
                } else {
                    sessionID = session.getId();
                }
                int userID = Integer.parseInt(userName);
                
               userT= details.getUserType(userID);
            %>
            <!-- Navigation -->
            <nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
                <!-- Brand and toggle get grouped for better mobile display -->
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-ex1-collapse">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                </div>
                <!-- Top Menu Items -->
                <ul class="nav navbar-right top-nav">             
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="fa fa-user"></i> <%=userName%> <b class="caret"></b></a>
                        <ul class="dropdown-menu">
                           <li>
                            <a href="createEvent.jsp"><i class="fa fa-fw fa-edit"></i> Create/Delete Personal event!</a>
                        </li>
                        <li>
                            <a href="groupEvent.jsp"><i class="fa fa-fw fa-edit"></i> Create group event!</a>
                        </li>
                        <li>
                            <a href="createGroup.jsp"><i class="fa fa-fw fa-edit"></i> Create group!</a>
                        </li>
                        <li>
                                <a href="notifications.jsp"><i class="fa fa-fw fa-envelope"></i> Notifications</a>
                        </li>
                        <% 
                            for(String t: userT){
                                String admin ="admin";
                                if(t.equals(admin)){%>
                        <li>
                                <a href="adminHome.jsp"><i class="fa fa-fw fa-edit"></i> Admin Home</a>
                        </li>
                             <%   }
                            }%>
                            <li class="divider"></li>
                            <li>
                                <form action="<%=response.encodeURL("Logout")%>" method="post">
                                   
                                <input type="submit" value="Logout" >
                                </form>
                            </li>
                        </ul>
                    </li>
                </ul>
                <!-- Sidebar Menu Items - These collapse to the responsive navigation menu on small screens -->
                <div class="collapse navbar-collapse navbar-ex1-collapse">
                    <ul class="nav navbar-nav side-nav">
                        <li>
                            <a href="home.jsp"><i class="fa fa-fw fa-dashboard"></i> Dashboard</a>
                        </li>
                        <li>
                            <a href="createEvent.jsp"><i class="fa fa-fw fa-edit"></i> Create/Delete Personal event!</a>
                        </li>
                        <li>
                            <a href="groupEvent.jsp"><i class="fa fa-fw fa-edit"></i> Create group event!</a>
                        </li>
                        <li>
                            <a href="createGroup.jsp"><i class="fa fa-fw fa-edit"></i> Create group!</a>
                        </li>
                        <li>
                                <a href="notifications.jsp"><i class="fa fa-fw fa-envelope"></i> Notifications</a>
                        </li>
                        <% 
                            for(String t: userT){
                                String admin ="admin";
                                if(t.equals(admin)){%>
                        <li>
                                <a href="adminHome.jsp"><i class="fa fa-fw fa-edit"></i> Admin Home</a>
                        </li>
                             <%   }
                            }%>
                    </ul>
                </div>
            </nav>
            <div id="page-wrapper">

                <div class="container-fluid">

                    <!-- Page Heading -->
                    <div class="row">
                        <div class="col-lg-12">
                            <h1 class="page-header">
                                <small>Administrator Home</small>
                            </h1>

                            <!-- Form with that allows the administrator to change the time of a module -->
                            <form class="form-horizontal" action="adminAddEvent.jsp" method="post">
                                <fieldset>

                                    <%
                                    //set up the database
                                        foo.DatabaseClass db = new foo.DatabaseClass();
                                        //db.setup("cs1.ucc.ie", "2016_rwh1", "rwh1", "mohxelai");
                                        db.setup("mysql89268-UccProject.j.layershift.co.uk","2016_UCC", "root","HMoHCBzrnu");
                                        String[] modules = null;
                                        //get all the modules
                                        modules = db.SelectColumn("SELECT DISTINCT module_code FROM Modules_and_tutorials;");
                                    %><div class="form-group">
                                        <label class="col-md-4 control-label" for="module">Select Module</label>
                                        <div class ="col-md-4">
                                            <select class="form-control" name="module"><%
                                        //output all the modules in a drop down list
                                                for (String module : modules) {%>
                                                <option value="<%=module%>"><%=module%></option>   
                                                <%}%>
                                            </select>                  
                                        </div>
                                    </div>
                                            <!-- decide between whether you want to update the lecture or tutorial -->
                                            <div class="form-group">
                                        <label class="col-md-4 control-label" for="moduleType">Module Type</label>
                                        <div class="col-md-4">
                                            <select id="startTime" name="moduleType" class="form-control">
                                                <option value="lecture">Lecture</option>
                                                <option value="tutorial">Tutorial</option>
                                                
                                            </select>
                                        </div>
                                    </div>
                                    <!-- New start time -->
                                    <div class="form-group">
                                        <label class="col-md-4 control-label" for="startTime">New Start Time</label>
                                        <div class="col-md-4">
                                            <select id="startTime" name="startTime" class="form-control">
                                                <option value="09:00:00">09:00:00</option>
                                                <option value="10:00:00">10:00:00</option>
                                                <option value="11:00:00">11:00:00</option>
                                                <option value="12:00:00">12:00:00</option>
                                                <option value="13:00:00">13:00:00</option>
                                                <option value="14:00:00">14:00:00</option>
                                                <option value="15:00:00">15:00:00</option>
                                                <option value="16:00:00">16:00:00</option>
                                                <option value="17:00:00">17:00:00</option>
                                                <option value="18:00:00">18:00:00</option>
                                                <option value="19:00:00">19:00:00</option>
                                                <option value="20:00:00">20:00:00</option>
                                            </select>
                                        </div>
                                    </div>

                                    <!-- New end time -->
                                    <div class="form-group">
                                        <label class="col-md-4 control-label" for="endTime">New End Time</label>
                                        <div class="col-md-4">
                                            <select id="endTime" name="endTime" class="form-control">
                                                <option value="10:00:00">10:00:00</option>
                                                <option value="11:00:00">11:00:00</option>
                                                <option value="12:00:00">12:00:00</option>
                                                <option value="13:00:00">13:00:00</option>
                                                <option value="14:00:00">14:00:00</option>
                                                <option value="15:00:00">15:00:00</option>
                                                <option value="16:00:00">16:00:00</option>
                                                <option value="17:00:00">17:00:00</option>
                                                <option value="18:00:00">18:00:00</option>
                                                <option value="19:00:00">19:00:00</option>
                                                <option value="20:00:00">20:00:00</option>
                                                <option value="21:00:00">21:00:00</option>
                                            </select>
                                        </div>
                                    </div>

                                    <!-- button for submitting -->
                                    <div class="form-group">
                                        <label class="col-md-4 control-label" for="submit"></label>
                                        <div class="col-md-8">
                                            <button id="submit" name="submit" class="btn btn-success">Submit</button>
                                        </div>
                                    </div>

                                </fieldset>
                            </form>
                                            
                            <form class="form-horizontal" action="adminAddUser.jsp" method="post">
                                <fieldset>
                                    <legend>Update User</legend>

                                    <%
                                       //setting up the database again
                                        //db.setup("cs1.ucc.ie", "2016_rwh1", "rwh1", "mohxelai");
                                        db.setup("mysql89268-UccProject.j.layershift.co.uk","2016_UCC", "root","HMoHCBzrnu");
                                        String[] users = null;
                                        //get all of the users
                                        users = db.SelectColumn("SELECT DISTINCT Student_or_staff_number FROM User_details;");
                                    %><div class="form-group">
                                        <label class="col-md-4 control-label" for="user">Select User</label>
                                        <div class ="col-md-4">
                                            <select class="form-control" name="user"><%
                                        //display each user in a drop down list
                                                for (String individualUser : users) {%>
                                                <option value="<%=individualUser%>"><%=individualUser%></option>   
                                                <%}%>
                                            </select>                  
                                        </div>
                                    </div>
                                            
                                   
                                    <!-- The two privileges to upgrade a user too -->
                                    <div class="form-group">
                                        <label class="col-md-4 control-label" for="userType">Make User:</label>
                                        <div class="col-md-4">
                                            <select id="startTime" name="userType" class="form-control">
                                                <option value="lecturer">Lecturer</option>
                                                <option value="admin">Administrator</option>
                                                
                                            </select>
                                        </div>
                                    </div>


                                    
                                    <div class="form-group">
                                        <label class="col-md-4 control-label" for="submit"></label>
                                        <div class="col-md-8">
                                            <button id="submit" name="submit" class="btn btn-success">Submit</button>
                                        </div>
                                    </div>

                                </fieldset>
                            </form>

                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- /#wrapper -->
<footer class="footer">
      <div class="container">
        <p class="text-muted">Copyright notice - Group 6</p>
      </div>
    </footer>
        

    </body>

</html>
