import 'package:bookverse/controller/achievments_controller.dart';
import 'package:flutter/material.dart';

class AchievmentsScreen extends StatefulWidget {
  final String userId;
  final VoidCallback onClose;

  const AchievmentsScreen({
    super.key,
    required this.onClose,
    required this.userId,
  });

  @override
  _AchievmentsScreenState createState() => _AchievmentsScreenState();
}

class _AchievmentsScreenState extends State<AchievmentsScreen> {
  bool isLoading = true;
  Map<String, dynamic>? achievements;

  void fetchAchievements() async {
    final achievmentsList = await AchievmentsController.fetchAchievements(widget.userId);
    setState(() {
      achievements = achievmentsList;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAchievements();
  }
  
  Widget buildAchievementBadge(String label, bool isUnlocked, String imagePath) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0), 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 2, 
      color: isUnlocked ? Colors.white : Colors.grey[300], 
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0), 
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, 
          children: [
            Row(
              children: [
                Image.asset(
                  imagePath, 
                  width: 20,
                  height: 20,
                  color: isUnlocked ? null : Colors.black.withOpacity(0.5), 
                ),
                const SizedBox(width: 8), 
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14, 
                    fontWeight: FontWeight.w500,
                    color: isUnlocked ? Colors.black : Colors.grey,
                  ),
                ),
              ],
            ),
            Icon(
              isUnlocked ? Icons.lock_open : Icons.lock, 
              color: Colors.grey, 
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                child: Image.asset(
                  'assets/achievements.png',
                  height: 120,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                "Achievements",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '  Reads',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    isLoading
                        ? const CircularProgressIndicator()
                        : achievements == null
                            ? const Text('No data available')
                            : Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      // Single Padding for all Rows
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Image.asset('assets/icons/pink_book_icon.png', width: 30, height: 30),
                                                const SizedBox(width: 10),
                                                Text(
                                                  'Total Books In Progress: ${achievements!['bookInProgress']}',
                                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Image.asset('assets/icons/book_icon.png', width: 30, height: 30),
                                                const SizedBox(width: 10),
                                                Text(
                                                  'Total Books Read: ${achievements!['totalBooksRead']}',
                                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Image.asset('assets/icons/books_shelve_icon.png', width: 30, height: 30),
                                                const SizedBox(width: 10),
                                                Text(
                                                  'Total Trails In Progress: ${achievements!['trailsInProgress']}',
                                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Image.asset('assets/icons/multiple_books_icon.png', width: 30, height: 30),
                                                const SizedBox(width: 10),
                                                Text(
                                                  'Total Trails Completed: ${achievements!['totalTrailsCompleted']}',
                                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Image.asset('assets/icons/page_icons.png', width: 30, height: 30),
                                                const SizedBox(width: 10),
                                                Text(
                                                  'Total Pages Read: ${achievements!['totalPagesRead']}',
                                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                '  Milestones',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 10),
                              // Check and display badges
                              // Achievement Badges with Conditions
                              if (achievements != null && achievements!['totalBooksRead'] != null && achievements!['totalBooksRead'] >= 1)
                                buildAchievementBadge('Read 1 book', true, 'assets/badges/medal_icon.png')
                              else
                                buildAchievementBadge('Read 1 book', false, 'assets/badges/medal_icon.png'),
                              if (achievements != null && achievements!['totalPagesRead'] != null && achievements!['totalPagesRead'] >= 100)
                                buildAchievementBadge('Read 100 pages', true, 'assets/badges/crown_icon.png')
                              else
                                buildAchievementBadge('Read 100 pages', false, 'assets/badges/crown_icon.png'),
                              if (achievements != null && achievements!['totalTrailsCompleted'] != null && achievements!['totalTrailsCompleted'] >= 1)
                                buildAchievementBadge('Complete 1 trail', true, 'assets/badges/medal_neck.png')
                              else
                                buildAchievementBadge('Complete 1 trail', false, 'assets/badges/medal_neck.png'),

                              
                              if (achievements != null && achievements!['totalPagesRead'] != null && achievements!['totalPagesRead'] >= 1000)
                                buildAchievementBadge('Read 1000 pages', true, 'assets/badges/police_icon.png')
                              else
                                buildAchievementBadge('Read 1000 pages', false, 'assets/badges/police_icon.png'),
                              if (achievements != null && achievements!['totalBooksRead'] != null && achievements!['totalBooksRead'] >= 10)
                                buildAchievementBadge('Read 10 books', true,'assets/badges/cup_icon.png')
                              else
                                buildAchievementBadge('Read 10 books', false,'assets/badges/cup_icon.png'),
                              if (achievements != null && achievements!['totalTrailsCompleted'] != null && achievements!['totalTrailsCompleted'] >= 5)
                                buildAchievementBadge('Complete 5 trails', true, 'assets/badges/star_icon.png')
                              else
                                buildAchievementBadge('Complete 5 trails', false, 'assets/badges/star_icon.png'),
                       
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
