import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bookverse/controller/achievments_controller.dart';

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
  // Default initial values
  Map<String, dynamic> _achievements = {
    'bookInProgress': 0,
    'totalBooksRead': 0,
    'trailsInProgress': 0,
    'totalTrailsCompleted': 0,
    'totalPagesRead': 0,
  };
  
  bool _isLoading = true;
  
  // Cache key for storing achievement data
  static const String _cacheKey = 'user_achievements_';

  @override
  void initState() {
    super.initState();
    // Load data with cache strategy
    _loadAchievementsWithCache();
  }
  
  Future<void> _loadAchievementsWithCache() async {
    // First try to load from cache
    final cachedData = await _loadFromCache();
    
    if (cachedData != null && mounted) {
      // Update UI with cached data first
      setState(() {
        _achievements = cachedData;
        _isLoading = false;
      });
    }
    
    // Then fetch fresh data in background
    try {
      final freshData = await AchievmentsController.fetchAchievements(widget.userId);
      
      if (mounted) {
        // Update the UI with fresh data
        setState(() {
          _achievements = freshData;
          _isLoading = false;
        });
        
        // Cache the new data
        await _saveToCache(freshData);
      }
    } catch (e) {
      print('Failed to fetch achievements: $e');
      
      if (mounted && cachedData == null) {
        // Only update loading state if we don't have cached data
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  Future<Map<String, dynamic>?> _loadFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString('${_cacheKey}${widget.userId}');
      if (cached != null) {
        return jsonDecode(cached) as Map<String, dynamic>;
      }
    } catch (e) {
      print('Error loading from cache: $e');
    }
    return null;
  }
  
  Future<void> _saveToCache(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('${_cacheKey}${widget.userId}', jsonEncode(data));
    } catch (e) {
      print('Error saving to cache: $e');
    }
  }
  
  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final freshData = await AchievmentsController.fetchAchievements(widget.userId);
      
      if (mounted) {
        setState(() {
          _achievements = freshData;
          _isLoading = false;
        });
        
        await _saveToCache(freshData);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to refresh achievements'))
        );
      }
    }
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
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isUnlocked ? Colors.black : Colors.grey,
                  )
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

  Widget buildStatRow(String iconPath, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(iconPath, width: 30, height: 30),
          const SizedBox(width: 15),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget buildAchievementsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reads',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 10),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                buildStatRow(
                  'assets/icons/pink_book_icon.png', 
                  'Books In Progress: ${_achievements['bookInProgress']}'
                ),
                buildStatRow(
                  'assets/icons/book_icon.png', 
                  'Books Read: ${_achievements['totalBooksRead']}'
                ),
                buildStatRow(
                  'assets/icons/books_shelve_icon.png', 
                  'Trails In Progress: ${_achievements['trailsInProgress']}'
                ),
                buildStatRow(
                  'assets/icons/multiple_books_icon.png', 
                  'Trails Completed: ${_achievements['totalTrailsCompleted']}'
                ),
                buildStatRow(
                  'assets/icons/page_icons.png', 
                  'Pages Read: ${_achievements['totalPagesRead']}'
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Milestones',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 10),
        
        // Achievement Badges with Conditions
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                buildAchievementBadge(
                  'Read 1 book', 
                  _achievements['totalBooksRead'] >= 1, 
                  'assets/badges/medal_icon.png'
                ),
                buildAchievementBadge(
                  'Read 100 pages', 
                  _achievements['totalPagesRead'] >= 100, 
                  'assets/badges/crown_icon.png'
                ),
                buildAchievementBadge(
                  'Complete 1 trail', 
                  _achievements['totalTrailsCompleted'] >= 1, 
                  'assets/badges/medal_neck.png'
                ),
                buildAchievementBadge(
                  'Read 1000 pages', 
                  _achievements['totalPagesRead'] >= 1000, 
                  'assets/badges/police_icon.png'
                ),
                buildAchievementBadge(
                  'Read 10 books', 
                  _achievements['totalBooksRead'] >= 10,
                  'assets/badges/cup_icon.png'
                ),
                buildAchievementBadge(
                  'Complete 5 trails', 
                  _achievements['totalTrailsCompleted'] >= 5, 
                  'assets/badges/star_icon.png'
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar:true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        // This paints a fading black overlay behind the toolbar area
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black87,  // very dark at the top
                Colors.transparent // fade to fully clear
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Stack(
        children:
        [
          SizedBox(
            width: double.infinity,
            child: Image.asset(
              'assets/achievements.png',
              height: 140,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      "Achievements",
                       style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)
                    ),
                    const SizedBox(height: 20),
                    
                    // Main content
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _isLoading && _achievements['totalBooksRead'] == 0
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : buildAchievementsContent(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]
      ),
    );
  }
}