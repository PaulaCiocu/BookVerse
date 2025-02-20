package com.licenta.bookverse.exception.email;

public class EmailNotFound extends RuntimeException {
    public EmailNotFound() {
        super("No account found with this email");
    }
}
