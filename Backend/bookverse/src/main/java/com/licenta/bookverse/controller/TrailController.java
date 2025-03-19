package com.licenta.bookverse.controller;


import com.licenta.bookverse.dto.TrailDTO;
import com.licenta.bookverse.dto.TrailDTOGetRequest;
import com.licenta.bookverse.entity.Book;
import com.licenta.bookverse.entity.Trail;
import com.licenta.bookverse.service.TrailsService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/trails")
@RequiredArgsConstructor
public class TrailController {

    private final TrailsService trailService;

    @GetMapping("/{id}")
    public ResponseEntity<TrailDTOGetRequest> getTrailById(@PathVariable Integer id) {
        TrailDTOGetRequest trail = trailService.getTrailById(id);
        return ResponseEntity.ok(trail);
    }

    @GetMapping("/person/{personId}")
    public ResponseEntity<List<TrailDTOGetRequest>> getTrailsByPerson(@PathVariable UUID personId) {
        return ResponseEntity.ok(trailService.getTrailsByPerson(personId));
    }

    @GetMapping("/except/person/{personId}")
    public ResponseEntity<List<TrailDTOGetRequest>> getTrailsExceptOfPerson(@PathVariable UUID personId) {
        return ResponseEntity.ok(trailService.getTrailsExceptForPerson(personId));
    }

    @PostMapping("/create")
    public ResponseEntity<Long> createTrail(@RequestBody TrailDTO dto) {
        Long trailId = trailService.createTrail(dto); // Get the created trail's ID
        return ResponseEntity.status(HttpStatus.CREATED).body(trailId); // Return the trail ID
    }

}