package com.licenta.bookverse.repository;

import com.licenta.bookverse.entity.TrailBook;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TrailBookRepository extends JpaRepository<TrailBook, Long> {


    TrailBook findByBook_Key(String bookKey);
}
