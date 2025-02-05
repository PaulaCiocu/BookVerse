package com.licenta.bookverse.service;

import com.licenta.bookverse.dto.LoginDTO;
import com.licenta.bookverse.dto.LoginResponse;
import com.licenta.bookverse.dto.RegistrationDTO;
import com.licenta.bookverse.entity.Person;
import com.licenta.bookverse.exception.EmailAlreadyExistsException;
import com.licenta.bookverse.exception.PasswordMismatchException;
import com.licenta.bookverse.exception.UsernameAlreadyExistsException;
import com.licenta.bookverse.exception.WeakPasswordException;
import com.licenta.bookverse.repository.PersonRepository;

import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

@Service
@AllArgsConstructor
public class AuthenticationService {
    private final PersonRepository personRepository;
    private final PasswordEncoder passwordEncoder;
    private final AuthenticationManager authenticationManager;
    private final PersonService personService;
    private final JwtService jwtService;
    private final EmailService emailService;
    private final JavaMailSender mailSender;


    public Person authenticate(LoginDTO input) {
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        input.getEmail(),
                        input.getPassword()
                )
        );

        Person person = personRepository.findByEmail(input.getEmail())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid credentials"));

        if (!person.isConfirmed()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Email not confirmed. Please check your inbox.");
        }

        return person;
    }

    public String registerPerson(RegistrationDTO registrationDTO) {
        //Password complexity validation
        validatePassword(registrationDTO.getPassword());

        if(!registrationDTO.getPassword().equals(registrationDTO.getConfirmPassword())) {
            throw new PasswordMismatchException();
        }

        if(personRepository.findByUsername(registrationDTO.getUsername()).isPresent()){
            throw new UsernameAlreadyExistsException();
        }
        if(personRepository.findByEmail(registrationDTO.getEmail()).isPresent()){
            throw new EmailAlreadyExistsException();
        }
        String encodedPassword = passwordEncoder.encode(registrationDTO.getPassword());
        Person person = new Person();
        person.setFullName(registrationDTO.getFullName());
        person.setUsername(registrationDTO.getUsername());
        person.setPassword(encodedPassword);
        person.setEmail(registrationDTO.getEmail());
        personRepository.save(person);

        String token = jwtService.generateRegistrationConfirmationToken(registrationDTO.getEmail());
        System.out.println(token);
        sendRegistrationConfirmationEmail(registrationDTO.getEmail(), token);
        System.out.println("Email sent!");
        return token;
    }

    public LoginResponse handleForgotPassword(String email) {
        boolean emailExists = personService.checkIfEmailExists(email);
        if (!emailExists) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Email not found");
        }

        String token = jwtService.generatePasswordResetToken(email);
        System.out.println("Generated token: " + token);

        LoginResponse loginResponse = new LoginResponse();
        loginResponse.setToken(token);
        loginResponse.setExpiresIn(jwtService.getExpirationTime());

        sendPasswordResetEmail(email, token);
        return loginResponse;
    }

    public void sendPasswordResetEmail(String email, String token) {
        String resetUrl = "http://yourapp.com/reset-password?token=" + token;

        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(email);
        message.setSubject("Password Reset Request");
        message.setText("Hello,\n\nIt looks like you requested a password reset.\n\nPlease click on the link below to reset your password:\n\n" + resetUrl +
                "\n\nIf you didn't request this change, please ignore this email.\n\n"+ "Best Regards,\nnBookVerse Team");

        mailSender.send(message);
    }

    public void validatePassword(String password) {
        String passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$";

        if (!password.matches(passwordRegex)) {
            throw new WeakPasswordException();
        }
    }

    public void validatePasswordMismatch(String password, String confirmPassword) {
        if (!password.equals(confirmPassword)) {
            throw new PasswordMismatchException();
        }
    }

    public void sendPasswordResetConfirmation(String email) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(email);
        message.setSubject("Password Reset Confirmation");
        message.setText("Your password has been successfully reset. If you did not request this change, please contact support immediately.");
        mailSender.send(message);
    }

    public void sendRegistrationConfirmationEmail(String email, String token) {
        String confirmationUrl = "http://yourapp.com/confirm-registration?token=" + token;

        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(email);
        message.setSubject("Registration Confirmation");
        message.setText("Welcome! To complete your registration, please click the following link: " + confirmationUrl);

        mailSender.send(message);
    }





}
