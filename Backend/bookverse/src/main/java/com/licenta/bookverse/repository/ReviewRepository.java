package com.licenta.bookverse.repository;

import com.licenta.bookverse.entity.Review;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface ReviewRepository extends JpaRepository<Review, Integer> {
    List<Review> findByBook_Key(String bookKey);
    List<Review> findByPerson_Id(UUID personId);
}
