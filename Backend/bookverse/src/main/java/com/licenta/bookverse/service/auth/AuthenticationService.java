package com.licenta.bookverse.service.auth;

import com.licenta.bookverse.dto.auth.LoginDTO;
import com.licenta.bookverse.dto.auth.LoginResponse;
import com.licenta.bookverse.dto.auth.RegistrationDTO;
import com.licenta.bookverse.dto.auth.ResetPasswordRequest;
import com.licenta.bookverse.entity.Achievement;
import com.licenta.bookverse.entity.Person;
import com.licenta.bookverse.exception.*;
import com.licenta.bookverse.exception.email.EmailAlreadyExistsException;
import com.licenta.bookverse.exception.email.EmailNotFound;
import com.licenta.bookverse.exception.password.PasswordMismatchException;
import com.licenta.bookverse.exception.password.WeakPasswordException;
import com.licenta.bookverse.repository.AchievementRepository;
import com.licenta.bookverse.repository.PersonRepository;

import com.licenta.bookverse.service.PersonService;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
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
    @Autowired
    private AchievementRepository achievementRepository;
    private final AuthenticationManager authenticationManager;
    private final PersonService personService;
    private final JwtService jwtService;
    private final EmailService emailService;

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

        if(personRepository.findByEmail(registrationDTO.getEmail()).isPresent()){
            throw new EmailAlreadyExistsException();
        }
        String encodedPassword = passwordEncoder.encode(registrationDTO.getPassword());
        Person person = new Person();
        person.setFullName(registrationDTO.getFullName());
      //  person.setUsername(registrationDTO.getUsername());
        person.setPassword(encodedPassword);
        person.setEmail(registrationDTO.getEmail());
        personRepository.save(person);

        Achievement achievement = new Achievement();
        achievement.setPerson(person);
        achievementRepository.save(achievement);

        String token = jwtService.generateRegistrationConfirmationToken(registrationDTO.getEmail());
        System.out.println(token);
        emailService.sendRegistrationConfirmationEmail(registrationDTO.getEmail(), token);
        System.out.println("Email sent!");
        return token;
    }

    public LoginResponse handleForgotPassword(String email) {
        boolean emailExists = personService.checkIfEmailExists(email);
        if (!emailExists) {
            throw new EmailNotFound();
        }

        String token = jwtService.generatePasswordResetToken(email);
        System.out.println("Generated token: " + token);

        LoginResponse loginResponse = new LoginResponse();
        loginResponse.setToken(token);
        loginResponse.setExpiresIn(jwtService.getExpirationTime());

        emailService.sendPasswordResetEmail(email, token);
        return loginResponse;
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

    public String resetPassword(String token, ResetPasswordRequest request) {
        validatePassword(request.getNewPassword());
        validatePasswordMismatch(request.getNewPassword(), request.getConfirmPassword());
        // Check if the token is valid
        if (!jwtService.isValidPasswordResetToken(token)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid or expired token");
        }
        // Extract email from token
        String email = jwtService.extractEmailFromResetToken(token);
        if (email == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid token data");
        }
        // Update password in the database
        personService.updatePassword(email, request.getNewPassword());
        // Send confirmation email
        emailService.sendPasswordResetConfirmation(email);

        return "Password successfully reset.";
    }

    public String confirmRegistration(String token) {
        String email = jwtService.extractEmailFromResetToken(token);
        if (email == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid token.");
        }
        // Confirm the user
        personService.confirmUserByEmail(email);
        return "Registration confirmed. You can now log in.";
    }



}
