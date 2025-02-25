package com.licenta.bookverse.service;

import com.licenta.bookverse.dto.ReadingListDTO;
import com.licenta.bookverse.dto.ReadingListStatus;
import com.licenta.bookverse.entity.Book;
import com.licenta.bookverse.entity.Person;
import com.licenta.bookverse.entity.ReadingList;
import com.licenta.bookverse.repository.BookRepository;
import com.licenta.bookverse.repository.PersonRepository;
import com.licenta.bookverse.repository.ReadingListRepository;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
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
        List<ReadingList> readingLists = readingListRepository.findByPersonId(personId); // Assuming this method exists

        List<ReadingListDTO> readingListDTOs = new ArrayList<>();
        for (ReadingList readingList : readingLists) {
            ReadingListDTO readingListDTO = new ReadingListDTO();
            readingListDTO.setBook(readingList.getBook());
            readingListDTO.setStatus(readingList.getStatus());
            readingListDTO.setPagesRead(readingList.getPagesRead());
            readingListDTOs.add(readingListDTO);
        }

        return readingListDTOs; // Return the list of DTOs
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
}

