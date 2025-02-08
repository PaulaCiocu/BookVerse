package com.licenta.bookverse.service;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor()
public class EmailService {

    @Autowired
    private final JavaMailSender mailSender;


    public void sendEmail(String to, String subject, String message) {
        SimpleMailMessage email = new SimpleMailMessage();
        email.setTo(to);
        email.setSubject(subject);
        email.setText(message);
        mailSender.send(email);
    }

    public void sendPasswordResetEmail(String email, String token) {
        String resetUrl = "http://yourapp.com/reset-password?token=" + token;
        String body = "Hello,\n\nIt looks like you requested a password reset.\n\n"
                + "Please click on the link below to reset your password:\n\n"
                + resetUrl + "\n\nIf you didn't request this change, please ignore this email.\n\n"
                + "Best Regards,\nBookVerse Team";
        sendEmail(email, "Password Reset Request", body);
    }

    public void sendPasswordResetConfirmation(String email) {
        String body = "Your password has been successfully reset. If you did not request this change, please contact support immediately.";
        sendEmail(email, "Password Reset Confirmation", body);
    }

    public void sendRegistrationConfirmationEmail(String email, String token) {
        String confirmationUrl = "http://yourapp.com/confirm-registration?token=" + token;
        String body = "Welcome!\n\nTo complete your registration, please click the following link:\n\n" + confirmationUrl;
        sendEmail(email, "Registration Confirmation", body);
    }

}