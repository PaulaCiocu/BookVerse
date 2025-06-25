package com.licenta.bookverse.controller;

import com.licenta.bookverse.entity.Book;
import com.licenta.bookverse.service.books.BookService;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/books")
@AllArgsConstructor
public class BookController {

    @Autowired
    private BookService bookService;

    @GetMapping("/search")
    public List<Book> searchBooks(@RequestParam String query) {
        if (query == null || query.isEmpty()) {
            throw new IllegalArgumentException("Field must not be empty");
        }
        return bookService.searchBooks(query);
    }

    @GetMapping("/searchByGenre")
    public ResponseEntity<List<Book>> searchBooksByGenre(@RequestParam String genre) {
        List<Book> books = bookService.searchBooksByGenre(genre);
        if (books.isEmpty()) {
            return ResponseEntity.noContent().build();  // Return 204 if no books are found
        }
        return ResponseEntity.ok(books);  // Return 200 with books found
    }

    @GetMapping("/search/author")
    public List<Book> getBooksByAuthor(@RequestParam String author) {
        return bookService.searchBooksByAuthor(author);
    }

    @GetMapping("/{bookKey}")
    public Book getBookDetails(@PathVariable String bookKey) {
        return bookService.getBookDetails(bookKey);
    }


}
