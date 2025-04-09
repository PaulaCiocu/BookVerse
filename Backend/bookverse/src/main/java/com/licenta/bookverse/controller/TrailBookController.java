package com.licenta.bookverse.controller;

import com.licenta.bookverse.service.TrailBookService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/trail-books")
public class TrailBookController {

    private final TrailBookService trailBookService;

    @Autowired
    public TrailBookController(TrailBookService trailBookService) {
        this.trailBookService = trailBookService;
    }

    @DeleteMapping("/delete/{trailId}/{bookKey}")
    public String deleteTrailBook(@PathVariable Long trailId, @PathVariable String bookKey) {
        trailBookService.deleteTrailBook(trailId, bookKey);
        return "TrailBook deleted successfully";
    }
}
