package com.licenta.bookverse.service;


import com.licenta.bookverse.dto.books.ReadingListFollowedDTO;
import com.licenta.bookverse.dto.books.enums.ReadingListStatus;
import com.licenta.bookverse.dto.books.enums.CreatedType;
import com.licenta.bookverse.entity.*;
import com.licenta.bookverse.repository.PersonRepository;
import com.licenta.bookverse.repository.ReadingListRepository;
import com.licenta.bookverse.repository.ReadingTrailListRepository;
import com.licenta.bookverse.repository.TrailRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class ReadingTrailService {
    @Autowired
    private ReadingTrailListRepository readingTrailListRepository;

    @Autowired
    private PersonRepository personRepository;

    @Autowired
    private TrailRepository trailRepository;
    @Autowired
    private ReadingListRepository readingListRepository;

    public void addTrailToReadingList(UUID personId, Long trailId, CreatedType createdType) {
        Person person = personRepository.findById(personId)
                .orElseThrow(() -> new RuntimeException("Person not found"));
        Trail trail = (Trail) trailRepository.findById(trailId)
                .orElseThrow(() -> new RuntimeException("Trail not found"));
        int totalBooks = trail.getTrailBooks().size();
        // Calculate the total pages by summing the pages of all books in the trail
        int totalPages = trail.getTrailBooks().stream()
                .mapToInt(trailBook -> trailBook.getBook().getPages())  // Assuming getPageCount() returns the number of pages for a book
                .sum();

        if(createdType == CreatedType.FOLLOWED){
            trail.setNumberOfReadings(trail.getNumberOfReadings() + 1);
        }
        ReadingTrailList readingTrailList = ReadingTrailList.builder()
                .person(person)
                .trail(trail)
                .createdType(createdType)
                .status(ReadingListStatus.NOT_STARTED)  // Set the initial status as "Not Started"
                .totalBooks(totalBooks)
                .totalPages(totalPages)
                .build();
        readingTrailListRepository.save(readingTrailList);

        // Add books from the trail to the user's reading list
        for (TrailBook trailBook : trail.getTrailBooks()) {
            // Check if the book is already in the user's reading list
            Optional<ReadingList> existingReadingList = readingListRepository.findByPersonAndBook(person, trailBook.getBook());

            if (existingReadingList.isEmpty()) {
                // The book is not already in the user's reading list, so add it
                ReadingList readingListItem = ReadingList.builder()
                        .person(person)
                        .book(trailBook.getBook())
                        .status(ReadingListStatus.NOT_STARTED)  // Or another initial status
                        .build();

                // Save the book to the user's reading list
                readingListRepository.save(readingListItem);
            }
        }

    }

    public List<ReadingTrailList> getReadingTrailsForPerson(UUID personId) {
        Person person = personRepository.findById(personId)
                .orElseThrow(() -> new RuntimeException("Person not found"));

        List<ReadingTrailList> readingTrails = readingTrailListRepository.findByPerson(person);

        for (ReadingTrailList trailList : readingTrails) {
            Trail trail = trailList.getTrail();

            // Sort the TrailBooks in the desired order (this might be redundant if your list is already ordered)
            trail.getTrailBooks().sort(Comparator.comparingInt(TrailBook::getOrderIndex)); // Assuming 'getIndex' returns the book index in the trail

            // Optionally, you can store the ordered books in the trailList if you need them to be ordered
        }

        return readingTrails;
    }

    public List<ReadingListFollowedDTO> getReadingTrailsFollowedForPersonId(UUID personId) {
        Person person = personRepository.findById(personId)
                .orElseThrow(() -> new RuntimeException("Person not found"));

        List<ReadingTrailList> readingTrails = readingTrailListRepository.findByPersonAndCreatedType(person, CreatedType.FOLLOWED);

        return readingTrails.stream()
                .map(trail -> ReadingListFollowedDTO.builder()
                        .title(trail.getTrail().getTitle())
                        .description(trail.getTrail().getDescription())
                        .imageUrl(trail.getTrail().getImageUrl())
                        .deleted(trail.getTrail().isDeleted())
                        .build())
                .toList();
    }

    public List<ReadingTrailList> getReadingTrailsCreatedForPersonId(UUID personId) {
        Person person = personRepository.findById(personId)
                .orElseThrow(() -> new RuntimeException("Person not found"));

        List<ReadingTrailList> readingTrails = readingTrailListRepository.findByPersonAndCreatedType(person, CreatedType.CREATED);

        return readingTrails;
    }

    public boolean isTrailInReadingList(UUID personId, Long trailId) {
        Person person = personRepository.findById(personId)
                .orElseThrow(() -> new RuntimeException("Person not found"));
        Trail trail = (Trail) trailRepository.findById(trailId)
                .orElseThrow(() -> new RuntimeException("Trail not found"));
        return readingTrailListRepository.existsByPersonAndTrail(person, trail);
    }


    public boolean updateReadingProgress(UUID personId, Long trailId, int pagesRead) {
                return false;
    }

    public boolean deleteTrailFromReadingList(UUID personId, Long trailId, boolean deleteBooks) {
        Person person = personRepository.findById(personId)
                .orElseThrow(() -> new RuntimeException("Person not found"));

        Trail trail = (Trail) trailRepository.findById(trailId)
                .orElseThrow(() -> new RuntimeException("Trail not found"));

        ReadingTrailList readingTrail = readingTrailListRepository.findByPersonAndTrail(person, trail);

        if (trail != null) {

            System.out.println("Trail found. Proceeding to delete...");
            if (deleteBooks) {
                // Deleting books from the reading list
                List<TrailBook> booksInTrail = readingTrail.getTrail().getTrailBooks();
                List<ReadingTrailList> otherUserTrails = readingTrailListRepository.findByPerson(person)
                        .stream()
                        .filter(otherTrail -> !otherTrail.getTrail().getId().equals(trailId))
                        .toList();

                for (TrailBook trailBook : booksInTrail) {
                    String bookKey = trailBook.getBook().getKey();
                    boolean isBookInOtherUserTrails = otherUserTrails.stream()
                            .flatMap(otherTrail -> otherTrail.getTrail().getTrailBooks().stream())
                            .anyMatch(tb -> tb.getBook().getKey().equals(bookKey));

                    if (!isBookInOtherUserTrails){
                        Optional<Object> readingListOptional = readingListRepository.findByPerson_IdAndBook_Key(personId, bookKey);

                        if (readingListOptional.isPresent()) {
                            ReadingList readingList = (ReadingList) readingListOptional.get();

                            // Delete the book from the reading list
                            readingListRepository.delete(readingList);
                            System.out.println("Deleted book from reading list: " + trailBook.getBook().getTitle());
                        }
                    }
                }
            }
            readingTrailListRepository.delete(readingTrail);
            return true;
        } else {
            return false;  // Trail not found
        }
    }
}
