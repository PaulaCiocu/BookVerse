package com.licenta.bookverse.exception;

public class PasswordMismatchException extends RuntimeException {
    public PasswordMismatchException() {
        super("Password mismatch");
    }
}
