<%-- 
    Document   : sendProblem
    Created on : 04-Mar-2015, 10:51:53
    Author     : ajh3
--%>
<%@ page import="java.util.*" %>
<%@ page import="javax.mail.*" %>
<%@ page import="javax.mail.internet.*" %>
<%@ page import="javax.activation.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>JSP JavaMail Example </title>
</head>
<body>

<%
String host = "localhost";
String to = "112322646@umail.ucc.ie";
String from = request.getParameter("fromEmail");
String subject = request.getParameter("problem");
String messageText = request.getParameter("message");
boolean sessionDebug = false;
 //Create some properties and get the default Session.
Properties props = System.getProperties();
props.put("mail.host", host);
props.put("mail.transport.protocol", "smtp");
Session mailSession = Session.getDefaultInstance(props, null);
 
// Set debug on the Session
// Passing false will not echo debug info, and passing True will.
 
mailSession.setDebug(sessionDebug);
 
 //Instantiate a new MimeMessage and fill it with the 
// required information.
 
Message msg = new MimeMessage(mailSession);
msg.setFrom(new InternetAddress(from));
InternetAddress[] address = {new InternetAddress(to)};
msg.setRecipients(Message.RecipientType.TO, address);
msg.setSubject(subject);
msg.setSentDate(new Date());
msg.setText(messageText);
 
// Hand the message to the default transport service
// for delivery.
 
Transport.send(msg);
out.println("Mail was sent to " + to);
out.println(" from " + from);
out.println(" using host " + host + ".");
%>

<footer class="footer">
      <div class="container">
        <p class="text-muted">Copyright notice - Group 6</p>
      </div>
    </footer>
</body>
</html>
