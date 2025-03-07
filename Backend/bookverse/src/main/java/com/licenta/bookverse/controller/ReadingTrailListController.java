package com.licenta.bookverse.controller;


import com.licenta.bookverse.dto.books.CreatedType;
import com.licenta.bookverse.entity.ReadingTrailList;
import com.licenta.bookverse.service.ReadingTrailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/reading-trails")
public class ReadingTrailListController {

    @Autowired
    private ReadingTrailService readingTrailService;

    @PostMapping("/add/{personId}/{trailId}/{createdType}")
    public ResponseEntity<String> addTrailToReadingList(
            @PathVariable UUID personId,
            @PathVariable Long trailId,
            @PathVariable CreatedType createdType) {
        try {
            readingTrailService.addTrailToReadingList(personId, trailId, createdType);
            return new ResponseEntity<>("Trail added to your reading list!", HttpStatus.CREATED);
        } catch (Exception e) {
            return new ResponseEntity<>("Failed to add trail: " + e.getMessage(), HttpStatus.BAD_REQUEST);
        }
    }

    @GetMapping("/exists/{personId}/{trailId}")
    public ResponseEntity<Boolean> isTrailInReadingList(@PathVariable UUID personId, @PathVariable Long trailId) {
        boolean exists = readingTrailService.isTrailInReadingList(personId, trailId);
        return ResponseEntity.ok(exists);
    }

    @GetMapping("/person/{personId}")
    public List<ReadingTrailList> getPersonTrails(@PathVariable UUID personId) {
        return readingTrailService.getReadingTrailsForPerson(personId);
    }
}
