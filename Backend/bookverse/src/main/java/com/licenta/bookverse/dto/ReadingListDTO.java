package com.licenta.bookverse.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.UUID;

@Getter
@Setter
public class AddToReadingListRequest {
    private String bookId; // Use UUID type if book_id is a UUID
    private UUID personId; // Assuming personId is a UUID
    private ReadingListStatus status; // Optional, default could be "Not Started"

    // Getters and Setters
}

