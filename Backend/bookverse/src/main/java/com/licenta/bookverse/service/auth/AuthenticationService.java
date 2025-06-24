package com.licenta.bookverse.service.auth;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;
import com.licenta.bookverse.dto.auth.LoginDTO;
import com.licenta.bookverse.dto.auth.LoginResponse;
import com.licenta.bookverse.dto.auth.RegistrationDTO;
import com.licenta.bookverse.dto.auth.ResetPasswordRequest;
import com.licenta.bookverse.entity.Achievement;
import com.licenta.bookverse.entity.Person;
import com.licenta.bookverse.exception.*;
import com.licenta.bookverse.exception.email.EmailAlreadyExistsException;
import com.licenta.bookverse.exception.email.EmailNotFound;
import com.licenta.bookverse.exception.password.PasswordMismatchException;
import com.licenta.bookverse.exception.password.WeakPasswordException;
import com.licenta.bookverse.repository.AchievementRepository;
import com.licenta.bookverse.repository.PersonRepository;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

@Service
@AllArgsConstructor
public class AuthenticationService {
    private final PersonRepository personRepository;
    @Autowired
    private AchievementRepository achievementRepository;

    public LoginResponse authenticateWithFirebase(String firebaseToken) {
        try {
            FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(firebaseToken.replace("Bearer ", ""));
            String email = decodedToken.getEmail();
            Person user = personRepository.findByEmail(email)
                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));

            LoginResponse response = new LoginResponse();
            response.setPersonId(user.getId());
            response.setToken(firebaseToken);
            response.setExpiresIn(3600L); // or use Firebase expiration if needed
            return response;
        } catch (FirebaseAuthException e) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid Firebase token");
        }
    }

    public String registerPerson(RegistrationDTO registrationDTO) {
        if (personRepository.findByEmail(registrationDTO.getEmail()).isPresent()) {
            throw new EmailAlreadyExistsException();
        }

        Person person = new Person();
        person.setFullName(registrationDTO.getFullName());
        //person.setPassword(registrationDTO.getPassword());
        person.setEmail(registrationDTO.getEmail());
        person.setProfilePictureUrl(registrationDTO.getProfilePictureUrl());

        personRepository.save(person);

        Achievement achievement = new Achievement();
        achievement.setPerson(person);
        achievementRepository.save(achievement);

        return person.getId().toString();
    }

}
