package com.licenta.bookverse.dto;

import com.licenta.bookverse.entity.Book;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class ReadingListDTO {
    private Book book;
    private ReadingListStatus status; // Optional, default could be "Not Started"
    private int pagesRead;
    // Getters and Setters
}

