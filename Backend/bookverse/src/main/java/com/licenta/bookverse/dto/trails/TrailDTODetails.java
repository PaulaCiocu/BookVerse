package com.licenta.bookverse.dto.trails;

import com.licenta.bookverse.dto.trailbooks.TrailBookDTODetails;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.util.List;
import java.util.UUID;

@Getter
@Setter
@Builder
public class TrailDTODetails {
    private Long trailId;
    private String title;
    private String description;
    private UUID creatorId;
    private String personName;
    private List<String> genre;
    private List<TrailBookDTODetails> trailBookDTODetails;
    private Integer numberOfReadings;
    private String imageUrl;
}

