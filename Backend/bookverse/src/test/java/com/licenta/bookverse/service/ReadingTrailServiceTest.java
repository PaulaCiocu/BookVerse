package com.licenta.bookverse.service;

import com.licenta.bookverse.dto.books.ReadingListFollowedDTO;
import com.licenta.bookverse.dto.trails.ReadingTrailListDTO;
import com.licenta.bookverse.dto.books.enums.ReadingListStatus;
import com.licenta.bookverse.dto.books.enums.CreatedType;
import com.licenta.bookverse.entity.*;
import com.licenta.bookverse.repository.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ReadingTrailServiceTest {

    @Mock
    private ReadingTrailListRepository readingTrailListRepository;

    @Mock
    private PersonRepository personRepository;

    @Mock
    private TrailRepository trailRepository;

    @Mock
    private ReadingListRepository readingListRepository;

    @InjectMocks
    private ReadingTrailService readingTrailService;

    private UUID personId;
    private Long trailId;
    private Person person;
    private Trail trail;
    private TrailBook trailBook;

    @BeforeEach
    void setup() {
        personId = UUID.randomUUID();
        trailId = 1L;

        person = new Person();
        person.setId(personId);
        person.setFullName("Test Person");

        trail = new Trail();
        trail.setId(trailId);
        trail.setTitle("Test Trail");
        trail.setNumberOfReadings(5);

        trailBook = new TrailBook();
        Book book = new Book();
        book.setKey("bookKey1");
        book.setPages(100);
        trailBook.setBook(book);

        trail.setTrailBooks(List.of(trailBook));
    }

    @Test
    void testAddTrailToReadingList_CreatesReadingTrailListAndReadingList() {
        when(personRepository.findById(personId)).thenReturn(Optional.of(person));
        when(trailRepository.findById(trailId)).thenReturn(Optional.of(trail));
        when(readingListRepository.findByPersonAndBook(person, trailBook.getBook())).thenReturn(Optional.empty());

        readingTrailService.addTrailToReadingList(personId, trailId, CreatedType.FOLLOWED);

        assertEquals(6, trail.getNumberOfReadings());
        verify(readingTrailListRepository).save(any(ReadingTrailList.class));
        verify(readingListRepository).save(any(ReadingList.class));
    }

    @Test
    void testAddTrailToReadingList_DoesNotDuplicateReadingList() {
        when(personRepository.findById(personId)).thenReturn(Optional.of(person));
        when(trailRepository.findById(trailId)).thenReturn(Optional.of(trail));
        when(readingListRepository.findByPersonAndBook(person, trailBook.getBook())).thenReturn(Optional.of(new ReadingList()));

        readingTrailService.addTrailToReadingList(personId, trailId, CreatedType.CREATED);
        assertEquals(5, trail.getNumberOfReadings());

        verify(readingTrailListRepository).save(any(ReadingTrailList.class));
        verify(readingListRepository, never()).save(any(ReadingList.class));
    }

    @Test
    void testGetReadingTrailsForPerson_ReturnsList() {
        when(personRepository.findById(personId)).thenReturn(Optional.of(person));
        ReadingTrailList rtl = ReadingTrailList.builder().person(person).trail(trail).build();
        when(readingTrailListRepository.findByPerson(person)).thenReturn(List.of(rtl));

        List<ReadingTrailList> result = readingTrailService.getReadingTrailsForPerson(personId);

        assertEquals(1, result.size());
        assertEquals(person, result.get(0).getPerson());
    }

    @Test
    void testGetReadingTrailsForPersonProfile_ReturnsDTOs() {
        when(personRepository.findById(personId)).thenReturn(Optional.of(person));
        ReadingTrailList rtl = ReadingTrailList.builder().person(person).trail(trail).build();
        when(readingTrailListRepository.findByPerson(person)).thenReturn(List.of(rtl));

        List<ReadingTrailListDTO> dtos = readingTrailService.getReadingTrailsForPersonProfile(personId);

        assertEquals(1, dtos.size());
        assertEquals(trail.getTitle(), dtos.get(0).getTitle());
        assertEquals(personId, dtos.get(0).getPersonId());
    }

    @Test
    void testGetReadingTrailsFollowedForPersonId_ReturnsDTOs() {
        when(personRepository.findById(personId)).thenReturn(Optional.of(person));
        ReadingTrailList rtl = ReadingTrailList.builder()
                .person(person)
                .trail(trail)
                .createdType(CreatedType.FOLLOWED)
                .build();

        when(readingTrailListRepository.findByPersonAndCreatedType(person, CreatedType.FOLLOWED))
                .thenReturn(List.of(rtl));

        List<ReadingListFollowedDTO> dtos = readingTrailService.getReadingTrailsFollowedForPersonId(personId);

        assertEquals(1, dtos.size());
        assertEquals(trail.getTitle(), dtos.get(0).getTitle());
    }

    @Test
    void testIsTrailInReadingList_ReturnsTrue() {
        when(personRepository.findById(personId)).thenReturn(Optional.of(person));
        when(trailRepository.findById(trailId)).thenReturn(Optional.of(trail));
        when(readingTrailListRepository.existsByPersonAndTrail(person, trail)).thenReturn(true);

        boolean exists = readingTrailService.isTrailInReadingList(personId, trailId);
        assertTrue(exists);
    }

    @Test
    void testIsTrailInReadingList_ReturnsFalse() {
        when(personRepository.findById(personId)).thenReturn(Optional.of(person));
        when(trailRepository.findById(trailId)).thenReturn(Optional.of(trail));
        when(readingTrailListRepository.existsByPersonAndTrail(person, trail)).thenReturn(false);

        boolean exists = readingTrailService.isTrailInReadingList(personId, trailId);
        assertFalse(exists);
    }

    @Test
    void testDeleteTrailFromReadingList_DeleteBooksTrue_RemovesBooksAndTrail() {
        ReadingTrailList readingTrail = ReadingTrailList.builder()
                .person(person)
                .trail(trail)
                .build();
        ReadingTrailList otherTrail = ReadingTrailList.builder()
                .person(person)
                .trail(trail) // different trail
                .build();

        when(personRepository.findById(personId)).thenReturn(Optional.of(person));
        when(trailRepository.findById(trailId)).thenReturn(Optional.of(trail));
        when(readingTrailListRepository.findByPersonAndTrail(person, trail)).thenReturn(readingTrail);
        when(readingTrailListRepository.findByPerson(person)).thenReturn(List.of(otherTrail));
        when(readingListRepository.findByPerson_IdAndBook_Key(personId, trailBook.getBook().getKey()))
                .thenReturn(Optional.of(new ReadingList()));

        boolean deleted = readingTrailService.deleteTrailFromReadingList(personId, trailId, true);

        assertTrue(deleted);
        verify(readingListRepository).delete(any(ReadingList.class));
        verify(readingTrailListRepository).delete(readingTrail);
    }

    @Test
    void testDeleteTrailFromReadingList_DeleteBooksFalse_OnlyDeletesTrail() {
        ReadingTrailList readingTrail = ReadingTrailList.builder()
                .person(person)
                .trail(trail)
                .build();

        when(personRepository.findById(personId)).thenReturn(Optional.of(person));
        when(trailRepository.findById(trailId)).thenReturn(Optional.of(trail));
        when(readingTrailListRepository.findByPersonAndTrail(person, trail)).thenReturn(readingTrail);

        boolean deleted = readingTrailService.deleteTrailFromReadingList(personId, trailId, false);

        assertTrue(deleted);
        verify(readingListRepository, never()).delete(any(ReadingList.class));
        verify(readingTrailListRepository).delete(readingTrail);
    }

    @Test
    void testDeleteTrailFromReadingList_TrailNotFound_ReturnsFalse() {
        when(personRepository.findById(personId)).thenReturn(Optional.of(person));
        when(trailRepository.findById(trailId)).thenReturn(Optional.empty());

        RuntimeException exception = assertThrows(RuntimeException.class, () -> {
            readingTrailService.deleteTrailFromReadingList(personId, trailId, true);
        });

        assertEquals("Trail not found", exception.getMessage());
        verify(readingTrailListRepository, never()).delete(any());
    }
}
