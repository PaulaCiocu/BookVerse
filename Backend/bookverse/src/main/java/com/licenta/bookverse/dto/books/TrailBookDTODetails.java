package com.licenta.bookverse.dto.books;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class TrailBookDTODetails {
    private Long id;
    private String bookKey;
    private String title;
    private String author;
    private String coverImageUrl;
}
