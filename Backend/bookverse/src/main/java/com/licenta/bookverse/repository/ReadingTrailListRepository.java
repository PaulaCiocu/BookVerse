package com.licenta.bookverse.repository;


import com.licenta.bookverse.dto.books.enums.CreatedType;
import com.licenta.bookverse.dto.books.enums.ReadingListStatus;
import com.licenta.bookverse.entity.Person;
import com.licenta.bookverse.entity.ReadingTrailList;
import com.licenta.bookverse.entity.Trail;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;


@Repository
public interface ReadingTrailListRepository extends JpaRepository<ReadingTrailList, Integer> {

    List<ReadingTrailList> findByPerson(Person person);

    boolean existsByPersonAndTrail(Person person, Trail trail);


    int countByPersonIdAndStatus(UUID personId, ReadingListStatus readingListStatus);

    List<ReadingTrailList> findByPersonAndCreatedType(Person person, CreatedType createdType);

    ReadingTrailList findByPersonAndTrail(Person person, Trail trail);


    List<ReadingTrailList> findByPerson_Id(UUID personId);

    List<ReadingTrailList> findByTrailAndCreatedType(Trail trail, CreatedType createdType);
}
