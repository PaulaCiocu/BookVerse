package com.licenta.bookverse.dto.books.responses;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Getter;
import lombok.Setter;

import java.util.List;
import java.util.Map;

@Getter
@Setter
public class WorkDetailResponse {
    private String title;
    private List<String> subjects;

    @JsonProperty("description")
    private Object description;

    @JsonProperty("covers")
    private List<Integer> coverId;

    public String getCoverUrl() {
        if (coverId != null) {
            return "https://covers.openlibrary.org/b/id/" + coverId.get(0) + "-L.jpg";  // Return the large-size cover URL
        }
        return null;  // If no cover, return null
    }


    public String getDescription() {
        if (description instanceof String) {
            return (String) description;  // If the description is a simple string, return it
        } else if (description instanceof Map) {
            Map<String, Object> descMap = (Map<String, Object>) description;
            Object value = descMap.get("value");
            if (value instanceof String) {
                return (String) value;  // If the "value" field exists, return it as a string
            }
        }
        return null;  // If no description, return null
    }


}
