package com.licenta.bookverse.service;

import com.licenta.bookverse.dto.OpenLibraryResponse;
import com.licenta.bookverse.dto.WorkDetailResponse;
import com.licenta.bookverse.entity.Book;
import com.licenta.bookverse.repository.BookRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class BookService {

    @Autowired
    private final BookRepository bookRepository;
    @Autowired
    private final GenreFilterService genreFilterService;

    @Autowired
    private RestTemplate restTemplate;

    private static final String OPEN_LIBRARY_SEARCH_API_URL = "https://openlibrary.org/search.json?q=";  // Search API URL
    private static final String OPEN_LIBRARY_WORKS_API_URL = "https://openlibrary.org/works/";  // Works API URL
    private static final String OPEN_LIBRARY_URL_SUBJECT = "https://openlibrary.org/search.json?subject=";
    private static final String OPEN_LIBRARY_ISBN_API_URL = "https://openlibrary.org/api/books?bibkeys=ISBN:";


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
            book.setIsbn_key(doc.getFirstValidIsbn());
            String isbn = doc.getFirstValidIsbn();
            book.setIsbn_key(isbn);
           // return isbn != null ? book : null;
            return book;
        })
        .filter(book -> book!= null)
        .collect(Collectors.toList());
    }

    private String extractKeyFromDoc(String key) {
        // The key format from Search API is like '/works/OL123456W'
        if (key != null && key.startsWith("/works/")) {
            return key.substring(7);  // Extract the work ID (after '/works/')
        }
        return null;
    }

    public Book getBookDetails(String bookKey, String isbn) {

        Optional<Book> existingBook = bookRepository.findByKey(bookKey);
        if (existingBook.isPresent()) {
            return existingBook.get();
        }

        String worksUrl = OPEN_LIBRARY_WORKS_API_URL + bookKey + ".json";  // Works API URL
        WorkDetailResponse bookDetails = restTemplate.getForObject(worksUrl, WorkDetailResponse.class);

        if (bookDetails != null) {
            Book book = mapToBookDetails(bookDetails);
            addIsbnDetails(book, isbn, bookKey);
            bookRepository.save(book);
            return book;
        }
        return null; // Return null or an appropriate response if book details are not found
    }

    private void addIsbnDetails(Book book, String isbn, String bookKey) {
        String isbnUrl = OPEN_LIBRARY_ISBN_API_URL + isbn + "&jscmd=data&format=json";
        book.setIsbn_key(isbn);
        book.setKey(bookKey);

        try {
            var response = restTemplate.getForObject(isbnUrl, Object.class);
            if (response == null) return;

            Map<String, Object> jsonMap = (Map<String, Object>) response;
            Map<String, Object> bookData = (Map<String, Object>) jsonMap.get("ISBN:" + isbn);
            if (bookData == null) return;

            book.setPublish_date((String) bookData.get("publish_date"));
            book.setPages((Integer) bookData.get("number_of_pages"));

            // Retrieve author information
            List<Map<String, Object>> authorsList = (List<Map<String, Object>>) bookData.get("authors");
            if (authorsList != null) {
                List<String> authorNames = new ArrayList<>();
                for (Map<String, Object> author : authorsList) {
                    String authorName = (String) author.get("name");
                    authorNames.add(authorName);
                }
                // Join author names with a comma
                String joinedAuthors = String.join(", ", authorNames);
                book.setAuthor(joinedAuthors); // Assuming you have this method in the Book class
            }

        } catch (Exception e) {
            System.out.println("Error fetching ISBN details: " + e.getMessage());
        }
    }
    private Book mapToBookDetails(WorkDetailResponse bookDetails) {
        Book book = new Book();
        book.setTitle(bookDetails.getTitle());
        List<String> filterSubject = genreFilterService.filterGenres(bookDetails.getSubjects());
        book.setSubjects(filterSubject);  // Assuming you have a method to handle genres
        book.setCoverImageUrl(bookDetails.getCoverUrl());
        book.setDescription(bookDetails.getDescription());

        return book;
    }





}
