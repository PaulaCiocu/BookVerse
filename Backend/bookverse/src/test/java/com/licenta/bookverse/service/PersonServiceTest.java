package com.licenta.bookverse;

import com.licenta.bookverse.dto.auth.UserProfileDTO;
import com.licenta.bookverse.entity.Person;
import com.licenta.bookverse.repository.PersonRepository;
import com.licenta.bookverse.service.PersonService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.web.server.ResponseStatusException;


import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class PersonServiceTest {

    @Mock
    private PersonRepository personRepository;

    @InjectMocks
    private PersonService personService;

    private UUID personId;
    private Person existingPerson;

    @BeforeEach
    void setup() {
        personId = UUID.randomUUID();
        existingPerson = new Person();
        existingPerson.setId(personId);
        existingPerson.setFullName("Old Name");
        existingPerson.setBio("Old Bio");
        existingPerson.setProfilePictureUrl("old-url.jpg");
    }

    @Test
    void testGetAllPersons_ReturnsPersonList() {
        List<Person> mockList = List.of(existingPerson);
        when(personRepository.findAll()).thenReturn(mockList);

        List<Person> result = personService.getAllPersons();

        assertEquals(1, result.size());
        verify(personRepository, times(1)).findAll();
    }

    @Test
    void testEditProfileById_UpdatesFieldsCorrectly() {
        UserProfileDTO dto = new UserProfileDTO();
        dto.setFullName("New Name");
        dto.setBio("New Bio");
        dto.setProfilePictureUrl("new-url.jpg");

        when(personRepository.findById(personId)).thenReturn(Optional.of(existingPerson));
        when(personRepository.save(any(Person.class))).thenAnswer(invocation -> invocation.getArgument(0));

        Person result = personService.editProfileById(personId, dto);

        assertEquals("New Name", result.getFullName());
        assertEquals("New Bio", result.getBio());
        assertEquals("new-url.jpg", result.getProfilePictureUrl());

        verify(personRepository).save(result);
    }

    @Test
    void testEditProfileById_NullFields_DoNotOverwrite() {
        UserProfileDTO dto = new UserProfileDTO();
        dto.setFullName(null);
        dto.setBio(null);
        dto.setProfilePictureUrl("");

        when(personRepository.findById(personId)).thenReturn(Optional.of(existingPerson));
        when(personRepository.save(any(Person.class))).thenAnswer(invocation -> invocation.getArgument(0));

        Person result = personService.editProfileById(personId, dto);

        assertEquals("Old Name", result.getFullName());
        assertEquals("Old Bio", result.getBio());
        assertEquals("old-url.jpg", result.getProfilePictureUrl());
    }

    @Test
    void testEditProfileById_UserNotFound_ThrowsException() {
        when(personRepository.findById(personId)).thenReturn(Optional.empty());

        ResponseStatusException exception = assertThrows(
                ResponseStatusException.class,
                () -> personService.editProfileById(personId, new UserProfileDTO())
        );
        assertEquals("404 NOT_FOUND \"User not found\"", exception.getMessage());
    }
}
