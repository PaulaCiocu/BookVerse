package com.licenta.bookverse.dto;

import com.fasterxml.jackson.annotation.JsonCreator;
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

        @JsonProperty("ia")
        private List<String> ia; //key to get nr_pages and published date

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

        public String getFirstValidIsbn() {
            if (ia != null) {
                for (String entry : ia) {
                    if (entry.startsWith("isbn_")) {
                        String isbn = entry.substring(5); // Remove "isbn_" prefix
                        if (isValidIsbn13(isbn)) {
                            return isbn; // Return the first valid ISBN-13 found
                        }
                    }
                }
            }
            return null; // No valid ISBN-13 found
        }

        private boolean isValidIsbn13(String isbn) {
            return isbn.matches("\\d{13}"); // Check if it's exactly 13 digits
        }

    }
}
