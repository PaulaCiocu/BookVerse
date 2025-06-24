package com.licenta.bookverse.service;

import com.licenta.bookverse.dto.books.ReadingListDTO;
import com.licenta.bookverse.dto.books.enums.ReadingListStatus;
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
class ReadingListServiceTest {

    @Mock
    private ReadingListRepository readingListRepository;

    @Mock
    private PersonRepository personRepository;

    @Mock
    private BookRepository bookRepository;

    @Mock
    private AchievementService achievementService;

    @Mock
    private TrailBookRepository trailBookRepository;

    @Mock
    private ReadingTrailService readingTrailService;

    @Mock
    private ReadingTrailListRepository readingTrailListRepository;

    @InjectMocks
    private ReadingListService readingListService;

    private UUID personId;
    private String bookKey;
    private Person person;
    private Book book;
    private ReadingList readingList;

    @BeforeEach
    void setup() {
        personId = UUID.randomUUID();
        bookKey = "book1";

        person = new Person();
        person.setId(personId);
        person.setFullName("Test User");

        book = new Book();
        book.setKey(bookKey);
        book.setTitle("Test Book");
        book.setPages(100);

        readingList = new ReadingList();
        readingList.setPerson(person);
        readingList.setBook(book);
        readingList.setStatus(ReadingListStatus.NOT_STARTED);
        readingList.setPagesRead(0);
    }

    @Test
    void testAddToReadingList_Success() {
        when(personRepository.findById(personId)).thenReturn(Optional.of(person));
        when(bookRepository.findById(bookKey)).thenReturn(Optional.of(book));
        when(readingListRepository.existsByPerson_IdAndBook_Key(personId, bookKey)).thenReturn(false);

        readingListService.addToReadingList(personId, bookKey);

        verify(readingListRepository, times(1)).save(any(ReadingList.class));
    }

    @Test
    void testAddToReadingList_AlreadyExists_Throws() {
        when(personRepository.findById(personId)).thenReturn(Optional.of(person));
        when(bookRepository.findById(bookKey)).thenReturn(Optional.of(book));
        when(readingListRepository.existsByPerson_IdAndBook_Key(personId, bookKey)).thenReturn(true);

        IllegalArgumentException exception = assertThrows(IllegalArgumentException.class, () -> {
            readingListService.addToReadingList(personId, bookKey);
        });

        assertEquals("This book is already in your reading list.", exception.getMessage());
    }

    @Test
    void testGetBooksByUserId_ReturnsList() {
        List<ReadingListDTO> mockList = List.of(ReadingListDTO.builder().build());
        when(readingListRepository.findBooksByPersonId(personId)).thenReturn(mockList);

        List<ReadingListDTO> result = readingListService.getBooksByUserId(personId);

        assertEquals(mockList, result);
    }

    @Test
    void testUpdateStatusForBook_Success() {
        when(readingListRepository.findByPerson_IdAndBook_Key(personId, bookKey)).thenReturn(Optional.of(readingList));

        readingListService.updateStatusForBook(personId, bookKey, ReadingListStatus.IN_PROGRESS);

        assertEquals(ReadingListStatus.IN_PROGRESS, readingList.getStatus());
        verify(readingListRepository).save(readingList);
    }

    @Test
    void testUpdateStatusForBook_NotFound_Throws() {
        when(readingListRepository.findByPerson_IdAndBook_Key(personId, bookKey)).thenReturn(Optional.empty());

        RuntimeException exception = assertThrows(RuntimeException.class, () -> {
            readingListService.updateStatusForBook(personId, bookKey, ReadingListStatus.IN_PROGRESS);
        });

        assertEquals("Reading list entry not found", exception.getMessage());
    }

    @Test
    void testIsBookInReadingList_ReturnsTrue() {
        when(readingListRepository.existsByPerson_IdAndBook_Key(personId, bookKey)).thenReturn(true);
        assertTrue(readingListService.isBookInReadingList(personId, bookKey));
    }

    @Test
    void testIsBookInReadingList_ReturnsFalse() {
        when(readingListRepository.existsByPerson_IdAndBook_Key(personId, bookKey)).thenReturn(false);
        assertFalse(readingListService.isBookInReadingList(personId, bookKey));
    }

    @Test
    void testUpdateReadingProgress_UpdatesStatusAndAchievements() {
        readingList.setPagesRead(10);
        readingList.setStatus(ReadingListStatus.NOT_STARTED);

        List<ReadingTrailList> readingTrailLists = new ArrayList<>();
        ReadingTrailList rtl = new ReadingTrailList();
        Trail trail = new Trail();
        trail.setTrailBooks(new ArrayList<>());

        rtl.setTrail(trail);
        readingTrailLists.add(rtl);

        when(readingListRepository.findByPerson_IdAndBook_Key(personId, bookKey)).thenReturn(Optional.of(readingList));
        when(readingTrailService.getReadingTrailsForPerson(personId)).thenReturn(readingTrailLists);
        when(readingTrailListRepository.save(any(ReadingTrailList.class))).thenAnswer(i -> i.getArgument(0));

        readingListService.updateReadingProgress(personId, bookKey, 50);

        assertEquals(50, readingList.getPagesRead());
        assertEquals(ReadingListStatus.IN_PROGRESS, readingList.getStatus());
        verify(achievementService).updateAchievements(personId);
    }

    @Test
    void testDeleteBookFromReadingList_Success() {
        when(readingListRepository.findByPerson_IdAndBook_Key(personId, bookKey)).thenReturn(Optional.of(readingList));
        when(readingTrailListRepository.findByPerson_Id(personId)).thenReturn(List.of());

        String result = readingListService.deleteBookFromReadingList(personId, bookKey);

        verify(readingListRepository).delete(readingList);
        assertEquals("Reading list entry deleted", result);
    }

    @Test
    void testDeleteBookFromReadingList_BookInTrail() {
        Trail trail = new Trail();
        TrailBook trailBook = new TrailBook();
        Book b = new Book();
        b.setKey(bookKey);
        trailBook.setBook(b);
        trail.setTrailBooks(List.of(trailBook));

        ReadingTrailList rtl = new ReadingTrailList();
        rtl.setTrail(trail);

        when(readingListRepository.findByPerson_IdAndBook_Key(personId, bookKey)).thenReturn(Optional.of(readingList));
        when(readingTrailListRepository.findByPerson_Id(personId)).thenReturn(List.of(rtl));

        String result = readingListService.deleteBookFromReadingList(personId, bookKey);

        verify(readingListRepository, never()).delete(any(ReadingList.class));
        assertEquals("Reading list entry can not be deleted is part of a trail ", result);
    }
}
