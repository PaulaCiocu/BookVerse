package com.licenta.bookverse.entity;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.licenta.bookverse.dto.ReadingListStatus;
import com.licenta.bookverse.dto.books.CreatedType;
import jakarta.persistence.*;
import lombok.*;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Entity
public class ReadingTrailList {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "person_id")
    @JsonIgnore // Prevent serialization to avoid infinite loop
    private Person person; // The person who added the trail

    @ManyToOne
    private Trail trail; // The trail that was added to the list

    @Enumerated(EnumType.STRING)
    private ReadingListStatus status; // e.g., "Not Started", "In Progress", "Completed"

    @Enumerated(EnumType.STRING)
    private CreatedType createdType; // "Created" or "Followed"

    private int progress = 0; // For example, number of books read within the trail or other progress criteria
}

