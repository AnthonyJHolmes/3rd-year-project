<jsp:useBean id="formHandler" class="foo.Bean" scope="request"/>
<html> 
    <head>
        <title>First Registration page</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- The links are the paths to where jquery and bootstrap libraries  -->
        <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
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
                    <h3 class="panel-title">Register</h3>
                </div>
                <div class="panel-body">
                    <form action="process.jsp" method=post>
                        <!-- If the user didn't complete the form properly they are sent here with error handling messages for context sensitive help -->
                        <div class="form-group">
                            <label for="inputdefault">User ID</label>
                            <input class="form-control" id="inputdefault" type="text" name="UID" value="<%=formHandler.getUID()%>" >
                            <%=formHandler.getErrorMsg("User ID")%>
                        </div>
                        <div class="form-group">
                            <label for="inputdefault">First Name</label>
                            <input class="form-control" id="inputdefault" type="text" name="firstName" value="<%=formHandler.getFirstName()%>" >
                            <%=formHandler.getErrorMsg("firstName")%>
                              </div>
                        <div class="form-group">
                            <label for="inputdefault">Last Name</label>
                            <input class="form-control" id="inputdefault" type="text" name="lastName" value="<%=formHandler.getLastName()%>" >
                                  <%=formHandler.getErrorMsg("lastName")%>
                        </div>
                        <div class="form-group">
                            <label for="email">Alternate Email:</label>
                            <input type="text" name="email" class="form-control" value="<%=formHandler.getEmail()%>" id="email" >
                            <%=formHandler.getErrorMsg("email")%>
                        </div>
                        <div class="form-group">
                            <label for="pwd">Password:</label>
                            <input type="password" name="password1" class="form-control" id="pwd" value="<%=formHandler.getPassword1()%>" >
                            <%=formHandler.getErrorMsg("password1")%>
                        </div>
                        <div class="form-group">
                            <label for="pwd">Re-Enter Password:</label>
                            <input type="password" name="password2" class="form-control" id="pwd" value="<%=formHandler.getPassword2()%>">
                            <%=formHandler.getErrorMsg("password2")%>
                        </div>

                        <p><input type="submit" value="Submit"> <input type="reset" value="Reset"></p>

                    </form>
                </div>
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
