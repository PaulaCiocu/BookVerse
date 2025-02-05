package com.licenta.bookverse.dto;


import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class LoginResponse {
    private String token;

    private long expiresIn;

    public void setExpiresIn(long expiresIn) {
        this.expiresIn = expiresIn;
    }

    // Override the toString method
    @Override
    public String toString() {
        return "LoginResponse{" + "\n" +
                "token='" + token + '\'' + "\n" +
                ", expiresIn=" + expiresIn + "\n" +
                '}';
    }


}
