package com.licenta.bookverse.controller;

import com.licenta.bookverse.dto.books.ReadingListDTO;
import com.licenta.bookverse.dto.books.enums.ReadingListStatus;
import com.licenta.bookverse.service.ReadingListService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.*;
import org.springframework.http.ResponseEntity;

import java.util.List;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class ReadingListControllerTest {

    @Mock
    private ReadingListService readingListService;

    @InjectMocks
    private ReadingListController readingListController;

    private UUID personId;
    private String bookKey;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        personId = UUID.randomUUID();
        bookKey = "bookKey1";
    }

    @Test
    void testAddToReadingList() {
        doNothing().when(readingListService).addToReadingList(personId, bookKey);

        ResponseEntity<String> response = readingListController.addToReadingList(personId, bookKey);

        assertEquals(200, response.getStatusCodeValue());
        assertEquals("Book added to reading list", response.getBody());

        verify(readingListService).addToReadingList(personId, bookKey);
    }

    @Test
    void testGetBooksByUserId() {
        ReadingListDTO dto = ReadingListDTO.builder()
                // set fields as needed
                .build();

        when(readingListService.getBooksByUserId(personId)).thenReturn(List.of(dto));

        ResponseEntity<List<ReadingListDTO>> response = readingListController.getBooksByUserId(personId);

        assertEquals(200, response.getStatusCodeValue());
        assertNotNull(response.getBody());
        assertEquals(1, response.getBody().size());

        verify(readingListService).getBooksByUserId(personId);
    }

    @Test
    void testCheckBookInReadingList() {
        when(readingListService.isBookInReadingList(personId, bookKey)).thenReturn(true);

        ResponseEntity<Boolean> response = readingListController.checkBookInReadingList(personId, bookKey);

        assertEquals(200, response.getStatusCodeValue());
        assertTrue(response.getBody());

        verify(readingListService).isBookInReadingList(personId, bookKey);
    }

    @Test
    void testUpdateReadingListStatus() {
        ReadingListStatus newStatus = ReadingListStatus.IN_PROGRESS;

        doNothing().when(readingListService).updateStatusForBook(personId, bookKey, newStatus);

        ResponseEntity<String> response = readingListController.updateReadingListStatus(personId, bookKey, newStatus);

        assertEquals(200, response.getStatusCodeValue());
        assertEquals("Reading list status updated successfully", response.getBody());

        verify(readingListService).updateStatusForBook(personId, bookKey, newStatus);
    }

    @Test
    void testUpdateReadingProgress() {
        int pagesRead = 50;

        doNothing().when(readingListService).updateReadingProgress(personId, bookKey, pagesRead);

        ResponseEntity<String> response = readingListController.updateReadingProgress(personId, bookKey, pagesRead);

        assertEquals(200, response.getStatusCodeValue());
        assertEquals("Reading list nr pages updated successfully", response.getBody());

        verify(readingListService).updateReadingProgress(personId, bookKey, pagesRead);
    }

    @Test
    void testDeleteReadingBook() {
        String message = "Deleted successfully";

        when(readingListService.deleteBookFromReadingList(personId, bookKey)).thenReturn(message);

        ResponseEntity<String> response = readingListController.deleteReadingBook(personId, bookKey);

        assertEquals(200, response.getStatusCodeValue());
        assertEquals(message, response.getBody());

        verify(readingListService).deleteBookFromReadingList(personId, bookKey);
    }

    @Test
    void testDeleteReadingBookNotInTrail() {
        when(readingListService.deleteBookIfNotInTrail(personId, bookKey)).thenReturn(true);

        ResponseEntity<Boolean> response = readingListController.deleteReadingBookNotInTrail(personId, bookKey);

        assertEquals(200, response.getStatusCodeValue());
        assertTrue(response.getBody());

        verify(readingListService).deleteBookIfNotInTrail(personId, bookKey);
    }
}
