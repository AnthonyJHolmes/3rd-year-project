<%-- 
    Document   : notifications
    Created on : 3rd of march 2015
    Author     : ajh3
--%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.List"%>
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
        <title>Notifications</title>
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
                                <small>Notifications</small>
                            </h1>

                            <%
                                String[] arrayOfNotifications = null;
                                //set up the database
                                foo.DatabaseClass db = new foo.DatabaseClass();
                                //db.setup("cs1.ucc.ie", "2016_rwh1", "rwh1", "mohxelai");
                                db.setup("mysql89268-UccProject.j.layershift.co.uk", "2016_UCC", "root", "HMoHCBzrnu");
                                arrayOfNotifications = db.SelectColumn("SELECT group_name FROM notifications WHERE user_id=" + userID + ";");

                                //each button will delete the notification from the notifications table
                                //the accept button will add the user to the group or acknowledge the event
                                if(arrayOfNotifications.length == 0){
                                    out.println("There are no notifications to show");
                                }

                            %>

                            <% // list out all of the notifications
                                for (String group : arrayOfNotifications) {%>

                            <form action="addNotif.jsp" method="post"> 
                                <div class="panel panel-info">
                                    <div class="panel-heading">
                                        <h3 class="panel-title">Group Invitation</h3>
                                    </div>
                                    <div class="panel-body">
                                        <%out.println("You have been invited to join the group: " + group);%>
                                        <input type="hidden" name="group" value="<%=group%>"/>
                                        <div class="form-group">
                                            <label class="col-md-4 control-label" for="accept"></label>
                                            <div class="col-md-8">
                                                <button id="button1id" name="accept" class="btn btn-success">Accept</button>
                                                <button id="button2id" name="deny" class="btn btn-danger">Deny</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </form>

                            <%}%>

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