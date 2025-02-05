//package com.licenta.bookverse.config;
//
//import org.springframework.beans.factory.annotation.Value;
//import org.springframework.context.annotation.Bean;
//import org.springframework.context.annotation.Configuration;
//import org.springframework.mail.javamail.JavaMailSender;
//import org.springframework.mail.javamail.JavaMailSenderImpl;
//
//import java.util.Properties;
//
//@Configuration
//public class MailConfig {
//
//    @Value("${spring.mail.host}")
//    private String host;
//
//    @Value("${spring.mail.port}")
//    private int port;
//
//    @Value("${spring.mail.username}")
//    private String username;
//
//    @Value("${spring.mail.password}")
//    private String password;
//
//    @Value("${spring.mail.protocol}")
//    private String protocol;
//
//    @Value("${spring.mail.properties.mail.smtp.auth}")
//    private boolean auth; // Change to boolean
//
//    @Value("${spring.mail.properties.mail.smtp.starttls.enable}")
//    private boolean starttlsEnable; // Change to boolean
//
//    @Bean
//    public JavaMailSender getJavaMailSender() {
//        JavaMailSenderImpl mailSender = new JavaMailSenderImpl();
//        mailSender.setHost(host);
//        mailSender.setPort(port);
//        mailSender.setUsername(username);
//        mailSender.setPassword(password);
//
//        Properties props = mailSender.getJavaMailProperties();
//        props.put("mail.transport.protocol", protocol);
//        props.put("mail.smtp.auth", String.valueOf(auth));
//        props.put("mail.smtp.starttls.enable", String.valueOf(starttlsEnable));
//        props.put("mail.debug", "true"); // Enable for debugging
//
//        return mailSender;
//    }
//}
