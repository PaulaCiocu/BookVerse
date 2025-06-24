package com.licenta.bookverse.repository;

import com.licenta.bookverse.entity.Book;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface BookRepository extends JpaRepository<Book, String> {
//    List<Book> findByTitleContainingIgnoreCase(String title);
    Optional<Book> findByKey(String isbn);
    List<Book> findByTitleContainingIgnoreCaseOrAuthorContainingIgnoreCase(String title, String author);

  //  List<Book> findByAuthorContainingIgnoreCase(String author);
}
