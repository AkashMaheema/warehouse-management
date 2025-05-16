package com.warehouse.utils;

import jakarta.mail.*;
import jakarta.mail.internet.*;

import java.util.List;
import java.util.Properties;

public class EmailUtil {

    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String SENDER_EMAIL = "arinestwarehouse@gmail.com";
    private static final String SENDER_PASSWORD = "suwd xqby mtjb gksp";

    public static void sendReorderEmail(String recipientEmail, String supplierName, List<String[]> reorderItems) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("Reorder Request");

            StringBuilder emailBody = new StringBuilder();
            emailBody.append("<html><body>");
            emailBody.append("<p>Dear ").append(supplierName).append(",</p>");
            emailBody.append("<p>We would like to place the following reorder:</p>");

            emailBody.append("<table border='1' cellpadding='8' cellspacing='0' style='border-collapse: collapse;'>");
            emailBody.append("<tr><th>Product Name</th><th>Category</th><th>Weight</th><th>Quantity</th></tr>");

            for (String[] item : reorderItems) {
                emailBody.append("<tr>");
                emailBody.append("<td>").append(item[0]).append("</td>");
                emailBody.append("<td>").append(item[1]).append("</td>");
                emailBody.append("<td>").append(item[2]).append("</td>");
                emailBody.append("<td>").append(item[3]).append("</td>");
                emailBody.append("</tr>");
            }

            emailBody.append("</table>");
            emailBody.append("<p>Please confirm the order at your earliest convenience.</p>");
            emailBody.append("<p>Best regards,<br>Warehouse Team</p>");
            emailBody.append("</body></html>");

            message.setContent(emailBody.toString(), "text/html");
            Transport.send(message);

            System.out.println("Email sent to supplier successfully!");

        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
}
