package com.licenta.bookverse.service;
import com.licenta.bookverse.dto.trails.TrailDTO;
import com.licenta.bookverse.dto.trails.TrailDTODetails;
import com.licenta.bookverse.entity.*;
import com.licenta.bookverse.repository.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.mockito.junit.jupiter.MockitoExtension;
import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class TrailsServiceTest {

    @Mock
    private TrailRepository trailRepository;

    @Mock
    private BookRepository bookRepository;

    @Mock
    private PersonRepository personRepository;

    @Mock
    private ReadingTrailService readingTrailService;

    @Mock
    private ReadingTrailListRepository readingTrailListRepository;

    @InjectMocks
    private TrailsService trailsService;

    private Person creator;
    private Trail trail;
    private Book book;

    @BeforeEach
    void setup() {
        creator = new Person();
        creator.setId(UUID.randomUUID());
        creator.setFullName("Test Creator");

        book = new Book();
        book.setKey("bookKey1");
        book.setTitle("Sample Book");
        book.setAuthor("Author Name");
        book.setSubjects(List.of("Fiction"));
        book.setPages(300);

        trail = new Trail();
        trail.setId(1L);
        trail.setTitle("Sample Trail");
        trail.setDescription("Description");
        trail.setCreator(creator);
        trail.setGenres(List.of("Fiction"));
        trail.setTrailBooks(new ArrayList<>());
        trail.setNumberOfReadings(10);
    }

    @Test
    void testGetTrailById_ReturnsTrailDetails() {
        TrailBook trailBook = new TrailBook();
        trailBook.setId(100L);
        trailBook.setBook(book);
        trailBook.setOrderIndex(1);
        trail.getTrailBooks().add(trailBook);

        when(trailRepository.findById(1L)).thenReturn(Optional.of(trail));

        TrailDTODetails details = trailsService.getTrailById(1L);

        assertEquals(trail.getId(), details.getTrailId());
        assertEquals(trail.getTitle(), details.getTitle());
        assertEquals(1, details.getTrailBookDTODetails().size());
        assertEquals(book.getTitle(), details.getTrailBookDTODetails().get(0).getTitle());

        verify(trailRepository, times(1)).findById(1L);
    }

    @Test
    void testGetTrailById_TrailNotFound_Throws() {
        when(trailRepository.findById(2L)).thenReturn(Optional.empty());

        Exception exception = assertThrows(RuntimeException.class, () -> {
            trailsService.getTrailById(2L);
        });

        assertEquals("Trail not found", exception.getMessage());
    }

    @Test
    void testCreateTrail_Success() {
        TrailDTO trailDTO = TrailDTO.builder()
                .title("New Trail")
                .description("Trail Description")
                .creatorId(creator.getId())
                .imageUrl("image.jpg")
                .build();

        TrailDTO.BookOrderDTO bookOrder = new TrailDTO.BookOrderDTO();
        bookOrder.setBookKey(book.getKey());
        trailDTO.setBooks(List.of(bookOrder));

        when(personRepository.findById(creator.getId())).thenReturn(Optional.of(creator));
        when(bookRepository.findById(book.getKey())).thenReturn(Optional.of(book));
        when(trailRepository.save(any(Trail.class))).thenAnswer(invocation -> {
            Trail trail = invocation.getArgument(0);
            trail.setId(1L); // set a fake ID to simulate persistence assigning an ID
            return trail;
        });

        Long trailId = trailsService.createTrail(trailDTO);

        assertNotNull(trailId);
        verify(trailRepository).save(any(Trail.class));
    }

    @Test
    void testDeleteTrail_SetsDeletedFlag() {
        when(trailRepository.findById(trail.getId())).thenReturn(Optional.of(trail));

        trailsService.deleteTrail(trail.getId(), creator.getId(), true);

        assertTrue(trail.isDeleted());
        verify(readingTrailService).deleteTrailFromReadingList(creator.getId(), trail.getId(), true);
        verify(trailRepository).save(trail);
    }

    @Test
    void testUpdateTrail_UpdatesFieldsAndNotifies() {
        ReadingTrailList readingTrailList = new ReadingTrailList();
        readingTrailList.setPerson(creator);

        TrailDTO trailDTO = TrailDTO.builder()
            .title("New Trail")
            .description("Trail Description")
            .creatorId(creator.getId())
            .imageUrl("image.jpg")
            .build();

        TrailDTO.BookOrderDTO bookOrder = new TrailDTO.BookOrderDTO();
        bookOrder.setBookKey(book.getKey());
        trailDTO.setBooks(List.of(bookOrder));

        trail.getTrailBooks().clear();

        when(trailRepository.findById(trail.getId())).thenReturn(Optional.of(trail));
        when(bookRepository.findById(book.getKey())).thenReturn(Optional.of(book));
        when(trailRepository.save(any(Trail.class))).thenReturn(trail);
        trailsService.updateTrail(trail.getId(), trailDTO);

        assertEquals("New Trail", trail.getTitle());
        assertEquals("Trail Description", trail.getDescription());
        assertEquals("image.jpg", trail.getImageUrl());

        verify(trailRepository).save(trail);
    }
}
