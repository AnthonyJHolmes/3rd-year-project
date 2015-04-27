<%@page import="passwordrecovery.RecoveryEmail, passwordrecovery.SendEmail, foo.DatabaseClass"%>
<%
    passwordrecovery.RecoveryEmail recoveryEmail = (passwordrecovery.RecoveryEmail) request.getAttribute("emailHandler");
    String email = recoveryEmail.getEmail();
    foo.DatabaseClass db = new foo.DatabaseClass();
    db.setup("cs1.ucc.ie","2016_rwh1", "rwh1","mohxelai");
    // Check to see if the email exists in the database
    String password = db.recoverPassword(email);
    SendEmail.generateAndSendEmail(email, password);
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

</head>
<body>
    <div class="container">
         <h3>Forgotten Password</h3>
        <p>Your password has been sent to <strong><jsp:getProperty name="emailHandler" property="email"/></strong>. Please check your email.</p>
    </div>
</body>
</html>