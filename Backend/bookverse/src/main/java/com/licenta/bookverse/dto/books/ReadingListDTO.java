package com.licenta.bookverse.dto;

import com.licenta.bookverse.entity.Book;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

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

