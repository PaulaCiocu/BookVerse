package com.licenta.bookverse.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;

import java.util.UUID;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
public class TrailBook {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "trail_id", nullable = false)
    @JsonIgnore // Prevent serialization to avoid infinite loop
    private Trail trail; // Reference to the trail

    @ManyToOne
    @JoinColumn(name = "book_id", nullable = false)
    private Book book; // Reference to the book

    private Integer orderIndex; // Order of the book in the trail
}
