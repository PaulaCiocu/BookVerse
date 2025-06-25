package com.licenta.bookverse.dto.trailbooks;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
@AllArgsConstructor
public class TrailBookDTO {
    private Long id;
    private String bookKey; // OpenLibrary key
    private String title;
    private String author;
    private int pages;
    private String publishDate;
    private String language;
    private String description;
    private String coverImageUrl;
    private int orderIndex; // The order of the book in the trail
}