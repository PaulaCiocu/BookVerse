package com.licenta.bookverse.service.books;

import com.licenta.bookverse.dto.books.responses.EditionResponse;
import com.licenta.bookverse.dto.books.responses.OpenLibraryResponse;
import com.licenta.bookverse.dto.books.responses.WorkDetailResponse;
import com.licenta.bookverse.entity.Book;
import com.licenta.bookverse.repository.BookRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.List;
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
    private static final String OPEN_LIBRARY_URL_AUTHOR = "https://openlibrary.org/search.json?author="; // Author API URL


    public List<Book> searchBooks(String query) {
        // First, check if books matching the query already exist in the database
        List<Book> booksFromDb = bookRepository.findByTitleContainingIgnoreCaseOrAuthorContainingIgnoreCase( query, query);
        if (!booksFromDb.isEmpty()) {
            return booksFromDb; // Return books from the database if found
        }
        String searchUrl = OPEN_LIBRARY_SEARCH_API_URL + query;
        return searchBooksFromApi(searchUrl);
    }
    public List<Book> searchBooksByGenre(String genre) {
        String subjectUrl = OPEN_LIBRARY_URL_SUBJECT + genre;  // Construct the subject/genre URL
        return searchBooksFromApi(subjectUrl);
    }
    public List<Book> searchBooksByAuthor(String author) {
        // First, check if books matching the author already exist in the database
//        List<Book> booksFromDb = bookRepository.findByAuthorContainingIgnoreCase(author);
//        if (!booksFromDb.isEmpty()) {
//            return booksFromDb; // Return books from the database if found
//        }
        String authorUrl = OPEN_LIBRARY_URL_AUTHOR + author;  // Construct the author search URL
        return searchBooksFromApi(authorUrl);
    }

    private List<Book> searchBooksFromApi(String url) {
        OpenLibraryResponse response = restTemplate.getForObject(url, OpenLibraryResponse.class);
        if (response == null || response.getDocs() == null) {
            return List.of();
        }
        return mapToBookListFromSearchApi(response);
    }
    private List<Book> mapToBookListFromSearchApi(OpenLibraryResponse response) {
        return response.getDocs().stream()
                //return only the books in english or romanian
                .filter(doc -> doc.getLanguage() != null && doc.getLanguage().stream()
                        .anyMatch(lang -> "eng".equalsIgnoreCase(lang) || "rum".equalsIgnoreCase(lang)))
                .filter(doc -> doc.getTitle() != null && doc.getTitle().matches("^[A-Za-z0-9\\s.,'’!?()\"-]+$"))
                .filter(doc -> doc.getAuthorFromDoc() != null && doc.getAuthorFromDoc().matches("^[A-Za-z0-9\\s.,'’!?()\"-]+$"))
                .filter(doc -> !containsExcludedWords(doc.getTitle()))
                .filter(doc -> doc.getCoverUrl() != null)
                .map(doc -> {
                    Book book = new Book();
                    book.setKey(doc.extractKeyFromDoc());
                    book.setTitle(cleanText(doc.getTitle()));
                    book.setAuthor(doc.getAuthorFromDoc());
                    book.setCoverImageUrl(doc.getCoverUrl());
                    return book;
                })
                .collect(Collectors.toList());
    }



    public Book getBookDetails(String bookKey) {

        Optional<Book> existingBook = bookRepository.findByKey(bookKey);
        if (existingBook.isPresent()) {
            return existingBook.get();
        }

        return mapToBookDetails(bookKey);
    }


    private Book mapToBookDetails(String bookKey) {
        String worksUrl = OPEN_LIBRARY_WORKS_API_URL + bookKey + ".json";  // Works API URL
        WorkDetailResponse bookDetails = restTemplate.getForObject(worksUrl, WorkDetailResponse.class);

        if (bookDetails == null) {
            return null; // Handle the case where book details are not found
        }

        Book book = new Book();

        book.setKey(bookKey);
        book.setTitle(cleanText(bookDetails.getTitle()));
        List<String> filterSubject = genreFilterService.filterGenres(bookDetails.getSubjects());
        book.setSubjects(filterSubject);
        book.setCoverImageUrl(bookDetails.getCoverUrl());
        book.setDescription(cleanText(bookDetails.getDescription()));


        addEditionDetails(book, bookKey);

        bookRepository.save(book);
        return book;
    }

    private void addEditionDetails(Book book, String bookKey) {
        String editionsUrl = "https://openlibrary.org/works/" + bookKey + "/editions.json";
        EditionResponse response = restTemplate.getForObject(editionsUrl, EditionResponse.class);

        if (response == null || response.getEntries() == null || response.getEntries().isEmpty()) {
            System.out.println("No editions found.");
            return;
        }

        boolean foundPages = false;
        for (EditionResponse.EditionEntry edition : response.getEntries()) {
            if (edition.getNumberOfPages() != null) {
                book.setPages(edition.getNumberOfPages());
                foundPages = true;
            }
            book.setPublish_date(edition.getPublishDate());
            book.setLanguage(edition.getLanguage(restTemplate));
            if (foundPages && edition.getLanguage(restTemplate)!=null ) break;
        }
        for (EditionResponse.EditionEntry edition : response.getEntries()) {
            if (edition.getAuthors(restTemplate) != null) {
                book.setAuthor(edition.getAuthors(restTemplate));
                break;
            }
        }

    }

    private String cleanText(String text) {
        if (text == null) return null;
        return text.replace("\u2019", "'")  // Curly apostrophe → regular apostrophe
                .replace("\u201C", "\"") // Left curly quote → regular quote
                .replace("\u201D", "\"") // Right curly quote → regular quote
                .replace("\u2013", "-")  // En dash → hyphen
                .replace("\u2014", "-")  // Em dash → hyphen
                .replaceAll("[^\\p{Print}]", ""); // Remove non-printable characters
    }

    private boolean containsExcludedWords(String title) {
        String[] excludedWords = {"set", "box", "collection", "series", "coloring", "edition", "movie", "screenplay", "appendices", "instrumental"};
        for (String word : excludedWords) {
            if (title.toLowerCase().contains(word)) {
                return true;
            }
        }
        return false;
    }



}
