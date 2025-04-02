package com.licenta.bookverse.service;

import com.licenta.bookverse.dto.books.enums.ReadingListStatus;
import com.licenta.bookverse.entity.Achievement;
import com.licenta.bookverse.entity.Person;
import com.licenta.bookverse.repository.AchievementRepository;
import com.licenta.bookverse.repository.PersonRepository;
import com.licenta.bookverse.repository.ReadingListRepository;
import com.licenta.bookverse.repository.ReadingTrailListRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
public class AchievementService {
    private final AchievementRepository achievementRepository;

    @Autowired
    private PersonRepository personRepository;

    @Autowired
    private ReadingListRepository readingListRepository;

    @Autowired
    private ReadingTrailListRepository readingTrailListRepository;

    public AchievementService(AchievementRepository achievementRepository) {
        this.achievementRepository = achievementRepository;
    }

    public Achievement getAchievementsByUser(UUID personId) {
        Person person = personRepository.findById(personId)
                .orElseThrow(() -> new RuntimeException("Person not found"));

        return achievementRepository.findByPerson(person).get();
    }

    public void updateAchievements(UUID personId) {
        Achievement achievement = achievementRepository.findByPerson_Id(personId)
                .orElseThrow(() -> new RuntimeException("Achievement entry not found"));

        int booksInProgress = readingListRepository.countByPersonIdAndStatus(personId, ReadingListStatus.IN_PROGRESS);
        int booksCompleted = readingListRepository.countByPersonIdAndStatus(personId, ReadingListStatus.COMPLETED);

        int trailsCompleted = readingTrailListRepository.countByPersonIdAndStatus(personId, ReadingListStatus.COMPLETED);
        int trailsInProgress = readingTrailListRepository.countByPersonIdAndStatus(personId, ReadingListStatus.IN_PROGRESS);

        // Calculate total pages read from completed books
        int totalPagesReadCompleted = readingListRepository.findByPersonIdAndStatus(personId, ReadingListStatus.COMPLETED)
                .stream()
                .mapToInt(readingList -> readingList.getPagesRead())  // Sum the pages from completed books
                .sum();

        // Calculate total pages read from books in progress
        int totalPagesReadInProgress = readingListRepository.findByPersonIdAndStatus(personId, ReadingListStatus.IN_PROGRESS)
                .stream()
                .mapToInt(readingList -> readingList.getPagesRead())  // Sum the pages from books in progress
                .sum();

        // Total pages read (both completed and in progress)
        int totalPagesRead = totalPagesReadCompleted + totalPagesReadInProgress;

        achievement.setBookInProgress(booksInProgress);
        achievement.setTotalBooksRead(booksCompleted);

        achievement.setTotalTrailsCompleted(trailsCompleted);
        achievement.setTrailsInProgress(trailsInProgress);

        achievement.setTotalPagesRead(totalPagesRead);
        achievementRepository.save(achievement);
    }



}
