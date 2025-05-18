import 'dart:async';

class AppEvents {
  static final StreamController<void> profileUpdated = StreamController<void>.broadcast();

  static final StreamController<void> achievementsUpdated = StreamController<void>.broadcast();
  static void notifyAchievementsUpdated() {
    achievementsUpdated.add(null);
  }

  static void notifyProfileUpdated() {
    profileUpdated.add(null);
  }
}