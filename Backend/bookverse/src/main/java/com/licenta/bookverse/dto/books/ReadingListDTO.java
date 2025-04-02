package com.licenta.bookverse.dto.books;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class ReadingListDTO {

    private String bookKey;
    private String title;
    private String author;
    private String coverImageUrl;
    private int pagesRead;
    private int totalPages;
}

