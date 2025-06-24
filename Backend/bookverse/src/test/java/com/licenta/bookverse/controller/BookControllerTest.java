package com.licenta.bookverse.controller;

import com.licenta.bookverse.entity.Book;
import com.licenta.bookverse.service.books.BookService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class BookControllerTest {

    private BookService bookService;
    private BookController bookController;

    @BeforeEach
    void setUp() {
        bookService = mock(BookService.class);
        bookController = new BookController(bookService); // constructor injection
    }

    @Test
    void searchBooks_WithValidQuery_ReturnsBooks() {
        Book book = new Book();
        book.setTitle("Clean Code");

        when(bookService.searchBooks("clean")).thenReturn(List.of(book));

        List<Book> result = bookController.searchBooks("clean");

        assertEquals(1, result.size());
        assertEquals("Clean Code", result.get(0).getTitle());
        verify(bookService).searchBooks("clean");
    }

    @Test
    void searchBooks_WithEmptyQuery_ThrowsException() {
        assertThrows(IllegalArgumentException.class, () -> bookController.searchBooks(""));
    }

    @Test
    void searchBooksByGenre_WithResults_ReturnsOk() {
        Book book = new Book();
        book.setTitle("Epic Fantasy");

        when(bookService.searchBooksByGenre("fantasy")).thenReturn(List.of(book));

        var response = bookController.searchBooksByGenre("fantasy");

        assertEquals(200, response.getStatusCodeValue());
        assertEquals(1, response.getBody().size());
        verify(bookService).searchBooksByGenre("fantasy");
    }

    @Test
    void searchBooksByGenre_EmptyResult_ReturnsNoContent() {
        when(bookService.searchBooksByGenre("unknown")).thenReturn(List.of());

        var response = bookController.searchBooksByGenre("unknown");

        assertEquals(204, response.getStatusCodeValue());
    }

    @Test
    void getBooksByAuthor_ReturnsBooks() {
        Book book = new Book();
        book.setTitle("1984");

        when(bookService.searchBooksByAuthor("Orwell")).thenReturn(List.of(book));

        List<Book> result = bookController.getBooksByAuthor("Orwell");

        assertEquals(1, result.size());
        assertEquals("1984", result.get(0).getTitle());
    }

    @Test
    void getBookDetails_ReturnsBook() {
        Book book = new Book();
        book.setKey("OL123W");
        book.setTitle("Brave New World");

        when(bookService.getBookDetails("OL123W")).thenReturn(book);

        Book result = bookController.getBookDetails("OL123W");

        assertEquals("Brave New World", result.getTitle());
        assertEquals("OL123W", result.getKey());
        verify(bookService).getBookDetails("OL123W");
    }
}
