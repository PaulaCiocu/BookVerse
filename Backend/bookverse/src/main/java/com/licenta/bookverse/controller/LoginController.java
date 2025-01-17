package com.licenta.bookverse.controller;

import com.licenta.bookverse.dto.LoginDTO;
import com.licenta.bookverse.entity.Person;
import com.licenta.bookverse.service.PersonService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/login")
public class LoginController {

    private final PersonService personService;
    public LoginController(PersonService personService) {
        this.personService = personService;
    }

    @PostMapping
    public ResponseEntity<String> login(@RequestBody LoginDTO loginDTO) {
        try {
            personService.login(loginDTO);
            return ResponseEntity.ok("User logged in successfully");
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

}
