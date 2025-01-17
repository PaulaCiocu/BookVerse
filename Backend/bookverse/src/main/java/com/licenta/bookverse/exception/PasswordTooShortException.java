package com.licenta.bookverse.exception;

public class PasswordTooShortException extends RuntimeException {
    public PasswordTooShortException() {
        super("Password too short");
    }
}
