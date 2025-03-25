package com.licenta.bookverse.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Achievements {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "person_id", nullable = false)
    @JsonIgnore
    private Person person;

    private int totalBooksRead;
    private int totalTrailsCompleted;
    private int totalPagesRead;
}
