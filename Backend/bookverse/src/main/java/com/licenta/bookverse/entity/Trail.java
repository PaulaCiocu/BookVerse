package com.licenta.bookverse.entity;


import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Entity
public class Trail {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "person_id", nullable = false)
    private Person creator; // The person who created the trail

    @Column(nullable = false)
    private String title; // Title of the trail

    @Column(length = 2000)
    private String description; // Description of the trail

    private Integer numberOfReadings = 0; // Number of times the trail has been followed

    @ElementCollection
    @CollectionTable(name = "trail_genres", joinColumns = @JoinColumn(name = "trail_id"))
    @Column(name = "genre")
    private List<String> genres; // Genres based on books in the trail

    @OneToMany(mappedBy = "trail", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<TrailBook> trailBooks = new ArrayList<>(); // Initialize the list


}
