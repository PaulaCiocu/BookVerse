package com.licenta.bookverse.controller;

import com.licenta.bookverse.dto.trails.TrailDTO;
import com.licenta.bookverse.dto.trails.TrailDTODetails;
import com.licenta.bookverse.dto.trails.TrailDTOGetRequest;
import com.licenta.bookverse.service.TrailsService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.*;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.util.List;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class TrailControllerTest {

    @Mock
    private TrailsService trailsService;

    @InjectMocks
    private TrailController trailController;

    private UUID personId;
    private Long trailId;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        personId = UUID.randomUUID();
        trailId = 1L;
    }

    @Test
    void testGetTrailById() {
        TrailDTODetails details = TrailDTODetails.builder().build();
        when(trailsService.getTrailById(trailId)).thenReturn(details);

        ResponseEntity<TrailDTODetails> response = trailController.getTrailById(trailId);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertEquals(details, response.getBody());
        verify(trailsService).getTrailById(trailId);
    }

    @Test
    void testGetTrailsByPerson() {
        List<TrailDTODetails> list = List.of( TrailDTODetails.builder().build());
        when(trailsService.getTrailsByPerson(personId)).thenReturn(list);

        ResponseEntity<List<TrailDTODetails>> response = trailController.getTrailsByPerson(personId);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertEquals(list, response.getBody());
        verify(trailsService).getTrailsByPerson(personId);
    }

    @Test
    void testGetTrailsExceptOfPerson() {
        List<TrailDTOGetRequest> list = List.of( TrailDTOGetRequest.builder().build());
        when(trailsService.getTrailsExceptForPerson(personId, "fiction", "author", "title", "trailName")).thenReturn(list);

        ResponseEntity<List<TrailDTOGetRequest>> response = trailController.getTrailsExceptOfPerson(
                personId, "fiction", "author", "title", "trailName");

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertEquals(list, response.getBody());
        verify(trailsService).getTrailsExceptForPerson(personId, "fiction", "author", "title", "trailName");
    }

    @Test
    void testCreateTrail() {
        TrailDTO dto =  TrailDTO.builder().build();
        Long newTrailId = 123L;
        when(trailsService.createTrail(dto)).thenReturn(newTrailId);

        ResponseEntity<Long> response = trailController.createTrail(dto);

        assertEquals(HttpStatus.CREATED, response.getStatusCode());
        assertEquals(newTrailId, response.getBody());
        verify(trailsService).createTrail(dto);
    }

    @Test
    void testUpdateTrailComplete() {
        TrailDTO dto = TrailDTO.builder().build();
        Long updatedId = 456L;
        when(trailsService.updateTrail(trailId, dto)).thenReturn(updatedId);

        ResponseEntity<Long> response = trailController.updateTrailComplete(trailId, dto);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertEquals(updatedId, response.getBody());
        verify(trailsService).updateTrail(trailId, dto);
    }

    @Test
    void testDeleteTrail() {
        doNothing().when(trailsService).deleteTrail(trailId, personId, true);

        ResponseEntity<String> response = trailController.deleteTrail(trailId, personId, true);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertEquals("Trail marked up for deletion!", response.getBody());
        verify(trailsService).deleteTrail(trailId, personId, true);
    }
}
