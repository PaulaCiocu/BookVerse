package com.licenta.bookverse.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Getter;
import lombok.Setter;

import java.util.List;


public class OpenLibraryResponse {
    private List<Doc> docs;  // List of documents returned by the search query

    public List<Doc> getDocs() {
        return docs;
    }

    public void setDocs(List<Doc> docs) {
        this.docs = docs;
    }

    @Getter
    @Setter
    public static class Doc {
        private String key;
        private String title;

        @JsonProperty("author_name")
        private List<String> authorName;
        private List<String> subject;  // List of subjects/genres
        private String description;


        @JsonProperty("cover_i")
        private Integer coverId;

        public String getCoverUrl() {
            if (coverId != null) {
                return "https://covers.openlibrary.org/b/id/" + coverId + "-L.jpg";  // Return the large-size cover URL
            }
            return null;  // If no cover, return null
        }

    }
}
