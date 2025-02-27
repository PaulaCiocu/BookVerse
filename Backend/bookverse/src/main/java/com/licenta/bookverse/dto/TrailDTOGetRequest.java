package com.licenta.bookverse.dto;

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

        private String title;
        private String description;
        private UUID creatorId;
        private List<String> genre;
        private List<TrailBook> trailBookList;
        private Integer numberOfReadings;

}
