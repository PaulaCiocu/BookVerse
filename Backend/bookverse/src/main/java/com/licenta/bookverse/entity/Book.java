package com.licenta.bookverse.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.List;
import java.util.UUID;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
public class Book {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;  // Or Long depending on your preference

    private String title;

    private String key;

    private String author;

    @ElementCollection
    private List<String> subjects;


    private String description;

    private String coverImageUrl;
}
