package com.licenta.bookverse.repository;

import com.licenta.bookverse.entity.Person;
import com.licenta.bookverse.entity.ReadingTrailList;
import com.licenta.bookverse.entity.Trail;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface ReadingTrailListRepository extends JpaRepository<ReadingTrailList, Integer> {
    List<ReadingTrailList> findByPerson(Person person);

    boolean existsByPersonAndTrail(Person person, Trail trail);
}
