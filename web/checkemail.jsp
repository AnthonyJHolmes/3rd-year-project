<jsp:useBean id="emailHandler" class="passwordrecovery.RecoveryEmail" scope="request">
<jsp:setProperty name="emailHandler" property="*"/>
</jsp:useBean>
<% 
    //check to see if an email was entered
    if (emailHandler.getEmail()  == null || emailHandler.getEmail() == "") {
    //if not, show an error message
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Forgotten Password</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>

    <script>
        // Error message
        alert("Please enter an email address");		
    </script>
</head>
<body>
    <div class="container">
        <h3>Forgotten Password</h3>
            <form action="checkemail.jsp" role="form" method="get" name="recoveryForm">
                <div class="form-group">
			        <label for="email">Enter your email:</label>
                    <input class="form-control" id ="email" type="email" name="email" placeholder="johnmurphy@gmail.com">
                </div>
				<button type="submit" class="btn btn-default" >Submit</button>
            </form>
    </div>
</body>
</html>

<%
   } else {
   // If a correct email was entered
   // Set up the bean to setup the connection to the database
        foo.DatabaseClass db = new foo.DatabaseClass();
        //db.setup("cs1.ucc.ie","2016_rwh1", "rwh1","mohxelai");
        db.setup("mysql89268-UccProject.j.layershift.co.uk","2016_UCC", "root","HMoHCBzrnu"); 
        // Check to see if the email exists in the database
        if (db.emailExists(emailHandler.getEmail())) {
        //If it does, send an email to it with its password and display a confirmation page.    
%>
            <jsp:forward page="sendemail.jsp"/>
        
<%
        } else {
%>

            <html lang="en">
            <head>
                <title>Forgotten Password</title>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
                <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
                <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>

                <script>
                // Error message
                alert("An account associated with that email does not exist");		
                </script>
            </head>
            <body>
                <div class="container">
                    <h3>Forgotten Password</h3>
                    <form action="checkemail.jsp" role="form" method="get" name="recoveryForm">
                        <div class="form-group">
	                    <label for="email">Enter your email:</label>
                            <input class="form-control" id ="email" type="email" name="email" class="form-control" placeholder="johnmurphy@gmail.com">
                        </div>
		        <button type="submit" class="btn btn-default" >Submit</button>
                    </form>
                </div>
            </body>
            </html>
<%
        }    
    }
%>