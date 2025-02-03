package com.licenta.bookverse.service;

import com.licenta.bookverse.entity.Person;
import com.licenta.bookverse.repository.PersonRepository;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.UUID;

@Service
@AllArgsConstructor
public class PersonService {

    @Autowired
    private final PersonRepository personRepository;

    public Person findById(UUID id) {
        return personRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));
    }


    public Person findByEmail(String email) {
        return personRepository.findByEmail(email)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));
    }

    public List<Person> getAllPersons() {
        return personRepository.findAll();
    }
}
