# README - BookVerse

## Project Overview

**BookVerse** is a mobile app designed to help users track and organize their reading journeys through personalized **Trails** — themed reading paths. It allows users to discover books, track progress, write reviews, and connect with other readers. The app integrates Flutter, Firebase, Spring Boot, PostgreSQL (Neon), and Open Library API for a seamless experience.

---

## Features

- Create, follow, unfollow, and delete Trails (themed book lists)  
- Search for books by title, author, or genre  
- Track reading progress on books and Trails  
- Write and submit book reviews  
- Customize user profiles (avatar, favorite quote)  
- Receive notifications for updates on followed Trails

---

## Installation & Setup

### Prerequisites
  - Java Development Kit (JDK 11+)
  - Flutter SDK
> **Note:** The application connects to a cloud-hosted PostgreSQL database (Neon). Connection details are managed securely via environment variables.

### Clone the  repository:  
   ```bash
   git clone https://github.com/PaulaCiocu/BookVerse.git
   ```
### Backend

   Navigate to the backend folder and build the project
   ```bash
  cd backend
  ./mvnw spring-boot:run
  ```
### Frontend

   Navigate into the frontend folder to run the mobile app:
   ```bash
  cd frontend
  flutter pub get
  flutter run
  ```
---
## Usage

- Sign in or register using Firebase Authentication.

- Browse or create personalized Trails based on interests.

- Search, add, and track books in Trails.

- Review and rate books.

- Customize your profile.

- Receive notifications about Trails you follow.


## Testing
Manual testing performed on Android emulators for UI and usability.

Backend API endpoints tested using Swagger.

Unit tests for core services and controllers implemented with JUnit and Mockito.

## Notes
The Open Library API provides book metadata for search and display.

PostgreSQL stores user data, book info, Trails, progress, and reviews.

Firebase handles authentication and media (profile images) storage.

## Configuration and Environment Variables

The application stores sensitive configuration data such as database connection parameters (host, username, password) in environment variables to ensure security and prevent accidental exposure in the source code.

For security reasons, these environment variables are not included in the repository.

If required, a separate configuration file containing the necessary environment variable values can be provided directly upon request.


