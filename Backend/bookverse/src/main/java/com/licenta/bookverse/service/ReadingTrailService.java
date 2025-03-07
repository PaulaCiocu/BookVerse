package com.licenta.bookverse.service;


import com.licenta.bookverse.dto.ReadingListStatus;
import com.licenta.bookverse.dto.books.CreatedType;
import com.licenta.bookverse.entity.Person;
import com.licenta.bookverse.entity.ReadingTrailList;
import com.licenta.bookverse.entity.Trail;
import com.licenta.bookverse.repository.PersonRepository;
import com.licenta.bookverse.repository.ReadingTrailListRepository;
import com.licenta.bookverse.repository.TrailRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class ReadingTrailService {
    @Autowired
    private ReadingTrailListRepository readingTrailListRepository;

    @Autowired
    private PersonRepository personRepository;

    @Autowired
    private TrailRepository trailRepository;

    public void addTrailToReadingList(UUID personId, Long trailId, CreatedType createdType) {
        Person person = personRepository.findById(personId)
                .orElseThrow(() -> new RuntimeException("Person not found"));
        Trail trail = (Trail) trailRepository.findById(trailId)
                .orElseThrow(() -> new RuntimeException("Trail not found"));

        // Create a new ReadingTrailList with the specified createdType
        ReadingTrailList readingTrailList = ReadingTrailList.builder()
                .person(person)
                .trail(trail)
                .createdType(createdType)
                .status(ReadingListStatus.NOT_STARTED)  // Set the initial status as "Not Started"
                .build();

        readingTrailListRepository.save(readingTrailList);
    }


    public List<ReadingTrailList> getReadingTrailsForPerson(UUID personId) {
        Person person = personRepository.findById(personId)
                .orElseThrow(() -> new RuntimeException("Person not found"));

        List<ReadingTrailList> trails = readingTrailListRepository.findByPerson(person);
        return trails;
    }

    public boolean isTrailInReadingList(UUID personId, Long trailId) {
        Person person = personRepository.findById(personId)
                .orElseThrow(() -> new RuntimeException("Person not found"));
        Trail trail = (Trail) trailRepository.findById(trailId)
                .orElseThrow(() -> new RuntimeException("Trail not found"));

        return readingTrailListRepository.existsByPersonAndTrail(person, trail);
    }



}
