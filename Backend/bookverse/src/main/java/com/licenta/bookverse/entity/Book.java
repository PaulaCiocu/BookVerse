package com.licenta.bookverse.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;
import java.util.List;


@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
public class Book {

    @Id
    private String key;


    private String title;
    private String author;
    private Integer pages;
    private String publish_date;
    private String language;

    @ElementCollection
    @CollectionTable(name = "book_subjects", joinColumns = @JoinColumn(name = "book_key"))
    @Column(name = "subject")
    @OrderColumn
    @OnDelete(action = OnDeleteAction.CASCADE)
    private List<String> subjects;
    @Column(length = 5000)
    private String description;
    private String coverImageUrl;


}
