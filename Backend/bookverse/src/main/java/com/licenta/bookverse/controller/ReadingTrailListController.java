package com.licenta.bookverse.controller;


import com.licenta.bookverse.dto.books.ReadingTrailListProjection;
import com.licenta.bookverse.dto.books.enums.CreatedType;
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

    @GetMapping("/followed/person/{personId}")
    public List<ReadingTrailList> getFollowedPersonTrails(@PathVariable UUID personId) {
        return readingTrailService.getReadingTrailsFollowedForPersonId(personId);
    }

    @GetMapping("/created/person/{personId}")
    public List<ReadingTrailList> getCreatedPersonTrails(@PathVariable UUID personId) {
        return readingTrailService.getReadingTrailsCreatedForPersonId(personId);
    }

    @PutMapping("/update-progress/{personId}/{trailId}")
    public ResponseEntity<String> updateReadingProgress(
            @PathVariable UUID personId,
            @PathVariable Long trailId,
            @RequestParam int pagesRead) {
        try {
            // Call the service to update the progress
            boolean success = readingTrailService.updateReadingProgress(personId, trailId, pagesRead);

            if (success) {
                return new ResponseEntity<>("Reading progress updated successfully!", HttpStatus.OK);
            } else {
                return new ResponseEntity<>("Failed to update reading progress. Trail not found.", HttpStatus.NOT_FOUND);
            }
        } catch (Exception e) {
            return new ResponseEntity<>("Failed to update reading progress: " + e.getMessage(), HttpStatus.BAD_REQUEST);
        }
    }

    @DeleteMapping("/delete/{personId}/{trailId}/{deleteBooks}")
    public ResponseEntity<String> deleteTrailFromReadingList(
            @PathVariable UUID personId,
            @PathVariable Long trailId, @PathVariable boolean deleteBooks) {
        try {
            boolean success = readingTrailService.deleteTrailFromReadingList(personId, trailId, deleteBooks);
            if (success) {
                return new ResponseEntity<>("Trail successfully deleted from your reading list.", HttpStatus.OK);
            } else {
                return new ResponseEntity<>("Failed to delete trail. Trail not found in your reading list.", HttpStatus.NOT_FOUND);
            }
        } catch (Exception e) {
            return new ResponseEntity<>("Failed to delete trail: " + e.getMessage(), HttpStatus.BAD_REQUEST);
        }
    }
}
