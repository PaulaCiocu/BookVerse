package com.licenta.bookverse.controller;


import com.licenta.bookverse.dto.auth.UserProfileDTO;
import com.licenta.bookverse.entity.Person;
import com.licenta.bookverse.repository.PersonRepository;
import com.licenta.bookverse.service.PersonService;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/person")
@AllArgsConstructor
public class PersonController {

    @Autowired
    private final PersonService personService;
    @Autowired
    private PersonRepository personRepository;

    @GetMapping("personId/{id}")
    public ResponseEntity<Person> getPersonById(@PathVariable UUID id) {
        Person person = personRepository.findById(id)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));
        return ResponseEntity.ok(person);
    }

    @GetMapping("/{email}")
    public ResponseEntity<Person> getPersonByEmail(@PathVariable String email) {
        Person person = personRepository.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));
        return ResponseEntity.ok(person);
    }
    @GetMapping()
    public ResponseEntity<List<Person>> getAllPersons() {
        List<Person> persons = personService.getAllPersons();
        return ResponseEntity.ok(persons);
    }

    @PutMapping("/edit/id/{id}")
    public ResponseEntity<Person> updateProfileById(@PathVariable UUID id, @RequestBody UserProfileDTO updatedPerson) {
        return ResponseEntity.ok(personService.editProfileById(id, updatedPerson));
    }

}
