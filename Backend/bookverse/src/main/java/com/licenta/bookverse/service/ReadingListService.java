package com.licenta.bookverse.service;

import com.licenta.bookverse.dto.books.ReadingListDTO;
import com.licenta.bookverse.dto.books.enums.ReadingListStatus;
import com.licenta.bookverse.entity.*;
import com.licenta.bookverse.repository.*;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@AllArgsConstructor
public class ReadingListService {
    @Autowired
    private ReadingListRepository readingListRepository;

    @Autowired
    private PersonRepository personRepository;

    @Autowired
    private BookRepository bookRepository;

    @Autowired
    private AchievementService achievementService;

    @Autowired
    private TrailBookRepository trailBookRepository;

    @Autowired
    private ReadingTrailService readingTrailService;

    @Autowired
    private ReadingTrailListRepository readingTrailListRepository;

    public void addToReadingList(UUID userId, String bookKey) {
        Person person = personRepository.findById(userId).orElseThrow(() -> new RuntimeException("User not found"));
        Book book = bookRepository.findById(bookKey).orElseThrow(() -> new RuntimeException("Book not found"));

        boolean exists = readingListRepository.existsByPerson_IdAndBook_Key(userId, bookKey);
        if (exists) {
            throw new IllegalArgumentException("This book is already in your reading list.");
        }

        ReadingList readingList = new ReadingList();
        readingList.setPerson(person);
        readingList.setBook(book);
        readingList.setStatus(ReadingListStatus.NOT_STARTED);

        readingListRepository.save(readingList);
    }

    public List<ReadingListDTO> getBooksByUserId(UUID personId) {
        List<ReadingListDTO> readingLists = readingListRepository.findBooksByPersonId(personId);
        return readingLists;
    }


    public void updateStatusForBook(UUID personId, String bookId, ReadingListStatus newStatus) {
        // Retrieve the reading list entry, or throw an exception if not found
        ReadingList readingList = (ReadingList) readingListRepository.findByPerson_IdAndBook_Key(personId, bookId)
                .orElseThrow(() -> new RuntimeException("Reading list entry not found"));
        // Update the status
        readingList.setStatus(newStatus);
        // Save the updated reading list entry
        readingListRepository.save(readingList);
    }

    public boolean isBookInReadingList(UUID userId, String bookKey) {
        return readingListRepository.existsByPerson_IdAndBook_Key(userId, bookKey);
    }

    public void updateReadingProgress(UUID personId, String bookId, int pagesRead) {

        ReadingList readingList = (ReadingList) readingListRepository.findByPerson_IdAndBook_Key(personId, bookId)
                .orElseThrow(() -> new RuntimeException("Reading list entry not found"));

        int totalPages = readingList.getBook().getPages();
        readingList.setPagesRead(pagesRead);

        if (pagesRead == 0) {
            readingList.setStatus(ReadingListStatus.NOT_STARTED);
        } else if (pagesRead < totalPages) {
            readingList.setStatus(ReadingListStatus.IN_PROGRESS);
        } else {
            readingList.setStatus(ReadingListStatus.COMPLETED);
        }

        readingListRepository.save(readingList);

        List<ReadingTrailList> readingTrail = readingTrailService.getReadingTrailsForPerson(personId);
        for (ReadingTrailList trail : readingTrail) {
            List<TrailBook> trailBookList = trail.getTrail().getTrailBooks();
            int totalPagesReadInTrail = 0;

            for (TrailBook trailBook : trailBookList) {
                if (trailBook.getBook().getKey().equals(bookId)) {
                    trailBook.setPagesRead(pagesRead);
                    trailBookRepository.save(trailBook);
                }
                totalPagesReadInTrail += trailBook.getPagesRead();
            }
            trail.setPagesRead(totalPagesReadInTrail);

            int totalPagesOfTrail = trail.getTotalPages();

            if (totalPagesReadInTrail == 0) {
                trail.setStatus(ReadingListStatus.NOT_STARTED);
            } else if (totalPagesReadInTrail < totalPagesOfTrail) {
                trail.setStatus(ReadingListStatus.IN_PROGRESS);
            } else if(totalPagesReadInTrail == totalPagesOfTrail){
                trail.setStatus(ReadingListStatus.COMPLETED);
            }

            readingTrailListRepository.save(trail);
        }

        achievementService.updateAchievements(personId);
    }


    public String deleteBookFromReadingList(UUID personId, String bookKey) {
        ReadingList readingList = (ReadingList) readingListRepository.findByPerson_IdAndBook_Key(personId, bookKey)
                .orElseThrow(() -> new RuntimeException("Reading list entry not found"));

        boolean canDeleteBook = deleteBookIfNotInTrail(personId,bookKey);
        if (canDeleteBook) {
            readingListRepository.delete(readingList);
            return "Reading list entry deleted";
        }
        return "Reading list entry can not be deleted is part of a trail ";
    }
    public boolean deleteBookIfNotInTrail(UUID personId, String bookKey) {
        // Check if the book is part of any trail
        boolean canDeleteBook = true;
        List<ReadingTrailList> readingTrailLists = readingTrailListRepository.findByPerson_Id(personId);
        for (ReadingTrailList trail : readingTrailLists) {
            List<TrailBook> trailBookList = trail.getTrail().getTrailBooks();
            for (TrailBook trailBook : trailBookList) {
                if (trailBook.getBook().getKey().equals(bookKey)) {
                    canDeleteBook = false;
                    System.out.println("Cannot delete book: " + bookKey + " is part of an active trail.");
                }
            }
        }
       return canDeleteBook;
    }
}

