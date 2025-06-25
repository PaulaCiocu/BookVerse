package com.licenta.bookverse.service;

import com.licenta.bookverse.dto.books.ReviewsDTO;
import com.licenta.bookverse.entity.Book;
import com.licenta.bookverse.entity.Person;
import com.licenta.bookverse.entity.Review;
import com.licenta.bookverse.repository.BookRepository;
import com.licenta.bookverse.repository.PersonRepository;
import com.licenta.bookverse.repository.ReviewRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ReviewServiceTest {

    @Mock
    private ReviewRepository reviewRepository;

    @Mock
    private BookRepository bookRepository;

    @Mock
    private PersonRepository personRepository;

    @InjectMocks
    private ReviewService reviewService;

    private UUID personId;
    private String bookKey;
    private Person person;
    private Book book;
    private Review review;

    @BeforeEach
    void setup() {
        personId = UUID.randomUUID();
        bookKey = "bookKey123";

        person = new Person();
        person.setId(personId);
        person.setFullName("Test User");

        book = new Book();
        book.setKey(bookKey);
        book.setTitle("Test Book");

        review = new Review();
        review.setId(1);
        review.setPerson(person);
        review.setBook(book);
        review.setContent("Great book!");
        review.setRating(5);
    }

    @Test
    void testAddReview_Success() {
        when(personRepository.findById(personId)).thenReturn(Optional.of(person));
        when(bookRepository.findById(bookKey)).thenReturn(Optional.of(book));
        when(reviewRepository.save(any(Review.class))).thenReturn(review);

        Review savedReview = reviewService.addReview(personId, bookKey, "Great book!", 5);

        assertNotNull(savedReview);
        assertEquals("Great book!", savedReview.getContent());
        assertEquals(5, savedReview.getRating());
        assertEquals(person, savedReview.getPerson());
        assertEquals(book, savedReview.getBook());
        verify(reviewRepository).save(any(Review.class));
    }

    @Test
    void testAddReview_PersonNotFound_Throws() {
        when(personRepository.findById(personId)).thenReturn(Optional.empty());

        RuntimeException exception = assertThrows(RuntimeException.class, () -> {
            reviewService.addReview(personId, bookKey, "Content", 4);
        });

        assertEquals("Person not found", exception.getMessage());
    }

    @Test
    void testAddReview_BookNotFound_Throws() {
        when(personRepository.findById(personId)).thenReturn(Optional.of(person));
        when(bookRepository.findById(bookKey)).thenReturn(Optional.empty());

        RuntimeException exception = assertThrows(RuntimeException.class, () -> {
            reviewService.addReview(personId, bookKey, "Content", 4);
        });

        assertEquals("Book not found", exception.getMessage());
    }

    @Test
    void testGetReviewsByBook_ReturnsReviewsDTOList() {
        when(reviewRepository.findByBook_Key(bookKey)).thenReturn(List.of(review));

        List<ReviewsDTO> dtos = reviewService.getReviewsByBook(bookKey);

        assertEquals(1, dtos.size());
        ReviewsDTO dto = dtos.get(0);
        assertEquals(review.getId(), dto.getId());
        assertEquals(review.getContent(), dto.getContent());
        assertEquals(review.getRating(), dto.getRating());
        assertEquals(person.getFullName(), dto.getPersonName());
    }

    @Test
    void testGetReviewsByPerson_ReturnsReviewList() {
        when(reviewRepository.findByPerson_Id(personId)).thenReturn(List.of(review));

        List<Review> reviews = reviewService.getReviewsByPerson(personId);

        assertEquals(1, reviews.size());
        assertEquals(review, reviews.get(0));
    }
}
