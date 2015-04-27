<%-- 
    Document   : register
    Created on : 10-Feb-2015, 17:02:36
    Author     : Anthony
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <title>First Registration page</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- The links are the paths to where jquery and bootstrap libraries  -->
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
        <script>
            function validateForm() {
//done by Calvin Freeman
//array of error messages
                var errorArray = ["User ID must be filled out", "First Name must be filled out", "Last Name must be filled out",
                    "Alternate email must be filled out", "Password must be filled out", "Re-enter password must be filled out"];

                if (errorArray != null) {
                    var uid = document.forms["myForm"]["UID"].value;
                    if (uid == null || uid == "") {
                        alert(errorArray[0]);
                    }

                    var fname = document.forms["myForm"]["firstName"].value;
                    if (fname == null || fname == "") {
                        alert(errorArray[1]);
                    }

                    var lname = document.forms["myForm"]["lastName"].value;
                    if (lname == null || lname == "") {
                        alert(errorArray[2]);
                    }

                    var email = document.forms["myForm"]["email"].value;
                    if (email == null || email == "") {
                        alert(errorArray[3]);
                    }

                    var pwd1 = document.forms["myForm"]["password1"].value;
                    if (pwd1 == null || pwd1 == "") {
                        alert(errorArray[4]);
                    }

                    var pwd2 = document.forms["myForm"]["password2"].value;
                    if (pwd2 == null || pwd2 == "") {
                        alert(errorArray[5]);
                    }
                    return false;
                }
            }
        </script>



    </head>
    <body onload="set_style_from_cookie()">
        <div class="container">
            <div class="panel panel-info">
                <div class="panel-heading">
                    <h3 class="panel-title">Register</h3>
                </div>
                <div class="panel-body">
                    <!-- Post for the form because of highly sensitive data being transmitted across
                    Validate the form on submission  
                    Takes in the general user information                                        --> 
                    <form role="form" action="process.jsp" method="post" name="myForm" onsubmit="validateForm()">
                        <div class="form-group">
                            <label for="inputdefault">User ID</label>
                            <input class="form-control" id="inputdefault" type="text" name="UID" value="" placeholder="123456789">
                              </div>
                        <div class="form-group">
                            <label for="inputdefault">First Name</label>
                            <input class="form-control" id="inputdefault" type="text" name="firstName" value="" placeholder="John">
                                  </div>
                        <div class="form-group">
                            <label for="inputdefault">Last Name</label>
                            <input class="form-control" id="inputdefault" type="text" name="lastName" value="" placeholder="Murphy">
                                  </div>
                        <div class ="form-group">
                            <label for="user_type">Select your role in the college</label>
                            <select class="form-control" name="user_type">
                                <option value="student">Student</option>
                                <option value="lecturer">Lecturer</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="email">Alternate Email:</label>
                            <input type="text" name="email" class="form-control" id="email" placeholder="Enter alternate email">
                        </div>
                        <div class="form-group">
                            <label for="pwd">Password:</label>
                            <input type="password" name="password1" class="form-control" id="pwd" placeholder="Enter password">
                        </div>
                        <div class="form-group">
                            <label for="pwd">Re-Enter Password:</label>
                            <input type="password" name="password2" class="form-control" id="pwd" placeholder="Enter password">
                        </div>
                        <button type="submit" class="btn btn-default" >Submit Details</button>
                    </form>
                </div>
            </div>

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

