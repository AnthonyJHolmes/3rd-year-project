<%-- 
    Document   : CreateEvent
    Created on : 25-Feb-2015, 14:28:03
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
        <link href="css/multi-select.css" media="screen" rel="stylesheet" type="text/css">
        <!-- Custom Fonts -->
        <link href="font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">

        <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
        <!--[if lt IE 9]>
            <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
            <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
        <![endif]-->
        <title>Create Group</title>
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
                            
                            <form class="form-horizontal" method="POST" action="addGroup.jsp">
                                <fieldset>

                                    <!-- Form to create a group -->
                                    <legend>Create Group</legend>

                                    <!-- give the group a name-->
                                    <div class="form-group">
                                        <label class="col-md-4 control-label" for="group_name">Group Name</label>  
                                        <div class="col-md-5">
                                            <input id="group_name" name="group_name" type="text" placeholder="Please enter a group name" class="form-control input-md" required="">

                                        </div>
                                    </div>
                                    <!-- Seperate user ID's by a space -->
                                    <div class="form-group">
                                        <label class="col-md-4 control-label" for="user_ids">User ID's</label>  
                                        <div class="col-md-8">
                                            <input id="user_ids" name="user_ids" type="text" placeholder="123456789 111111111 222222222" class="form-control input-md" required="">
                                            <span class="help-block">Enter the ID, for each additional ID enter a space in between each ID. </span>  
                                        </div>
                                    </div>

                                    <!-- year of which you are currently in -->
                                    <div class="form-group">
                                        <label class="col-md-4 control-label" for="year">Select current college year - 3 for 3rd year</label>
                                        <div class="col-md-5">
                                            <select id="year" name="year" class="form-control">
                                                <option value="1">1</option>
                                                <option value="2">2</option>
                                                <option value="3">3</option>
                                                <option value="4">4</option>
                                                <option value="5">5</option>
                                            </select>
                                        </div>
                                    </div>

                                    
                                    <div class="form-group">
                                        <label class="col-md-4 control-label" for="submit"></label>
                                        <div class="col-md-4">
                                            <button id="submit" name="submit" class="btn btn-success">Submit</button>
                                        </div>
                                    </div>

                                </fieldset>
                            </form>



                           
                            
                        </div>
                    </div>
                    <!-- /.row -->

                </div>
                <!-- /.container-fluid -->

            </div>
            <!-- /#page-wrapper -->

        </div>
        <!-- /#wrapper -->
<footer class="footer">
      <div class="container">
        <p class="text-muted">Copyright notice - Group 6</p>
      </div>
    </footer>
        

    </body>

</html>
