package com.licenta.bookverse.service;

import com.licenta.bookverse.dto.OpenLibraryResponse;
import com.licenta.bookverse.dto.WorkDetailResponse;
import com.licenta.bookverse.entity.Book;
import com.licenta.bookverse.repository.BookRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class BookService {

    @Autowired
    private final BookRepository bookRepository;

    @Autowired
    private RestTemplate restTemplate;

    private static final String OPEN_LIBRARY_SEARCH_API_URL = "https://openlibrary.org/search.json?q=";  // Search API URL
    private static final String OPEN_LIBRARY_WORKS_API_URL = "https://openlibrary.org/works/";  // Works API URL
    private static final String OPEN_LIBRARY_URL_SUBJECT = "https://openlibrary.org/search.json?subject=";


    public List<Book> searchBooks(String query) {
        return searchBooksFromSearchApi(query);
    }

    public List<Book> searchBooksByGenre(String genre) {
        return searchBooksFromSubjectApi(genre);
    }

    private List<Book> searchBooksFromSubjectApi(String genre) {
        String subjectUrl = OPEN_LIBRARY_URL_SUBJECT + genre;  // Construct the subject/genre URL
        OpenLibraryResponse subjectResponse = restTemplate.getForObject(subjectUrl, OpenLibraryResponse.class);
        if (subjectResponse == null || subjectResponse.getDocs() == null) {
            return List.of();
        }
        return mapToBookListFromSearchApi(subjectResponse);
    }

    private List<Book> searchBooksFromSearchApi(String query) {
        String searchUrl = OPEN_LIBRARY_SEARCH_API_URL + query;  // Construct the search URL
        OpenLibraryResponse searchResponse = restTemplate.getForObject(searchUrl, OpenLibraryResponse.class);
        if (searchResponse == null || searchResponse.getDocs() == null) {
            return List.of();
        }
        return mapToBookListFromSearchApi(searchResponse);
    }

    private List<Book> mapToBookListFromSearchApi(OpenLibraryResponse response) {
        return response.getDocs().stream().map(doc -> {
            Book book = new Book();

            String workId = extractKeyFromDoc(doc.getKey());
            book.setKey(workId);
            book.setTitle(doc.getTitle());
            if (doc.getAuthorName() != null && !doc.getAuthorName().isEmpty()) {
                book.setAuthor(String.join(", ", doc.getAuthorName()));
            } else {
                book.setAuthor("Unknown Author");
            }
            String coverUrl = doc.getCoverUrl();
            book.setCoverImageUrl(coverUrl);

            return book;
        }).collect(Collectors.toList());
    }

    private String extractKeyFromDoc(String key) {
        // The key format from Search API is like '/works/OL123456W'
        if (key != null && key.startsWith("/works/")) {
            return key.substring(7);  // Extract the work ID (after '/works/')
        }
        return null;
    }

    public Book getBookDetails(String bookKey) {
        String worksUrl = OPEN_LIBRARY_WORKS_API_URL + bookKey + ".json";  // Works API URL
        WorkDetailResponse bookDetails = restTemplate.getForObject(worksUrl, WorkDetailResponse.class);

        if (bookDetails != null) {
            return mapToBookDetails(bookDetails);
        }
        return null; // Return null or an appropriate response if book details are not found
    }
    private Book mapToBookDetails(WorkDetailResponse bookDetails) {
        Book book = new Book();
        book.setTitle(bookDetails.getTitle());
        book.setSubjects(bookDetails.getSubjects());  // Assuming you have a method to handle genres
        book.setCoverImageUrl(bookDetails.getCoverUrl());
        book.setDescription(bookDetails.getDescription());
        // Check if the book details contain authors
        if (bookDetails.getAuthors() != null && !bookDetails.getAuthors().isEmpty()) {
            // Extract the author key from the first element in the authors list
            String authorKey = bookDetails.getAuthors().get(0).getAuthorKey();  // Get the key from the nested author object
            //String authorName = bookDetails.getAuthors().get(0).getAuthorName(restTemplate);
            // Get the list of author names
            List<String> authorNames = bookDetails.getAuthorNames(restTemplate);
            if (authorKey != null && !authorKey.isEmpty()) {
                // Set the author key in the Book object (instead of trying to fetch the author name here)
                book.setAuthor(String.join(", ", authorNames));
            } else {
                book.setAuthor("Unknown Author");  // If the key is null, set it as Unknown
            }
        } else {
            book.setAuthor("Unknown Author");  // No author info available
        }

        return book;
    }





}
