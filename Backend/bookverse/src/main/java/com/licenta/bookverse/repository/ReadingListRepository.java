package com.licenta.bookverse.repository;

import com.licenta.bookverse.dto.books.ReadingListDTO;
import com.licenta.bookverse.dto.books.enums.ReadingListStatus;
import com.licenta.bookverse.entity.Book;
import com.licenta.bookverse.entity.Person;
import com.licenta.bookverse.entity.ReadingList;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface ReadingListRepository extends JpaRepository<ReadingList, Integer> {
    List<ReadingList> findByPerson(Person user);

    @Query("SELECT new com.licenta.bookverse.dto.books.ReadingListDTO(r.book.key, r.book.title, r.book.author, r.book.coverImageUrl, r.pagesRead, r.book.pages) " +
            "FROM ReadingList r WHERE r.person.id = :personId")
    List<ReadingListDTO> findBooksByPersonId(@Param("personId") UUID personId);

    boolean existsByPerson_IdAndBook_Key(UUID personId, String bookId);

    Optional<Object> findByPerson_IdAndBook_Key(UUID personId, String bookId);

    Optional<ReadingList> findByPersonAndBook(Person person, Book book);

    int countByPersonIdAndStatus(UUID personId, ReadingListStatus readingListStatus);

    List<ReadingList> findByPersonIdAndStatus(UUID personId, ReadingListStatus status);

}
