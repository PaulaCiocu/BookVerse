package com.licenta.bookverse.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
public class Review {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "person_id", nullable = false)
    private Person person;

    @ManyToOne
    @JoinColumn(name = "book_key", nullable = false)
    private Book book;

    @Column(nullable = false, length = 5000)
    private String content;

    @Column(nullable = false)
    private int rating; // Rating from 1 to 5

    private LocalDateTime createdAt = LocalDateTime.now();
}
