package com.licenta.bookverse.dto;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Getter;
import lombok.Setter;
import org.springframework.web.client.RestTemplate;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Getter
@Setter
public class WorkDetailResponse {
    private String title;
    private List<AuthorWrapper> authors;  // List of AuthorWrapper to hold multiple authors
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


    // Method to get all author names
    public List<String> getAuthorNames(RestTemplate restTemplate) {
        return authors.stream()
                .map(authorWrapper -> authorWrapper.getAuthorName(restTemplate))  // Fetch name for each author
                .collect(Collectors.toList());  // Collect into a list
    }

    @Getter
    @Setter
    public static class AuthorWrapper {
        private Author author;  // The author object itself

        // Get the key of the author
        public String getAuthorKey() {
            return author != null ? author.getKey() : null;
        }

        // Get the author name using the key
        public String getAuthorName(RestTemplate restTemplate) {
            if (author != null && author.getKey() != null) {
                String authorUrl = "https://openlibrary.org" + author.getKey() + ".json";  // Construct the URL for the author details
                AuthorDetails authorDetails = restTemplate.getForObject(authorUrl, AuthorDetails.class);

                // Return the author's name if it's found
                if (authorDetails != null && authorDetails.getName() != null) {
                    return authorDetails.getName();
                }
            }
            return "Unknown author";  // Return a default value if no author key exists
        }
    }

    @Getter
    @Setter
    public static class Author {
        private String key;  // The key for the author
    }

    @Getter
    @Setter
    public static class AuthorDetails {
        private String name;  // The name of the author
    }
}
