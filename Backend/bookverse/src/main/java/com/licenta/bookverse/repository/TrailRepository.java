package com.licenta.bookverse.repository;

import com.licenta.bookverse.entity.Trail;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.CrudRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface TrailRepository extends JpaRepository<Trail, Integer> {
    List<Trail> findByCreatorId(UUID personId);

    Optional<Object> findById(Long trailId);
}
