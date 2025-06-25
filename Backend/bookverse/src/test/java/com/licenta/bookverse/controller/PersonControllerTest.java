package com.licenta.bookverse.controller;

import com.licenta.bookverse.dto.auth.UserProfileDTO;
import com.licenta.bookverse.entity.Person;
import com.licenta.bookverse.repository.PersonRepository;
import com.licenta.bookverse.service.PersonService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class PersonControllerTest {

    private PersonService personService;
    private PersonRepository personRepository;
    private PersonController personController;

    private UUID personId;
    private Person existingPerson;

    @BeforeEach
    void setup() {
        personService = mock(PersonService.class);
        personRepository = mock(PersonRepository.class);
        personController = new PersonController(personService, personRepository);

        personId = UUID.randomUUID();
        existingPerson = new Person();
        existingPerson.setId(personId);
        existingPerson.setFullName("Test User");
    }

    @Test
    void testGetPersonById_ReturnsPerson() {
        when(personRepository.findById(personId)).thenReturn(Optional.of(existingPerson));

        ResponseEntity<Person> response = personController.getPersonById(personId);

        assertEquals(200, response.getStatusCodeValue());
        assertEquals(existingPerson, response.getBody());
    }

    @Test
    void testGetPersonById_UserNotFound_ThrowsException() {
        when(personRepository.findById(personId)).thenReturn(Optional.empty());

        assertThrows(UsernameNotFoundException.class, () -> {
            personController.getPersonById(personId);
        });
    }

    @Test
    void testGetAllPersons_ReturnsList() {
        List<Person> mockList = List.of(existingPerson);
        when(personService.getAllPersons()).thenReturn(mockList);

        ResponseEntity<List<Person>> response = personController.getAllPersons();

        assertEquals(200, response.getStatusCodeValue());
        assertEquals(mockList, response.getBody());
    }

    @Test
    void testUpdateProfileById_CallsService() {
        UserProfileDTO dto = new UserProfileDTO();
        dto.setFullName("Updated");

        when(personService.editProfileById(personId, dto)).thenReturn(existingPerson);

        ResponseEntity<Person> response = personController.updateProfileById(personId, dto);

        assertEquals(200, response.getStatusCodeValue());
        assertEquals(existingPerson, response.getBody());
        verify(personService).editProfileById(personId, dto);
    }
}
