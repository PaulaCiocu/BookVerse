package com.licenta.bookverse.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.*;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.UUID;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Person{
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;

    @NotBlank
    @Column(nullable = false, unique = true)
    private String email;

    @NotBlank
    @Size(min = 8)
    @Column(nullable = false)
    private String password;

    @NotBlank
    @Column(nullable = false)
    private String fullName;

    @Column(nullable = false)
    private boolean confirmed = true;


    // Profile fields
    private String bio; // User bio
    private String profilePictureUrl; // URL for the profile picture
    private Integer nrOfConnections = 0; // Number of connections

    @ElementCollection
    private List<UUID> connectedUserIds; // List of connected user IDs
    // Getters, Setters, Constructors
}

//public class Person implements UserDetails {
//
//
//    @Id
//    @GeneratedValue(strategy = GenerationType.AUTO)
//    private UUID id;
//
//    @NotBlank
//    @Column(nullable = false, unique = true)
//    private String email;
////
////    @NotBlank
////    @Size(min = 8)
////    @Column(nullable = false)
////    private String password;
//
//    @NotBlank
//    @Column(nullable = false)
//    private String fullName;
//
//    @Column(nullable = false)
//    private boolean confirmed = true;
//
//
//    // Profile fields
//    private String bio; // User bio
//    private String profilePictureUrl; // URL for the profile picture
//    private Integer nrOfConnections = 0; // Number of connections
//
//    @ElementCollection
//    private List<UUID> connectedUserIds; // List of connected user IDs
//    // Getters, Setters, Constructors
//    @Override
//    public Collection<? extends GrantedAuthority> getAuthorities() {
//        return List.of();
//    }
//
//    @Override
//    public String getUsername() {
//        return email;
//    }
//
//    @Override
//    public boolean isAccountNonExpired() {
//        return UserDetails.super.isAccountNonExpired();
//    }
//
//    @Override
//    public boolean isAccountNonLocked() {
//        return UserDetails.super.isAccountNonLocked();
//    }
//
//    @Override
//    public boolean isCredentialsNonExpired() {
//        return UserDetails.super.isCredentialsNonExpired();
//    }
//
//    @Override
//    public boolean isEnabled() {
//        return UserDetails.super.isEnabled();
//    }
//
//
//
//
//}

