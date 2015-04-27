<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.sql.Array"%>
<%@page import="java.util.ArrayList"%>
<!DOCTYPE html>
<html lang="en">

    <head>

        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
        <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>
        <title>Dashboard</title>
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
        <link href='css/fullcalendar.css' rel='stylesheet' />
        <link href='css/fullcalendar.print.css' rel='stylesheet' media='print' />
        <script src='lib/moment.min.js'></script>
        <script src='lib/jquery.min.js'></script>
        <script src='lib/fullcalendar.min.js'></script>
        <script>
//the Full calendar
            $(document).ready(function() {

                var today = new Date();
                var dd = today.getDate();
                var mm = today.getMonth() + 1; //January is 0!
                var yyyy = today.getFullYear();

                if (dd < 10) {
                    dd = '0' + dd
                }
                if (mm < 10) {
                    mm = '0' + mm
                }
                today = yyyy + '-' + mm + '-' + dd;//get todays current date.

                $('#calendar').fullCalendar({
                    height: 650,
                    weekends: false,
                    defaultView: 'agendaWeek',//week view
                    minTime: '09:00',//9am
                    maxTime: '21:00',//9pm
                    header: {
                        left: 'prev,next today',
                        center: 'title',
                        right: 'month,agendaWeek,agendaDay'
                    },
                    defaultDate: today,//set the default date to today by using the variable above
                    selectable: false,
                    selectHelper: true,
                    //slotEventOverlap:true,
                    select: function(start, end) {
                        var title = prompt('Event Title:');
                        var eventData;
                        if (title) {
                            eventData = {
                                title: title,
                                start: start,
                                end: end
                            };
                            $('#calendar').fullCalendar('renderEvent', eventData, true); // stick? = true
                        }
                        $('#calendar').fullCalendar('unselect');
                    },
                    editable: false,
                    eventLimit: true, // allow "more" link when too many events


                    eventSources: [ // the three servlets are colour coded so you know which is which
                        {
                            url: '/CalendarJsonServlet',
                            color: 'green'
                        },
                        {
                            url: '/TutorialJsonServlet',
                            color: 'blue'
                        },
                        {
                            url: '/UsereventsJsonServlet',
                            color: 'red'
                        }
                    ]        

                });
            });

        </script>
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
                                <small>Timetable</small>
                            </h1>
                            <div id="calendar"></div>
                            <input type="hidden" name="user" value="<%=userID%>"/>
                            

                            <!-- need to encode all the URLs where we want session information to be passed -->
                                
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
