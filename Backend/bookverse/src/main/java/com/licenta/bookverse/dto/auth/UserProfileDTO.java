package com.licenta.bookverse.dto.auth;

import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class UserProfileDTO {
    private String fullName;
    private String bio;
    private String profilePictureUrl;
}
