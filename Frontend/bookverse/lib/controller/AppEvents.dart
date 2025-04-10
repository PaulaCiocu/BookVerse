import 'dart:async';

class AppEvents {
  // Create a static stream controller for profile updates
  static final StreamController<void> profileUpdated = StreamController<void>.broadcast();
  
  // Method to notify listeners that the profile was updated
  static void notifyProfileUpdated() {
    profileUpdated.add(null);
  }
}