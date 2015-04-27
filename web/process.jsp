<%@ page import="java.util.ResourceBundle" %>
<% 
    //getting the stuff out of the forms.properties file and saving
    //its a safer way in saving stuff and links
    ResourceBundle resource = ResourceBundle.getBundle("foo.forms");
    //setting up the the bean to handle the form
    //setting the property to all to handle all the stuff
%>
<jsp:useBean id="formHandler" class="foo.Bean" scope="request">
<jsp:setProperty name="formHandler" property="*"/>
</jsp:useBean>
<% 
    //storing the form properties into individual variables
    String success = resource.getString("process.success");
    String retry = resource.getString("process.retry");
    //check to see if all the users submission is correct
   if (formHandler.validate()) {
       //if correct, it was a success...
%>
    <jsp:forward page="<%=success%>"/>
<%
   }  else {
       //or else you failed and must retry again.
%>
    <jsp:forward page="<%=retry%>"/>
<%
   }
%>
