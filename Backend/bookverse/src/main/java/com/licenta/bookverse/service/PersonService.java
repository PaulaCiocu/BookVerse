package com.licenta.bookverse.service;

import com.licenta.bookverse.dto.RegistrationDTO;
import com.licenta.bookverse.entity.Person;
import com.licenta.bookverse.exception.EmailAlreadyExistsException;
import com.licenta.bookverse.exception.PasswordMismatchException;
import com.licenta.bookverse.exception.UsernameAlreadyExistsException;
import com.licenta.bookverse.repository.PersonRepository;
import lombok.Setter;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class PersonService {
    private final PersonRepository personRepository;
    private final PasswordEncoder passwordEncoder;

    public PersonService(PersonRepository personRepository, PasswordEncoder passwordEncoder) {
        this.personRepository = personRepository;
        this.passwordEncoder = passwordEncoder;
    }

    public void registerPerson(RegistrationDTO registrationDTO) {
        if(!registrationDTO.getPassword().equals(registrationDTO.getConfirmPassword())) {
            throw new PasswordMismatchException();
        }

        if(personRepository.findByUsername(registrationDTO.getUsername()).isPresent()){
            throw new UsernameAlreadyExistsException();
        }
        if(personRepository.findByEmail(registrationDTO.getEmail()).isPresent()){
            throw new EmailAlreadyExistsException();
        }

        String encodedPassword = passwordEncoder.encode(registrationDTO.getPassword());

        Person person = new Person();
        person.setFullName(registrationDTO.getFullName());
        person.setUsername(registrationDTO.getUsername());
        person.setPassword(encodedPassword);
        person.setEmail(registrationDTO.getEmail());
        personRepository.save(person);


    }
}
