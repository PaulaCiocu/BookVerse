package com.licenta.bookverse.dto.books;

import lombok.*;

import java.util.UUID;


@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ReadingTrailListDTO {
    private Long id;
    private UUID personId;
    private TrailDTO trail;
    private String createdType;
    private int totalBooks;
    private int progress;
}
