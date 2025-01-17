package com.licenta.bookverse.exception;

public class EmailNotFound extends RuntimeException {
    public EmailNotFound() {
        super("No account found with this email");
    }
}
