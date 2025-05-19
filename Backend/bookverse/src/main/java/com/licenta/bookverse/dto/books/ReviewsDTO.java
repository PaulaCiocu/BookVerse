package com.licenta.bookverse.dto.books;


import com.licenta.bookverse.entity.Book;
import com.licenta.bookverse.entity.Person;
import jakarta.persistence.Column;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ReviewsDTO {
    private Integer id;
    private String personName;
    private String bookId;
    private String content;
    private int rating;
}
