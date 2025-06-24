package com.licenta.bookverse.service;

import com.licenta.bookverse.entity.Notification;
import com.licenta.bookverse.entity.Person;
import com.licenta.bookverse.repository.NotificationRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class NotificationService {

    private final NotificationRepository notificationRepository;

    public void sendNotification(Person person, String message) {
        Notification notification = new Notification();
        notification.setPerson(person);
        notification.setMessage(message);
        notificationRepository.save(notification);
    }

    public List<Notification> getAllForUser(UUID personId) {
        markAllAsSeen(personId);
        return notificationRepository.findByPersonIdOrderByCreatedAtDesc(personId);
    }

    public int countUnseen(UUID personId) {
        return notificationRepository.countByPersonIdAndSeenFalse(personId);
    }

    public void markAllAsSeen(UUID personId) {
        List<Notification> unseen = notificationRepository.findByPersonIdOrderByCreatedAtDesc(personId)
                .stream()
                .filter(n -> !n.isSeen())
                .toList();
        unseen.forEach(n -> n.setSeen(true));
        notificationRepository.saveAll(unseen);
    }
}

