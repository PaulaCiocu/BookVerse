package com.licenta.bookverse.service;

import com.licenta.bookverse.dto.books.responses.EditionResponse;
import com.licenta.bookverse.dto.books.responses.OpenLibraryResponse;
import com.licenta.bookverse.dto.books.responses.WorkDetailResponse;
import com.licenta.bookverse.entity.Book;
import com.licenta.bookverse.repository.BookRepository;
import com.licenta.bookverse.service.books.BookService;
import com.licenta.bookverse.service.books.GenreFilterService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.web.client.RestTemplate;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class BookServiceTest {

    @Mock
    private BookRepository bookRepository;

    @Mock
    private GenreFilterService genreFilterService;

    @Mock
    private RestTemplate restTemplate;

    private BookService bookService;

    @BeforeEach
    void setup() {
        // Manual constructor injection because of @RequiredArgsConstructor in BookService
        bookService = new BookService(bookRepository, genreFilterService, restTemplate);
    }

    @Test
    void getBookDetails_ReturnsFromDatabase_WhenExists() {
        Book savedBook = new Book();
        savedBook.setKey("OL123");
        savedBook.setTitle("Book Title");

        when(bookRepository.findByKey("OL123")).thenReturn(Optional.of(savedBook));

        Book result = bookService.getBookDetails("OL123");

        assertNotNull(result);
        assertEquals("Book Title", result.getTitle());
        verify(bookRepository, never()).save(any());
    }

    @Test
    void getBookDetails_FetchesFromApi_WhenNotInDatabase() {
        String bookKey = "OL12345W";
        String worksUrl = "https://openlibrary.org/works/" + bookKey + ".json";

        // DB returns empty
        when(bookRepository.findByKey(bookKey)).thenReturn(Optional.empty());

        // Mock API work details
        WorkDetailResponse workDetail = new WorkDetailResponse();
        workDetail.setTitle("Remote Book");
        workDetail.setSubjects(List.of("Fantasy"));
        workDetail.setDescription("Magic and dragons.");
        workDetail.setCoverId(List.of(101));

        when(restTemplate.getForObject(worksUrl, WorkDetailResponse.class)).thenReturn(workDetail);
        when(genreFilterService.filterGenres(List.of("Fantasy"))).thenReturn(List.of("Fantasy"));
        when(bookRepository.save(any(Book.class))).thenAnswer(invocation -> invocation.getArgument(0));

        Book result = bookService.getBookDetails(bookKey);

        assertNotNull(result);
        assertEquals("Remote Book", result.getTitle());
        assertTrue(result.getSubjects().contains("Fantasy"));
        verify(bookRepository).save(any(Book.class));
    }

    @Test
    void searchBooks_ReturnsFromDatabase_WhenFound() {
        Book cachedBook = new Book();
        cachedBook.setKey("OL123");
        cachedBook.setTitle("Harry Potter");
        cachedBook.setAuthor("J.K. Rowling");

        when(bookRepository.findByTitleContainingIgnoreCaseOrAuthorContainingIgnoreCase("Harry", "Harry"))
                .thenReturn(List.of(cachedBook));

        List<Book> result = bookService.searchBooks("Harry");

        assertEquals(1, result.size());
        assertEquals("Harry Potter", result.get(0).getTitle());
        verify(restTemplate, never()).getForObject(anyString(), eq(OpenLibraryResponse.class));
    }

    @Test
    void searchBooks_CallsExternalApiAndReturnsMappedBooks_WhenNotInDatabase() {
        String query = "Tolkien";
        String expectedUrl = "https://openlibrary.org/search.json?q=" + query;

        // Simulate no match in database
        when(bookRepository.findByTitleContainingIgnoreCaseOrAuthorContainingIgnoreCase(query, query))
                .thenReturn(List.of());

        // Prepare a fake OpenLibraryResponse
        OpenLibraryResponse mockResponse = new OpenLibraryResponse();
        OpenLibraryResponse.Doc doc = new OpenLibraryResponse.Doc();
        doc.setKey("/works/OL12345W");
        doc.setTitle("The Hobbit");
        doc.setAuthorName(List.of("J.R.R. Tolkien"));
        doc.setLanguage(List.of("eng"));
        doc.setCoverId(123);
        mockResponse.setDocs(List.of(doc));

        when(restTemplate.getForObject(expectedUrl, OpenLibraryResponse.class)).thenReturn(mockResponse);

        List<Book> result = bookService.searchBooks(query);

        assertEquals(1, result.size());
        Book book = result.get(0);
        assertEquals("The Hobbit", book.getTitle());
        assertEquals("J.R.R. Tolkien", book.getAuthor());
        assertTrue(book.getCoverImageUrl().contains("123")); // if the cover URL is derived from the cover ID

        verify(bookRepository).findByTitleContainingIgnoreCaseOrAuthorContainingIgnoreCase(query, query);
        verify(restTemplate).getForObject(expectedUrl, OpenLibraryResponse.class);
    }

    @Test
    void searchBooksByGenre_ReturnsBooks_WhenApiReturnsResults() {
        String genre = "Fantasy";
        String url = "https://openlibrary.org/search.json?subject=" + genre;

        OpenLibraryResponse.Doc doc = new OpenLibraryResponse.Doc();
        doc.setKey("/works/OL999W");
        doc.setTitle("Fantasy Novel");
        doc.setAuthorName(List.of("Author A"));
        doc.setLanguage(List.of("eng"));
        doc.setCoverId(555);

        OpenLibraryResponse response = new OpenLibraryResponse();
        response.setDocs(List.of(doc));

        when(restTemplate.getForObject(url, OpenLibraryResponse.class)).thenReturn(response);

        List<Book> result = bookService.searchBooksByGenre(genre);

        assertEquals(1, result.size());
        assertEquals("Fantasy Novel", result.get(0).getTitle());
    }

    @Test
    void searchBooksByAuthor_ReturnsBooks_WhenApiReturnsResults() {
        String author = "George Orwell";
        String url = "https://openlibrary.org/search.json?author=" + author;

        OpenLibraryResponse.Doc doc = new OpenLibraryResponse.Doc();
        doc.setKey("/works/OL1984W");
        doc.setTitle("1984");
        doc.setAuthorName(List.of("George Orwell"));
        doc.setLanguage(List.of("eng"));
        doc.setCoverId(777);

        OpenLibraryResponse response = new OpenLibraryResponse();
        response.setDocs(List.of(doc));

        when(restTemplate.getForObject(url, OpenLibraryResponse.class)).thenReturn(response);

        List<Book> result = bookService.searchBooksByAuthor(author);

        assertEquals(1, result.size());
        assertEquals("1984", result.get(0).getTitle());
    }
    @Test
    void searchBooks_ReturnsEmptyList_WhenApiResponseIsNull() {
        String query = "nonexistent";
        String url = "https://openlibrary.org/search.json?q=" + query;

        when(bookRepository.findByTitleContainingIgnoreCaseOrAuthorContainingIgnoreCase(query, query))
                .thenReturn(List.of());

        when(restTemplate.getForObject(url, OpenLibraryResponse.class)).thenReturn(null);

        List<Book> result = bookService.searchBooks(query);

        assertNotNull(result);
        assertTrue(result.isEmpty());
    }


}
