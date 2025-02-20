package com.licenta.bookverse.exception.password;

public class WeakPasswordException extends RuntimeException {
    public WeakPasswordException() {
        super("Password must be at least 8 characters, include one uppercase letter, one lowercase letter, one number, and one special character.");
    }
}
