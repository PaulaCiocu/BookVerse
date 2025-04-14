package com.licenta.bookverse.controller;

import com.licenta.bookverse.entity.Notification;
import com.licenta.bookverse.entity.Person;
import com.licenta.bookverse.service.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/notifications")
@RequiredArgsConstructor
public class NotificationController {

    private final NotificationService notificationService;

    @GetMapping("/unseen-count/{personId}")
    public ResponseEntity<Integer> getUnseenCount(@PathVariable UUID personId) {
        return ResponseEntity.ok(notificationService.countUnseen(personId));
    }

    @GetMapping("/{personId}")
    public ResponseEntity<List<Notification>> getAll(@PathVariable UUID personId) {
        return ResponseEntity.ok(notificationService.getAllForUser(personId));
    }

    @PostMapping("/mark-as-seen/{personId}")
    public ResponseEntity<Void> markAsSeen(@PathVariable UUID personId) {
        notificationService.markAllAsSeen(personId);
        return ResponseEntity.ok().build();
    }
}

