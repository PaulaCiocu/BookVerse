package com.licenta.bookverse.controller;

import com.licenta.bookverse.entity.Achievement;
import com.licenta.bookverse.service.AchievementService;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/achievements")
@CrossOrigin(origins = "*")
public class AchievementController {
    private final AchievementService achievementService;

    public AchievementController(AchievementService achievementService) {
        this.achievementService = achievementService;
    }

    @GetMapping("/person/{personId}")
    public Achievement getAchievements(@PathVariable UUID personId) {
        return achievementService.getAchievementsByUser(personId);
    }
}
