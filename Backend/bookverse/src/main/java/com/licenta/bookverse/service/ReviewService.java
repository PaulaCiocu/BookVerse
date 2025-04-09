package com.licenta.bookverse.service;

import com.licenta.bookverse.entity.Book;
import com.licenta.bookverse.entity.Person;
import com.licenta.bookverse.entity.Review;
import com.licenta.bookverse.repository.BookRepository;
import com.licenta.bookverse.repository.PersonRepository;
import com.licenta.bookverse.repository.ReviewRepository;
import jakarta.persistence.criteria.CriteriaBuilder;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ReviewService {

    private final ReviewRepository reviewRepository;
    private final BookRepository bookRepository;
    private final PersonRepository personRepository;

    public Review addReview(UUID personId, String bookKey, String content, int rating) {
        Person person = personRepository.findById(personId)
                .orElseThrow(() -> new RuntimeException("Person not found"));

        Book book = bookRepository.findById(bookKey)
                .orElseThrow(() -> new RuntimeException("Book not found"));

        Review review = Review.builder()
                .person(person)
                .book(book)
                .content(content)
                .rating(rating)
                .build();

        return reviewRepository.save(review);
    }

    public List<Review> getReviewsByBook(String bookKey) {
        return reviewRepository.findByBook_Key(bookKey);
    }

    public List<Review> getReviewsByPerson(UUID personId) {
        return reviewRepository.findByPerson_Id(personId);
    }

    public void deleteReview(Integer reviewId) {
        reviewRepository.deleteById(reviewId);
    }
}
