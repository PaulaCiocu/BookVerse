package com.licenta.bookverse.service.books;

import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class GenreFilterService {
    private static final Map<String, List<String>> GENRE_KEYWORDS = Map.ofEntries(
            Map.entry("Fantasy", List.of("Fantasy", "Magic", "Myth")),
            Map.entry("Science Fiction", List.of("Science Fiction", "Sci-Fi")),
            Map.entry("Romance", List.of("Love", "Romance")),
            Map.entry("Thriller", List.of("Thriller", "Murder", "Suspense")),
            Map.entry("Mystery", List.of("Mystery", "Detective", "Investigation")),
            Map.entry("Horror", List.of("Horror", "Ghost", "Supernatural")),
            Map.entry("Historical Fiction", List.of("Historical", "Ancient", "Past")),
            Map.entry("Young Adult", List.of("Young Adult", "Juvenile Fiction")),
            Map.entry("Action & Adventure", List.of("Action", "Adventure", "Quest")),
            Map.entry("Drama", List.of("Drama", "Emotional", "Psychological")),
            Map.entry("Comedy", List.of("Comedy", "Humor", "Funny")),
            Map.entry("Non-Fiction", List.of("Biography", "Self-help", "History"))
    );

    public List<String> filterGenres(List<String> subjects) {
        if (subjects == null) {
            return Collections.emptyList(); // Return an empty list if subjects is null
        }

        Set<String> filteredGenres = new HashSet<>();

        for (String subject : subjects) {
            String lowerCaseSubject = subject.toLowerCase();
            for (Map.Entry<String, List<String>> entry : GENRE_KEYWORDS.entrySet()) {
                // Check if any keyword for this genre is present in the subject
                boolean found = entry.getValue().stream()
                        .anyMatch(keyword -> lowerCaseSubject.contains(keyword.toLowerCase()));
                if (found) {
                    filteredGenres.add(entry.getKey());
                }
            }
        }

        return new ArrayList<>(filteredGenres);
    }


}
