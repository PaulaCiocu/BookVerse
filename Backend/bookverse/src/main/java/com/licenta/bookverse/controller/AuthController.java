package com.licenta.bookverse.controller;
import com.licenta.bookverse.dto.auth.*;
import com.licenta.bookverse.entity.Person;
import com.licenta.bookverse.service.auth.AuthenticationService;
import com.licenta.bookverse.service.auth.JwtService;
import com.licenta.bookverse.service.PersonService;
import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/auth")
@AllArgsConstructor
public class AuthController {
    private final JwtService jwtService;

    @Autowired
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

        loginResponse.setPersonId(personService.findByEmail(loginUserDto.getEmail()).getId());
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
        String response = authenticationService.resetPassword(token, request);
        return ResponseEntity.ok("Password successfully reset.");
    }


    @PostMapping("/confirm-registration")
    public ResponseEntity<String> confirmRegistration(@RequestParam String token) {
        String response = authenticationService.confirmRegistration(token);
        return ResponseEntity.ok(response);
    }

}
