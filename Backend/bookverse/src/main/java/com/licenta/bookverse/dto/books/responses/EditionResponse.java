package com.licenta.bookverse.dto.books.responses;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Getter;
import lombok.Setter;
import org.springframework.web.client.RestTemplate;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Getter
@Setter
public class EditionResponse {
    private List<EditionEntry> entries;

    @Getter
    @Setter
    public static class EditionEntry {
        @JsonProperty("number_of_pages")
        private Integer numberOfPages;

        @JsonProperty("publish_date")
        private String publishDate;

        private List<Author> authors;
        private List<Language> languages;

        public String getLanguage(RestTemplate restTemplate) {
            if (languages != null && !languages.isEmpty()) {
                for (Language language : languages) { // Assuming 'Language' is your language class
                    String languageKey = language.getKey();
                    String languageUrl = "https://openlibrary.org" + languageKey + ".json";
                    try {
                        Map<String, Object> responseLanguage = restTemplate.getForObject(languageUrl, Map.class);
                        if (responseLanguage != null && responseLanguage.containsKey("name")) {
                            String languageName = (String) responseLanguage.get("name");
                            // Return if it's English or Romanian
                            if (languageName.equalsIgnoreCase("English") || languageName.equalsIgnoreCase("Romanian")) {
                                return languageName; // Return valid language
                            }
                        }
                    } catch (Exception e) {
                        System.out.println("Error fetching language details: " + e.getMessage());
                    }
                }
            }
            return null; // Return null if no valid language is found
        }


        public String getAuthors(RestTemplate restTemplate) {
            if (authors != null && !authors.isEmpty()) {
                List<String> authorNames = new ArrayList<>();
                for (Author author : authors) {
                    String authorUrl = "https://openlibrary.org" + author.getKey() + ".json";
                    try {
                        Map<String, Object> responseAuthor = restTemplate.getForObject(authorUrl, Map.class);
                        if (responseAuthor != null && responseAuthor.containsKey("name")) {
                            authorNames.add((String) responseAuthor.get("name"));
                        }
                    } catch (Exception e) {
                        System.out.println("Error fetching author details: " + e.getMessage());
                    }
                }
                return authorNames.isEmpty() ? null : String.join(", ", authorNames);
            }
            return null;
        }
    }

    @Getter
    @Setter
    public static class Author {
        private String key;
    }

    @Getter
    @Setter
    public static class Language {
        private String key;
    }
}
