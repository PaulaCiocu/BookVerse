package com.licenta.bookverse.repository;

import com.licenta.bookverse.entity.Notification;
import com.licenta.bookverse.entity.Person;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Arrays;
import java.util.List;
import java.util.UUID;

@Repository
public interface NotificationRepository extends JpaRepository<Notification, Long> {
    List<Notification> findByPersonOrderByCreatedAtDesc(Person person);
    int countByPersonAndSeenFalse(Person person);

    int countByPersonIdAndSeenFalse(UUID personId);

    List<Notification> findByPersonIdOrderByCreatedAtDesc(UUID personId);
}

