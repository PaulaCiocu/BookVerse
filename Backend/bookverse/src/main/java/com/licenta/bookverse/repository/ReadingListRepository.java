package com.licenta.bookverse.repository;

import com.licenta.bookverse.entity.Book;
import com.licenta.bookverse.entity.Person;
import com.licenta.bookverse.entity.ReadingList;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface ReadingListRepository extends JpaRepository<ReadingList, Integer> {
    List<ReadingList> findByPerson(Person user);

    @Query("SELECT r.book FROM ReadingList r WHERE r.person.id = :personId")
    List<Book> findBooksByPersonId(@Param("personId") UUID personId);

    boolean existsByPerson_IdAndBook_Key(UUID personId, String bookId);

    Optional<Object> findByPerson_IdAndBook_Key(UUID personId, String bookId);

    List<ReadingList> findByPersonId(UUID personId);

}
