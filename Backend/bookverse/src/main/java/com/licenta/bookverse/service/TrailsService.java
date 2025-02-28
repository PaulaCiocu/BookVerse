package com.licenta.bookverse.service;

import com.licenta.bookverse.dto.TrailDTO;
import com.licenta.bookverse.dto.TrailDTOGetRequest;
import com.licenta.bookverse.entity.Book;
import com.licenta.bookverse.entity.Person;
import com.licenta.bookverse.entity.Trail;
import com.licenta.bookverse.entity.TrailBook;
import com.licenta.bookverse.repository.BookRepository;
import com.licenta.bookverse.repository.PersonRepository;
import com.licenta.bookverse.repository.TrailRepository;
import lombok.AllArgsConstructor;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class TrailsService {

    private final TrailRepository trailRepository;
    private final BookRepository bookRepository;
    private final PersonRepository personRepository;

    public TrailDTOGetRequest getTrailById(Integer trailId) {
        Trail trail = trailRepository.findById(trailId)
                .orElseThrow(() -> new RuntimeException("Trail not found"));

        return TrailDTOGetRequest.builder()
                .trailId(trail.getId())
                .title(trail.getTitle())
                .description(trail.getDescription())
                .genre(trail.getGenres())
                .trailBookList(trail.getTrailBooks())
                .numberOfReadings(trail.getNumberOfReadings())
                .creatorId(trail.getCreator().getId())
                .build();
    }


    public List<TrailDTOGetRequest> getTrailsByPerson(UUID personId) {
        List<Trail> trails = trailRepository.findByCreatorId(personId);

        return trails.stream().map(trail ->
                TrailDTOGetRequest.builder()
                        .trailId(trail.getId())
                        .title(trail.getTitle())
                        .description(trail.getDescription())
                        .genre(trail.getGenres())
                        .trailBookList(trail.getTrailBooks())
                        .numberOfReadings(trail.getNumberOfReadings())
                        .creatorId(trail.getCreator().getId())
                        .build()
        ).collect(Collectors.toList());
    }

    public List<TrailDTOGetRequest> getTrailsExceptForPerson(UUID personId) {
        List<Trail> allTrails = trailRepository.findAll(); // Fetch all trails

        return allTrails.stream()
                .filter(trail -> !trail.getCreator().getId().equals(personId)) // Filter out trails created by the specified person
                .map(trail -> TrailDTOGetRequest.builder()
                        .trailId(trail.getId())
                        .title(trail.getTitle())
                        .description(trail.getDescription())
                        .genre(trail.getGenres())
                        .trailBookList(trail.getTrailBooks())
                        .numberOfReadings(trail.getNumberOfReadings())
                        .creatorId(trail.getCreator().getId())
                        .build()
                )
                .collect(Collectors.toList());
    }

    public void createTrail(TrailDTO trailDTO) {
        // Fetch the creator (Person)
        Person creator = personRepository.findById(trailDTO.getCreatorId())
                .orElseThrow(() -> new RuntimeException("Creator not found"));

        // Create a new Trail object
        Trail trail = Trail.builder()
                .title(trailDTO.getTitle())
                .description(trailDTO.getDescription())
                .creator(creator)
                .numberOfReadings(0)
                .build();

        if (trailDTO.getBooks() != null) {
            List<TrailBook> trailBookList = new ArrayList<>();
            int nextOrderIndex = 1;
            Set<String> genres = new HashSet<>();
            for (TrailDTO.BookOrderDTO bookOrder : trailDTO.getBooks()) {
                Book book = bookRepository.findById(bookOrder.getBookKey())
                        .orElseThrow(() -> new RuntimeException("Book not found"));

                TrailBook trailBook = TrailBook.builder()
                        .trail(trail) // Set the trail reference
                        .book(book) // Set the book reference
                        .orderIndex(nextOrderIndex) // Set the order index
                        .build();

                trailBookList.add(trailBook);
                genres.addAll(book.getSubjects());
                nextOrderIndex++;
            }
            trail.setTrailBooks(trailBookList); // Associate the trailBooks with the trail
            trail.setGenres(new ArrayList<>(genres)); // Convert Set to List
        }

        // Save the trail in the database
        trailRepository.save(trail);
    }

}
