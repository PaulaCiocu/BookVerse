package com.licenta.bookverse.dto.auth;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class UserProfileDTO {

    private String fullName;
    private String bio; // User bio
    private String profilePictureUrl; // URL for the profile picture

}
