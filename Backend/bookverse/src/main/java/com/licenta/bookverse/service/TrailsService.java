package com.licenta.bookverse.service;

import com.licenta.bookverse.dto.books.TrailDTO;
import com.licenta.bookverse.dto.books.TrailDTOGetRequest;
import com.licenta.bookverse.entity.Book;
import com.licenta.bookverse.entity.Person;
import com.licenta.bookverse.entity.Trail;
import com.licenta.bookverse.entity.TrailBook;
import com.licenta.bookverse.repository.BookRepository;
import com.licenta.bookverse.repository.PersonRepository;
import com.licenta.bookverse.repository.TrailBookRepository;
import com.licenta.bookverse.repository.TrailRepository;
import com.licenta.bookverse.service.books.BookService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class TrailsService {

    private final TrailRepository trailRepository;
    private final BookRepository bookRepository;
    private final PersonRepository personRepository;
    private final ReadingListService readingListService;
    private final ReadingTrailService readingTrailService;
    private final TrailBookRepository trailBookRepository;
    private final TrailBookService trailBookService;
    private final BookService bookService;

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
                .personName(trail.getCreator().getFullName())
                .imageUrl(trail.getImageUrl())
                .build();
    }


    public List<TrailDTOGetRequest> getTrailsByPerson(UUID personId) {
        List<Trail> trails = trailRepository.findByCreatorId(personId);

        return trails.stream()
                .filter(trail -> !trail.isDeleted())
                .map(trail ->
                        TrailDTOGetRequest.builder()
                                .trailId(trail.getId())
                                .title(trail.getTitle())
                                .description(trail.getDescription())
                                .genre(trail.getGenres())
                                .trailBookList(trail.getTrailBooks())
                                .numberOfReadings(trail.getNumberOfReadings())
                                .creatorId(trail.getCreator().getId())
                                .personName(trail.getCreator().getFullName())
                                .build()
                ).collect(Collectors.toList());
    }

    public List<TrailDTOGetRequest> getTrailsExceptForPerson(UUID personId, String genre, String author, String bookTitle, String trailName) {
        List<Trail> allTrails = trailRepository.findAll(); // Fetch all trails

        return allTrails.stream()
                .filter(trail -> !trail.getCreator().getId().equals(personId)) // Exclude trails created by the user
                .filter(trail -> !trail.isDeleted())
                .filter(trail -> genre == null ||
                        trail.getGenres().stream()
                                .anyMatch(tGenre -> tGenre.equalsIgnoreCase(genre))) // Filter by genre
                .filter(trail -> author == null ||
                        trail.getTrailBooks().stream()
                                .anyMatch(trailBook -> trailBook.getBook().getAuthor().equalsIgnoreCase(author))) // Filter by author
                .filter(trail -> bookTitle == null ||
                        trail.getTrailBooks().stream()
                                .anyMatch(trailBook -> trailBook.getBook().getTitle().equalsIgnoreCase(bookTitle))) // Filter by book title
                .filter(trail -> trailName == null ||
                        trail.getTitle().equalsIgnoreCase(trailName)) // Filter by trail name
                .map(trail -> TrailDTOGetRequest.builder()
                        .trailId(trail.getId())
                        .title(trail.getTitle())
                        .description(trail.getDescription())
                        .genre(trail.getGenres())
                        .trailBookList(trail.getTrailBooks())
                        .numberOfReadings(trail.getNumberOfReadings())
                        .creatorId(trail.getCreator().getId())
                        .personName(trail.getCreator().getFullName())
                        .imageUrl(trail.getImageUrl())
                        .build()
                )
                .collect(Collectors.toList());
    }

    public Long createTrail(TrailDTO trailDTO) {
        // Fetch the creator (Person)
        Person creator = personRepository.findById(trailDTO.getCreatorId())
                .orElseThrow(() -> new RuntimeException("Creator not found"));

        // Create a new Trail object
        Trail trail = Trail.builder()
                .title(trailDTO.getTitle())
                .description(trailDTO.getDescription())
                .creator(creator)
                .numberOfReadings(0)
                .imageUrl(trailDTO.getImageUrl())
                .build();

        int totalPages = 0;

        if (trailDTO.getBooks() != null) {
            List<TrailBook> trailBookList = new ArrayList<>();
            int nextOrderIndex = 1;
            Set<String> genres = new HashSet<>();
            for (TrailDTO.BookOrderDTO bookOrder : trailDTO.getBooks()) {
                Optional<Book> bookCheck = bookRepository.findById(bookOrder.getBookKey());
                Book book = null;
                if(bookCheck.isEmpty()){
                    book = bookService.getBookDetails(bookOrder.getBookKey());
                }
                TrailBook trailBook = TrailBook.builder()
                        .trail(trail) // Set the trail reference
                        .book(book) // Set the book reference
                        .orderIndex(nextOrderIndex) // Set the order index
                        .build();

                trailBookList.add(trailBook);
                genres.addAll(book.getSubjects());
                totalPages += book.getPages();
                nextOrderIndex++;
            }
            trail.setTrailBooks(trailBookList); // Associate the trailBooks with the trail
            trail.setGenres(new ArrayList<>(genres)); // Convert Set to List
        }
        trail.setTotalPages(totalPages);

        // Save the trail in the database
        Trail savedTrail = trailRepository.save(trail);
        return savedTrail.getId();
    }

    public void deleteTrail(Long trailId, UUID userId, Boolean keepBooks) {
        Trail trail = (Trail) trailRepository.findById(trailId)
                .orElseThrow(() -> new RuntimeException("Trail not found"));
        trail.setDeleted(true);
        readingTrailService.deleteTrailFromReadingList(userId, trailId, keepBooks);
        trailRepository.save(trail);
    }

    public Long updateTrailBooks(Integer trailId, List<String> bookKeys) {
        // Find the existing Trail
        Trail trail = trailRepository.findById(trailId)
                .orElseThrow(() -> new RuntimeException("Trail not found"));

        // Add new TrailBooks
        List<TrailBook> newTrailBooks = new ArrayList<>();
        Set<String> genres = new HashSet<>();
        int nextOrderIndex = 1;

        // Ensure that bookKeys are passed correctly
        for (String bookKey : bookKeys) {
            if (bookKey == null || bookKey.isEmpty()) {
                throw new RuntimeException("Book key cannot be empty");
            }

            Optional<Book> bookCheck = bookRepository.findById(bookKey);
            Book book = null;
            if(bookCheck.isEmpty()){
                book = bookService.getBookDetails(bookKey);
            }

            // Create and add new TrailBook entities
            TrailBook trailBook = new TrailBook();
            trailBook.setTrail(trail);
            trailBook.setBook(book);
            trailBook.setOrderIndex(nextOrderIndex++);
            newTrailBooks.add(trailBook);

            // Add book subjects to genres set
            genres.addAll(book.getSubjects());
            trail.getTrailBooks().add(trailBook);
        }

        // Set the new list of TrailBooks to the trail and update genres

        trail.setGenres(new ArrayList<>(genres));

        // Save the updated trail (only save once)
        trailRepository.save(trail);

        // Return the trailId or appropriate response
        return trail.getId();
    }

}
