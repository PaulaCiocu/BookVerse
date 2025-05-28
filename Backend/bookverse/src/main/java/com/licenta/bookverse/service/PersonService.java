package com.licenta.bookverse.service;

import com.licenta.bookverse.dto.auth.UserProfileDTO;
import com.licenta.bookverse.entity.Person;
import com.licenta.bookverse.repository.PersonRepository;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@AllArgsConstructor
public class PersonService {

    @Autowired
    private final PersonRepository personRepository;

    public List<Person> getAllPersons() {
        return personRepository.findAll();
    }

    public Person editProfileById(UUID id, UserProfileDTO updatedPerson) {
        Person person = personRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));
        if(updatedPerson.getFullName()!= null) {
            person.setFullName(updatedPerson.getFullName());
        }
        if(updatedPerson.getBio()!= null) {
            person.setBio(updatedPerson.getBio());
        }

        if(updatedPerson.getProfilePictureUrl()!= null && !updatedPerson.getProfilePictureUrl().isEmpty()) {
            person.setProfilePictureUrl(updatedPerson.getProfilePictureUrl());
        }
        Person savedPerson = personRepository.save(person);
        return savedPerson;
    }
}
