package com.licenta.bookverse.controller;


import com.licenta.bookverse.dto.books.TrailDTO;
import com.licenta.bookverse.dto.books.TrailDTOGetRequest;
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
    public ResponseEntity<List<TrailDTOGetRequest>> getTrailsExceptOfPerson(@PathVariable UUID personId,
                                                                            @RequestParam(required = false) String genre,
                                                                            @RequestParam(required = false) String author,
                                                                            @RequestParam(required = false) String bookTitle,
                                                                            @RequestParam(required = false) String trailName
                                                                            ) {
        return ResponseEntity.ok(trailService.getTrailsExceptForPerson(personId, genre, author, bookTitle,trailName));
    }

    @PostMapping("/create")
    public ResponseEntity<Long> createTrail(@RequestBody TrailDTO dto) {
        Long trailId = trailService.createTrail(dto); // Get the created trail's ID
        return ResponseEntity.status(HttpStatus.CREATED).body(trailId); // Return the trail ID
    }

//    @PutMapping("/updatebooks/{trailId}")
//    public ResponseEntity<Long> updateTrail(
//            @PathVariable Integer trailId,
//            @RequestBody List<String> bookList
//    ) {
//        Long updatedTrail = trailService.updateTrailBooks( trailId, bookList);
//        return new ResponseEntity<>(updatedTrail, HttpStatus.OK);
//    }

    @PutMapping("/{trailId}")
    public ResponseEntity<Long> updateTrailComplete(
            @PathVariable Integer trailId,
            @RequestBody TrailDTO trailDTO
    ) {
        Long updatedTrail = trailService.updateTrail( trailId, trailDTO);
        return new ResponseEntity<>(updatedTrail, HttpStatus.OK);
    }


    @DeleteMapping("/delete/{trailId}/{userId}/{keepBooks}")
    public ResponseEntity<String> deleteTrail(@PathVariable Long trailId, @PathVariable UUID userId, @PathVariable Boolean keepBooks) {
        trailService.deleteTrail(trailId,userId, keepBooks);
        return new ResponseEntity<>("Trail marked up for deletion!", HttpStatus.OK);
    }

}