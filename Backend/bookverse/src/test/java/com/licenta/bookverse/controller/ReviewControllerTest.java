package com.licenta.bookverse.controller;

import com.licenta.bookverse.dto.books.ReviewsDTO;
import com.licenta.bookverse.entity.Review;
import com.licenta.bookverse.service.ReviewService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.*;
import org.springframework.http.ResponseEntity;

import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class ReviewControllerTest {

    @Mock
    private ReviewService reviewService;

    @InjectMocks
    private ReviewController reviewController;

    private UUID personId;
    private String bookKey;
    private Review review;
    private ReviewsDTO reviewsDTO;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);

        personId = UUID.randomUUID();
        bookKey = "bookKey123";

        review = new Review();
        review.setId(1);
        review.setContent("Great book!");
        review.setRating(5);

        reviewsDTO = new ReviewsDTO();
        reviewsDTO.setId(1);
        reviewsDTO.setContent("Great book!");
        reviewsDTO.setRating(5);
        reviewsDTO.setPersonName("Test User");
    }

    @Test
    void testAddReview() {
        String content = "Awesome read!";
        int rating = 4;

        when(reviewService.addReview(personId, bookKey, content, rating)).thenReturn(review);

        ResponseEntity<Review> response = reviewController.addReview(personId, bookKey, content, rating);

        assertEquals(200, response.getStatusCodeValue());
        assertEquals(review, response.getBody());

        verify(reviewService).addReview(personId, bookKey, content, rating);
    }

    @Test
    void testGetReviewsByBook() {
        when(reviewService.getReviewsByBook(bookKey)).thenReturn(List.of(reviewsDTO));

        ResponseEntity<List<ReviewsDTO>> response = reviewController.getReviewsByBook(bookKey);

        assertEquals(200, response.getStatusCodeValue());
        assertNotNull(response.getBody());
        assertEquals(1, response.getBody().size());
        assertEquals(reviewsDTO.getContent(), response.getBody().get(0).getContent());

        verify(reviewService).getReviewsByBook(bookKey);
    }

    @Test
    void testGetReviewsByPerson() {
        when(reviewService.getReviewsByPerson(personId)).thenReturn(List.of(review));

        ResponseEntity<List<Review>> response = reviewController.getReviewsByPerson(personId);

        assertEquals(200, response.getStatusCodeValue());
        assertNotNull(response.getBody());
        assertEquals(1, response.getBody().size());
        assertEquals(review, response.getBody().get(0));

        verify(reviewService).getReviewsByPerson(personId);
    }
}
