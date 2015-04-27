<%-- 
    Document   : successtwo
    Created on : 16-Feb-2015, 17:27:55
    Author     : ajh3
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
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

            var style_cookie_name = "style";
            var style_cookie_duration = 30;

// *** END OF CUSTOMISABLE SECTION ***
// You do not need to customise anything below this line

            function switch_style(css_title)
            {
// You may use this script on your site free of charge provided
// you do not remove this notice or the URL below. Script from
// http://www.thesitewizard.com/javascripts/change-style-sheets.shtml
                var i, link_tag;
                for (i = 0, link_tag = document.getElementsByTagName("link");
                        i < link_tag.length; i++) {
                    if ((link_tag[i].rel.indexOf("stylesheet") != -1) &&
                            link_tag[i].title) {
                        link_tag[i].disabled = true;
                        if (link_tag[i].title == css_title) {
                            link_tag[i].disabled = false;
                        }
                    }
                    set_cookie(style_cookie_name, css_title,
                            style_cookie_duration);
                }
            }
            function set_style_from_cookie()
            {
                var css_title = get_cookie(style_cookie_name);
                if (css_title.length) {
                    switch_style(css_title);
                }
            }
            function set_cookie(cookie_name, cookie_value,
                    lifespan_in_days, valid_domain)
            {
                // http://www.thesitewizard.com/javascripts/cookies.shtml
                var domain_string = valid_domain ?
                        ("; domain=" + valid_domain) : '';
                document.cookie = cookie_name +
                        "=" + encodeURIComponent(cookie_value) +
                        "; max-age=" + 60 * 60 *
                        24 * lifespan_in_days +
                        "; path=/" + domain_string;
            }
            function get_cookie(cookie_name)
            {
                // http://www.thesitewizard.com/javascripts/cookies.shtml
                var cookie_string = document.cookie;
                if (cookie_string.length != 0) {
                    var cookie_value = cookie_string.match(
                            '(^|;)[\s]*' +
                            cookie_name +
                            '=([^;]*)');
                    return decodeURIComponent(cookie_value[2]);
                }
                return '';
            }





        </script>
        
    </head>
    <body onload="set_style_from_cookie()">
        <div class="container">
            <%
                //Setting up the bean to setup the connection to the database

                foo.DatabaseClass db = new foo.DatabaseClass();
                //db.setup("cs1.ucc.ie","2016_rwh1", "rwh1","mohxelai");
                db.setup("mysql89268-UccProject.j.layershift.co.uk", "2016_UCC", "root", "HMoHCBzrnu");
                //getting the attributes from the bean
                String User_Type = (String) session.getAttribute("user_type");
                String[] streams;
                String lecturer= "lecturer";
                //if the user is a lecturer
                if (User_Type.equals(lecturer)) {
                    String select = request.getParameter("department_ID");
                    //display all the modules a lecturer can do in relation to the department they selected.
                            streams = db.SelectColumn("SELECT DISTINCT module_code FROM Modules_and_tutorials WHERE department = '"+select+"';");%>
                            
                            
                            
                            <div class="panel panel-info">
                <div class="panel-heading">
                    <h3 class="panel-title">Department selection was successful.</h3>
                </div>
                <div class="panel-body">
                    <form action="RegistrationSuccessful.jsp">
                        <input type="hidden" name="department_id" value="<%=select%>">
                        <div class="form-group">
                            <label>Select Modules to be scheduled under:</label>
                       <%//output the modules
                    for(String module :streams){%>
                       <label class="checkbox-inline">
                         <input type="checkbox" name="module" value="<%=module%>"><%=module%> 
                       </label>
                       <%}%>
                       <br>
                       <button type="submit" class="btn btn-default">Submit </button>
                        </div> 
                    </form>
                 </div>
             </div>   <%
                        
                }
                else{
                    //setting up the database
                    //get all of the parameters a student entered previously
                foo.DatabaseQueries query = new foo.DatabaseQueries();
                String year = request.getParameter("year");
                session.setAttribute("year", year);
                int yearOfCollege = (Integer.parseInt(year));
                String Course_Code = request.getParameter("course_code");
                session.setAttribute("course_code", Course_Code);
                int userID = (Integer) session.getAttribute("UserID");
                query.setup();
                //insert what the user entered previously
                query.insertIntoGroup(Course_Code, userID, yearOfCollege);
                //get the information of the different streams a student can do from the course code they selected.
                streams = db.SelectColumn("SELECT DISTINCT Stream FROM Modules_and_tutorials WHERE course_code = '" + Course_Code + "' AND year = " + year + ";");
            %>

            <div class="panel panel-info">
                <div class="panel-heading">
                    <h3 class="panel-title">Course and year selection was successful.</h3>
                </div>
                <div class="panel-body">
                    <form action="moduleSelection.jsp">
                        <div class="form-group">
                            <select name="stream" class="form-control">
                                <%for (String stream : streams) {%>
                                <option value="<%=stream%>"><%=stream%></option> 
                                <%}%>
                            </select><br>
                            
                        </div>
                            <button type="submit" class="btn btn-success">Submit </button>
                    </form>
                </div>
            </div>   
            <% }%>

        </div>
        <footer class="footer">
            <div class="container">
                <p class="text-muted">Copyright notice - Group 6</p>
                <input type="submit" onclick="switch_style('bootstrap');
                return false;" name="theme" value="Default Bootstrap Style" id="blue">
                <input type="submit" onclick="switch_style('alternate');
                return false;" name="theme" value="Alternate Style" id="pink">
            </div>
        </footer>
    </body>
</html>
