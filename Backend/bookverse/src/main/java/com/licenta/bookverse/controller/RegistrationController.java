package com.licenta.bookverse.controller;
import com.licenta.bookverse.dto.RegistrationDTO;
import com.licenta.bookverse.service.PersonService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/register")
public class RegistrationController {

    private final PersonService personService;
    public RegistrationController(PersonService personService) {
        this.personService = personService;
    }

    @PostMapping
    public ResponseEntity<String> register(@Valid @RequestBody RegistrationDTO registrationDTO) {
        try {
            personService.registerPerson(registrationDTO);
            return ResponseEntity.ok("User registered successfully");
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

}
