package com.licenta.bookverse.service;

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
import java.util.UUID;

@Service
@AllArgsConstructor
public class PersonService {

    @Autowired
    private final PersonRepository personRepository;
    @Autowired
    PasswordEncoder passwordEncoder;

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

    // Check if a user exists by email (added for password reset)
    public boolean checkIfEmailExists(String email) {
        return personRepository.existsByEmail(email);
    }

    // Update the password for the user (added for password reset)
    public void updatePassword(String email, String newPassword) {
        Person user = personRepository.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));
        String encodedPassword = passwordEncoder.encode(newPassword); // Encode the new password
        user.setPassword(encodedPassword);
        personRepository.save(user);
    }

    public void confirmUserByEmail(String email) {
        Person person = personRepository.findByEmail(email)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));

        // Mark the user as confirmed
        person.setConfirmed(true);
        personRepository.save(person);
    }


}
