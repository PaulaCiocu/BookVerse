package com.licenta.bookverse.repository;

import com.licenta.bookverse.entity.Person;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface PersonRepository extends JpaRepository<Person, UUID> {
    Optional<Person> findByEmail(String email);
    Optional<Person> findByUsername(String username);
    List<Person> findAll();
}
