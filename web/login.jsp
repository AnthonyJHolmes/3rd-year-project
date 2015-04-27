<%@ page language="java" contentType="text/html; charset=US-ASCII"
         pageEncoding="US-ASCII"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Log In</title>
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
        <%

        //allow access only if session exists
            if (session.getAttribute("user") != null) {
                response.sendRedirect("home.jsp");
            }
        %>
        <div class="container">
            <div class="panel panel-info">
                <div class="panel-heading">
                    <h3 class="panel-title">Sign In</h3>
                </div>
                <div class="panel-body">
                   
                    <form action="Login" method="post" role="form" name="login" >
                        <!-- A Simple log in form which takes in two parameters, the user id and password. -->
                        <div class="form-group">
                            <label for="email">ID Number:</label>
                            
                            <input type="text" name="user" class="form-control" id="email" placeholder="Enter User ID" required>
                           
                        </div>
                        <div class="form-group">
                            <label for="pwd">Password:</label>
                            
                            <input type="password" name="pwd" class="form-control" id="pwd" placeholder="Enter password" required>
                           
                        </div>
                        <div class="checkbox">
                            <label><input type="checkbox"> Remember me</label>
                        </div>
                        <button type="submit" class="btn btn-default" >Submit</button>

                    </form>
                    <form action="checkemail.jsp">
                        <button type="submit" class="btn btn-default" >Forgot Password</button>
                    </form>
                </div>
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
