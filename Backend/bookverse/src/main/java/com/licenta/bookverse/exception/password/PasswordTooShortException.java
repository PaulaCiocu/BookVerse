package com.licenta.bookverse.exception.password;

public class PasswordTooShortException extends RuntimeException {
    public PasswordTooShortException() {
        super("Password too short");
    }
}
