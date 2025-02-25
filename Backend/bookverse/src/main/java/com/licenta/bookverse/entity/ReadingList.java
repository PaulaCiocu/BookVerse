package com.licenta.bookverse.entity;

import com.licenta.bookverse.dto.ReadingListStatus;
import jakarta.persistence.*;
import jdk.jshell.Snippet;
import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Entity
public class ReadingList {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "person_id")
    private Person person;

    @ManyToOne
    private Book book;

    @Enumerated(EnumType.STRING)
    private ReadingListStatus status; // e.g., "Not Started", "In Progress", "Completed"

    private int pagesRead = 0;
}
