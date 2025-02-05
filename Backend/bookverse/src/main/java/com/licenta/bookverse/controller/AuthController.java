package com.licenta.bookverse.controller;

import com.licenta.bookverse.dto.*;
import com.licenta.bookverse.entity.Person;
import com.licenta.bookverse.service.AuthenticationService;
import com.licenta.bookverse.service.JwtService;
import com.licenta.bookverse.service.PersonService;
import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/auth")
@AllArgsConstructor
public class AuthController {
    private final JwtService jwtService;

    private final AuthenticationService authenticationService;
    private final PersonService personService;

    @PostMapping("/register")
    public ResponseEntity<String> register(@Valid @RequestBody RegistrationDTO registrationDTO) {
        try {
            String token = authenticationService.registerPerson(registrationDTO);
            return ResponseEntity.ok("User registered successfully! \n token: " + token);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PostMapping("/login")
    public ResponseEntity<LoginResponse> authenticate(@RequestBody LoginDTO loginUserDto) {
        Person authenticatedUser = authenticationService.authenticate(loginUserDto);

        String jwtToken = jwtService.generateToken(authenticatedUser);

        LoginResponse loginResponse = new LoginResponse();
        loginResponse.setToken(jwtToken);
        loginResponse.setExpiresIn(jwtService.getExpirationTime());
        return ResponseEntity.ok(loginResponse);
    }

    @PostMapping("/forgot-password")
    public ResponseEntity<String> forgotPassword(@RequestBody ForgotPasswordRequest request) {
        LoginResponse response = authenticationService.handleForgotPassword(request.getEmail());
        return ResponseEntity.ok("Password reset email sent.\n" + response);
    }

    @PostMapping("/reset-password")
    public ResponseEntity<String> resetPassword( @RequestParam String token, @Valid @RequestBody ResetPasswordRequest request) {
        authenticationService.validatePassword(request.getNewPassword());

        authenticationService.validatePasswordMismatch(request.getNewPassword(), request.getConfirmPassword());

        // Check if the token is valid
        if (!jwtService.isValidPasswordResetToken(token)) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body("Invalid or expired token");
        }

        // Extract email from the token
        String email = jwtService.extractEmailFromResetToken(token);
        if (email == null) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body("Invalid token data");
        }

        // Update the password in the database
        personService.updatePassword(email, request.getNewPassword());

        authenticationService.sendPasswordResetConfirmation(email);

        return ResponseEntity.ok("Password successfully reset.");
    }


    @PostMapping("/confirm-registration")
    public ResponseEntity<String> confirmRegistration(@RequestParam String token) {
        // Validate the token
        String email = jwtService.extractEmailFromResetToken(token);
        if (email == null) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Invalid token.");
        }
        // Confirm the user
        try {
            personService.confirmUserByEmail(email);
        } catch (ResponseStatusException e) {
            return ResponseEntity.status(e.getStatusCode()).body(e.getReason());
        }

        return ResponseEntity.ok("Registration confirmed. You can now log in.");
    }

}
