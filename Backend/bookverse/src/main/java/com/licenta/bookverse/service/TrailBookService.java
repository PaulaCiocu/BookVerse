package com.licenta.bookverse.service;

import com.licenta.bookverse.entity.Trail;
import com.licenta.bookverse.entity.TrailBook;
import com.licenta.bookverse.repository.TrailBookRepository;
import com.licenta.bookverse.repository.TrailRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class TrailBookService {
    @Autowired
    private final TrailBookRepository trailBookRepository;
    @Autowired
    private final TrailRepository trailRepository;

    public void deleteTrailBook(Long trailId, String bookKey) {
        // Find the Trail using the provided trailId
        Trail trail = (Trail) trailRepository.findById(trailId)
                .orElseThrow(() -> new RuntimeException("Trail not found"));

        // Find the TrailBook in the Trail's trailBooks list using the bookKey
        TrailBook trailBook = trail.getTrailBooks().stream()
                .filter(book -> book.getBook().getKey().equals(bookKey))
                .findFirst()
                .orElseThrow(() -> new RuntimeException("TrailBook with the given bookKey not found"));

        // Delete the TrailBook
        trailBookRepository.delete(trailBook);
        // Save the updated Trail entity
        trailRepository.save(trail);
    }

}
