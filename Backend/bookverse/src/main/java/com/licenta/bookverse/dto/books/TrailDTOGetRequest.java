package com.licenta.bookverse.dto.books;

import com.licenta.bookverse.entity.TrailBook;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.util.List;
import java.util.UUID;

@Getter
@Setter
@Builder
public class TrailDTOGetRequest {
        private Long trailId;
        private String title;
        private String description;
        private UUID creatorId;
        private String personName;
        private Integer numberOfReadings;
        private String imageUrl;
}
