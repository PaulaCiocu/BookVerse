package com.licenta.bookverse.dto.books;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.util.List;
import java.util.UUID;

@Getter
@Setter
@Builder
public class   TrailDTO {
    private String title;
    private String description;
    private UUID creatorId;
    private List<BookOrderDTO> books; // List of books with their order
    private String imageUrl;

    @Getter
    @Setter
    public static class BookOrderDTO {
        private String bookKey; // Book ID
    }
}