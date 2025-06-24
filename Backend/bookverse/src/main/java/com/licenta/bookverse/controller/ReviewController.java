package com.licenta.bookverse.controller;

import com.licenta.bookverse.dto.books.ReviewsDTO;
import com.licenta.bookverse.entity.Review;
import com.licenta.bookverse.service.ReviewService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/reviews")
@RequiredArgsConstructor
public class ReviewController {

    private final ReviewService reviewService;

    @PostMapping("/create/{bookKey}/{personId}")
    public ResponseEntity<Review> addReview(
            @PathVariable UUID personId,
            @PathVariable String bookKey,
            @RequestParam String content,
            @RequestParam int rating) {
        Review review = reviewService.addReview(personId, bookKey, content, rating);
        return ResponseEntity.ok(review);
    }

    @GetMapping("/book/{bookKey}")
    public ResponseEntity<List<ReviewsDTO>> getReviewsByBook(@PathVariable String bookKey) {
        return ResponseEntity.ok(reviewService.getReviewsByBook(bookKey));
    }

    @GetMapping("/person/{personId}")
    public ResponseEntity<List<Review>> getReviewsByPerson(@PathVariable UUID personId) {
        return ResponseEntity.ok(reviewService.getReviewsByPerson(personId));
    }

    @DeleteMapping("/{reviewId}")
    public ResponseEntity<Void> deleteReview(@PathVariable Integer reviewId) {
        reviewService.deleteReview(reviewId);
        return ResponseEntity.noContent().build();
    }
}
