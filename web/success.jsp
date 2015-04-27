<%@page import="foo.Bean"%>
<jsp:useBean id="formHandler" class="foo.Bean" scope="request"/>
<html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" title="bootstrap">
  <link rel="stylesheet" type="text/css" title="alternate" href="css/alternate.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
        <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>
        <script>
            // *** TO BE CUSTOMISED ***

var style_cookie_name = "style" ;
var style_cookie_duration = 30 ;

// *** END OF CUSTOMISABLE SECTION ***
// You do not need to customise anything below this line

function switch_style ( css_title )
{
// You may use this script on your site free of charge provided
// you do not remove this notice or the URL below. Script from
// http://www.thesitewizard.com/javascripts/change-style-sheets.shtml
  var i, link_tag ;
  for (i = 0, link_tag = document.getElementsByTagName("link") ;
    i < link_tag.length ; i++ ) {
    if ((link_tag[i].rel.indexOf( "stylesheet" ) != -1) &&
      link_tag[i].title) {
      link_tag[i].disabled = true ;
      if (link_tag[i].title == css_title) {
        link_tag[i].disabled = false ;
      }
    }
    set_cookie( style_cookie_name, css_title,
      style_cookie_duration );
  }
}
function set_style_from_cookie()
{
  var css_title = get_cookie( style_cookie_name );
  if (css_title.length) {
    switch_style( css_title );
  }
}
function set_cookie ( cookie_name, cookie_value,
    lifespan_in_days, valid_domain )
{
    // http://www.thesitewizard.com/javascripts/cookies.shtml
    var domain_string = valid_domain ?
                       ("; domain=" + valid_domain) : '' ;
    document.cookie = cookie_name +
                       "=" + encodeURIComponent( cookie_value ) +
                       "; max-age=" + 60 * 60 *
                       24 * lifespan_in_days +
                       "; path=/" + domain_string ;
}
function get_cookie ( cookie_name )
{
    // http://www.thesitewizard.com/javascripts/cookies.shtml
    var cookie_string = document.cookie ;
    if (cookie_string.length != 0) {
        var cookie_value = cookie_string.match (
                        '(^|;)[\s]*' +
                        cookie_name +
                        '=([^;]*)' );
        return decodeURIComponent ( cookie_value[2] ) ;
    }
    return '' ;
}

            
            
            
            
            </script>
    
  
    </head>
    <body onload="set_style_from_cookie()">
        <div class="container">
            <div class="panel panel-info">
                <div class="panel-heading">
                    <h3 class="panel-title">User registration successful!</h3>
                </div>
                <div class="panel-body">
                    <p>First Name: 
                       <jsp:getProperty name="formHandler" property="firstName"/>
                    </p>
        
                    <p>Last Name: 
                       <jsp:getProperty name="formHandler" property="lastName"/>
                    </p>

                    <p>Alternate Email: 
                       <jsp:getProperty name="formHandler" property="email"/>
                                </p>
                 </div>
             </div>     
        <%
            //Setting up the bean to setup the connection to the database
            foo.DatabaseQueries details = new foo.DatabaseQueries();
            details.setup();
            foo.DatabaseClass dbclass = new foo.DatabaseClass();
        //getting the attributes from the bean
        Bean f = (Bean) request.getAttribute("formHandler");
        //storing what the user entered into the variables
        
        int userID = f.getUID(); 
        session.setAttribute("UserID", userID);
        String first = f.getFirstName();       
        String last = f.getLastName();
        String email = f.getEmail();
        String password = f.getPassword1();
        String User_type = request.getParameter("user_type");
        String lecturer = "lecturer" ;

        session.setAttribute("user_type",User_type);
        
        //inserting the data into the table
        details.insertNewPerson(userID,first,last,email,User_type, password );
        //if the user is a lecturer
        if(User_type.equals(lecturer)){
                 //dbclass.setup("cs1.ucc.ie","2016_rwh1", "rwh1","mohxelai");
                   dbclass.setup("mysql89268-UccProject.j.layershift.co.uk","2016_UCC", "root","HMoHCBzrnu"); 
                    String[] departments = dbclass.SelectColumn("SELECT DISTINCT Department FROM `Stream` WHERE 1 LIMIT 0 , 30;");
                   
                   %>
                   
                       <div class="panel panel-green">
                            <div class="panel-heading">
                                    <h3 class="panel-title">Select Department for which you work in.</h3>
                            </div>
                            <div class="panel-body">       
                                 <form action="successtwo.jsp">
                                    <div class="form-group">
                                         <select class="form-control" name="department_ID">
                                             <%for(String department: departments){ %>
                                               <option value="<%=department%>"><%=department%></option> 
                                             <%}%>
                                         </select>
                                         <button type="submit" class="btn btn-default">Submit </button>
                                    </div>
                                </form>
                            </div>
                       </div>       
                   <%
                }
        else{
            //you must be a student otherwise
                dbclass.setup("mysql89268-UccProject.j.layershift.co.uk","2016_UCC", "root","HMoHCBzrnu");
                //get all of the course codes.
                    String[] course_codes = dbclass.SelectColumn("SELECT DISTINCT Course_code FROM Stream ORDER BY Course_code ASC;");
                    
                    %>
                    
                       <div class="panel panel-info">
                        <div class="panel-heading">
                                <h3 class="panel-title">Select the course and year for which you are in.</h3>
                        </div>
                           
                           <div class="panel-body">
                                <form action="successtwo.jsp" role="form">
                                    <div class="form-group">
                                     <label>Select Course code</label> 
                                     <select class="form-control" name="course_code">
                                         <%for(String course_code: course_codes){%>
                                           <option value="<%=course_code%>"><%=course_code%></option> 
                                            <%}%>
                                    </select><br>
                                    </div>
                                   <div class="form-group">
                                            <label>Select Current college year</label>
                                            <select class="form-control" name="year">
                                                <option value="1">1</option>
                                                <option value="2">2</option>
                                                <option value="3">3</option>
                                                <option value="4">4</option>
                                                <option value="5">5</option>
                                            </select>
                                        </div>
                                   <button type="submit" class="btn btn-default">Submit </button>
                                   </form>
                           </div>
                       </div>
                 <%}%>
                 
        </div>
                 <footer class="footer">
      <div class="container">
        <p class="text-muted">Copyright notice - Group 6</p>
        <input type="submit" onclick="switch_style('bootstrap');return false;" name="theme" value="Default Bootstrap Style" id="blue">
                        <input type="submit" onclick="switch_style('alternate');return false;" name="theme" value="Alternate Style" id="pink">
      </div>
    </footer>
    </body>
</html>
