package com.licenta.bookverse.controller;

import com.licenta.bookverse.dto.books.ReadingListDTO;
import com.licenta.bookverse.dto.books.enums.ReadingListStatus;
import com.licenta.bookverse.service.ReadingListService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/reading-list")
public class ReadingListController {

    @Autowired
    private ReadingListService readingListService;

    @PostMapping("/add/{personId}/{bookId}")
    public ResponseEntity<String> addToReadingList( @PathVariable UUID personId, @PathVariable String bookId) {
        // Extract personId and bookId from the request DTO
        readingListService.addToReadingList(personId, bookId);
        return ResponseEntity.ok("Book added to reading list");
    }

    @GetMapping("/books/{personId}")
    public ResponseEntity<List<ReadingListDTO>> getBooksByUserId(@PathVariable UUID personId) {
        List<ReadingListDTO> books = readingListService.getBooksByUserId(personId);
        return ResponseEntity.ok(books);
    }

    @GetMapping("/check/{personId}/{bookKey}")
    public ResponseEntity<Boolean> checkBookInReadingList(@PathVariable UUID personId, @PathVariable String bookKey) {
        boolean exists = readingListService.isBookInReadingList(personId, bookKey);
        return ResponseEntity.ok(exists);
    }

    @PostMapping("/update-status/{personId}/{bookId}")
    public ResponseEntity<String> updateReadingListStatus(
            @PathVariable UUID personId,
            @PathVariable String bookId,
            @RequestBody ReadingListStatus newStatus) {

        readingListService.updateStatusForBook(personId, bookId, newStatus);
        return ResponseEntity.ok("Reading list status updated successfully");
    }

    @PutMapping("/update-progress/{personId}/{bookId}")
    public ResponseEntity<String> updateReadingProgress(
            @PathVariable UUID personId,
            @PathVariable String bookId,
            @RequestParam int pagesRead) {
        // Call the service to update the progress
        readingListService.updateReadingProgress(personId, bookId, pagesRead);
        return ResponseEntity.ok("Reading list nr pages updated successfully");

    }

    @DeleteMapping("/delete/{personId}/{bookKey}")
    public ResponseEntity<String> deleteReadingBook(@PathVariable UUID personId, @PathVariable String bookKey) {
        String message = readingListService.deleteBookFromReadingList( personId, bookKey);
        return ResponseEntity.ok(message);
    }

    @GetMapping("/isBookNotInTrail/{personId}/{bookKey}")
    public ResponseEntity<Boolean> deleteReadingBookNotInTrail(@PathVariable UUID personId, @PathVariable String bookKey) {
        boolean isNotInTrail = readingListService.deleteBookIfNotInTrail(personId, bookKey);
        return ResponseEntity.ok(isNotInTrail);
    }


}
