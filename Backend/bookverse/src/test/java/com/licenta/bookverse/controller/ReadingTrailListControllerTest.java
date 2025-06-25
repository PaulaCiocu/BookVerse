package com.licenta.bookverse.controller;

import com.licenta.bookverse.dto.books.ReadingListFollowedDTO;
import com.licenta.bookverse.dto.trails.ReadingTrailListDTO;
import com.licenta.bookverse.dto.books.enums.CreatedType;
import com.licenta.bookverse.entity.ReadingTrailList;
import com.licenta.bookverse.service.ReadingTrailService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.*;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class ReadingTrailListControllerTest {

    @Mock
    private ReadingTrailService readingTrailService;

    @InjectMocks
    private ReadingTrailListController readingTrailListController;

    private UUID personId;
    private Long trailId;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        personId = UUID.randomUUID();
        trailId = 1L;
    }

    @Test
    void testAddTrailToReadingList_Success() {
        doNothing().when(readingTrailService).addTrailToReadingList(personId, trailId, CreatedType.FOLLOWED);

        ResponseEntity<String> response = readingTrailListController.addTrailToReadingList(personId, trailId, CreatedType.FOLLOWED);

        assertEquals(HttpStatus.CREATED, response.getStatusCode());
        assertEquals("Trail added to your reading list!", response.getBody());

        verify(readingTrailService).addTrailToReadingList(personId, trailId, CreatedType.FOLLOWED);
    }

    @Test
    void testAddTrailToReadingList_Failure() {
        doThrow(new RuntimeException("Some error")).when(readingTrailService).addTrailToReadingList(personId, trailId, CreatedType.FOLLOWED);

        ResponseEntity<String> response = readingTrailListController.addTrailToReadingList(personId, trailId, CreatedType.FOLLOWED);

        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
        assertTrue(response.getBody().contains("Failed to add trail"));

        verify(readingTrailService).addTrailToReadingList(personId, trailId, CreatedType.FOLLOWED);
    }

    @Test
    void testIsTrailInReadingList() {
        when(readingTrailService.isTrailInReadingList(personId, trailId)).thenReturn(true);

        ResponseEntity<Boolean> response = readingTrailListController.isTrailInReadingList(personId, trailId);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertTrue(response.getBody());

        verify(readingTrailService).isTrailInReadingList(personId, trailId);
    }

    @Test
    void testGetPersonTrails() {
        ReadingTrailList rtl = ReadingTrailList.builder().build();
        when(readingTrailService.getReadingTrailsForPerson(personId)).thenReturn(List.of(rtl));

        List<ReadingTrailList> result = readingTrailListController.getPersonTrails(personId);

        assertEquals(1, result.size());
        verify(readingTrailService).getReadingTrailsForPerson(personId);
    }

    @Test
    void testGetPersonTrailShorter() {
        ReadingTrailListDTO dto = ReadingTrailListDTO.builder().build();
        when(readingTrailService.getReadingTrailsForPersonProfile(personId)).thenReturn(List.of(dto));

        List<ReadingTrailListDTO> result = readingTrailListController.getPersonTrailShorter(personId);

        assertEquals(1, result.size());
        verify(readingTrailService).getReadingTrailsForPersonProfile(personId);
    }

    @Test
    void testGetFollowedPersonTrails() {
        ReadingListFollowedDTO dto = ReadingListFollowedDTO.builder().build();
        when(readingTrailService.getReadingTrailsFollowedForPersonId(personId)).thenReturn(List.of(dto));

        List<ReadingListFollowedDTO> result = readingTrailListController.getFollowedPersonTrails(personId);

        assertEquals(1, result.size());
        verify(readingTrailService).getReadingTrailsFollowedForPersonId(personId);
    }

    @Test
    void testGetCreatedPersonTrails() {
        ReadingTrailList rtl = ReadingTrailList.builder().build();
        when(readingTrailService.getReadingTrailsCreatedForPersonId(personId)).thenReturn(List.of(rtl));

        List<ReadingTrailList> result = readingTrailListController.getCreatedPersonTrails(personId);

        assertEquals(1, result.size());
        verify(readingTrailService).getReadingTrailsCreatedForPersonId(personId);
    }

    @Test
    void testDeleteTrailFromReadingList_Success() {
        when(readingTrailService.deleteTrailFromReadingList(personId, trailId, true)).thenReturn(true);

        ResponseEntity<String> response = readingTrailListController.deleteTrailFromReadingList(personId, trailId, true);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertEquals("Trail successfully deleted from your reading list.", response.getBody());

        verify(readingTrailService).deleteTrailFromReadingList(personId, trailId, true);
    }

    @Test
    void testDeleteTrailFromReadingList_Failure() {
        when(readingTrailService.deleteTrailFromReadingList(personId, trailId, true)).thenReturn(false);

        ResponseEntity<String> response = readingTrailListController.deleteTrailFromReadingList(personId, trailId, true);

        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
        assertEquals("Failed to delete trail. Trail not found in your reading list.", response.getBody());

        verify(readingTrailService).deleteTrailFromReadingList(personId, trailId, true);
    }

    @Test
    void testDeleteTrailFromReadingList_Exception() {
        when(readingTrailService.deleteTrailFromReadingList(personId, trailId, true))
                .thenThrow(new RuntimeException("Something went wrong"));

        ResponseEntity<String> response = readingTrailListController.deleteTrailFromReadingList(personId, trailId, true);

        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
        assertTrue(response.getBody().contains("Failed to delete trail"));

        verify(readingTrailService).deleteTrailFromReadingList(personId, trailId, true);
    }
}
