package com.licenta.bookverse.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;

import java.util.UUID;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Achievement {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "person_id", nullable = false)
    @JsonIgnore
    private Person person;

    private int totalBooksRead = 0;
    private int bookInProgress = 0;
    private int totalTrailsCompleted = 0;
    private int trailsInProgress = 0;
    private int totalPagesRead = 0;

    public UUID getPersonId() {
        return person != null ? person.getId() : null;
    }

}
