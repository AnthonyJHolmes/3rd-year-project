//Guidelines taken from http://crunchify.com/java-mailapi-example-send-an-email-via-gmail-smtp/
package passwordrecovery;

import java.util.*;
import javax.mail.*;
import javax.mail.internet.*;
import javax.activation.*;

public class SendEmail
{
    static Properties mailServerProperties;
    static Session getMailSession;
    static MimeMessage generateMailMessage;

    /**
     * @author Christopher Gunkel 112489042
     * @param email The email of the user
     * @param password The password that will be recovered from the users account
     * @throws AddressException
     * @throws MessagingException 
     */
    public static void generateAndSendEmail(String email, String password) throws AddressException, MessagingException {
	
        //set up the properties of the mail server
        mailServerProperties = System.getProperties();
	mailServerProperties.put("mail.smtp.port", "587");
	mailServerProperties.put("mail.smtp.auth", "true");
	mailServerProperties.put("mail.smtp.starttls.enable", "true");
 	
        //set up the session and create the body of the email
	getMailSession = Session.getDefaultInstance(mailServerProperties, null);
	generateMailMessage = new MimeMessage(getMailSession);
	generateMailMessage.addRecipient(Message.RecipientType.TO, new InternetAddress(email));
	generateMailMessage.setSubject("Password Recovery");
	String emailBody = "This email was automatically sent because the password associated with this email on the UCC Timetable Scheduler was requested." 
            + "<br>Your password is <strong>" + password + "</strong>"
            + "<br><br> Regards, <br>UCC System Administrator";
	generateMailMessage.setContent(emailBody, "text/html");
 		
	Transport transport = getMailSession.getTransport("smtp");
		
	// The username and password of the gmail account used to send out the emails.
	transport.connect("smtp.gmail.com", "cs3305group6", "pwrecovery");
        // Send the message to the recipienct
	transport.sendMessage(generateMailMessage, generateMailMessage.getAllRecipients());
	transport.close();
    }
}