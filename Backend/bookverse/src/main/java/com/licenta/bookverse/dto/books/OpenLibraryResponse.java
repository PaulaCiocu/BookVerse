package com.licenta.bookverse.dto.books;

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
        private List<String> language;


        @JsonProperty("cover_i")
        private Integer coverId;

        public String getCoverUrl() {
            if (coverId != null) {
                return "https://covers.openlibrary.org/b/id/" + coverId + "-L.jpg";  // Return the large-size cover URL
            }
            return null;  // If no cover, return null
        }

        public String extractKeyFromDoc() {
            // The key format from Search API is like '/works/OL123456W'
            if (key != null && key.startsWith("/works/")) {
                return key.substring(7);  // Extract the work ID (after '/works/')
            }
            return null;
        }

        public String getAuthorFromDoc() {
            if (authorName != null && !authorName.isEmpty()) {
                return String.join(", ", authorName);
            } else {
                return "Unknown Author";
            }
        }




    }
}
