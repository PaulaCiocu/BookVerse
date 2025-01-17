package com.licenta.bookverse.dto;


import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RegistrationDTO {
    private String fullName;
    private String username;
    private String email;
    private String password;
    private String confirmPassword;
}
