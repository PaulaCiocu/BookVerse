package com.licenta.bookverse.dto.books;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class ReadingListFollowedAndCretedDTO {
    private Long id;
    private String title;
    private String description;
    private String imageUrl;
    private boolean deleted;
    private Long trailId;
}
