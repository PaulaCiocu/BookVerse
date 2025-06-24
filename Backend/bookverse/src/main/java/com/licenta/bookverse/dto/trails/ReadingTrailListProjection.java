//package com.licenta.bookverse.dto.trails;
//
//import com.licenta.bookverse.dto.books.enums.CreatedType;
//
//import java.util.List;
//import java.util.UUID;
//
//public interface ReadingTrailListProjection {
//    Long getId();
//    UUID getPersonId();
//    CreatedType getCreatedType();
//    int getTotalBooks();
//    int getProgress();
//    TrailProjection getTrail();
//
//    interface TrailProjection {
//        Long getId();
//        UUID getPersonId();
//        String getTitle();
//        String getDescription();
//        List<String> getGenres();
//        List<TrailBookProjection> getTrailBooks();
//    }
//
//    interface TrailBookProjection {
//        Integer getOrderIndex();
//        BookProjection getBook();
//    }
//
//    interface BookProjection {
//        String getTitle();
//        String getAuthor();
//        Integer getPages();
//        String getCoverImageUrl();
//        String getDescription();
//    }
//}
