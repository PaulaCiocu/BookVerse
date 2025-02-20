package com.licenta.bookverse.exception.password;

public class PasswordMismatchException extends RuntimeException {
    public PasswordMismatchException() {
        super("Password mismatch");
    }
}
