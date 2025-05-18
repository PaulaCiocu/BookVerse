package com.licenta.bookverse.controller;
import com.licenta.bookverse.dto.auth.*;
import com.licenta.bookverse.service.auth.AuthenticationService;
import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/auth")
@AllArgsConstructor
public class AuthController {

    @Autowired
    private final AuthenticationService authenticationService;
    
    @PostMapping("/register")
    public ResponseEntity<String> register(@Valid @RequestBody RegistrationDTO registrationDTO) {
        String uid = authenticationService.registerPerson(registrationDTO);
        return ResponseEntity.ok("User registered successfully! Firebase UID: " + uid);
    }

    @PostMapping("/login")
    public ResponseEntity<LoginResponse> loginWithFirebase(@RequestHeader("Authorization") String idToken) {
        LoginResponse response = authenticationService.authenticateWithFirebase(idToken);
        return ResponseEntity.ok(response);
    }

}
