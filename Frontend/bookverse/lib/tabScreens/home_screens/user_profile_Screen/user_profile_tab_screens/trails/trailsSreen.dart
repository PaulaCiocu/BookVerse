import 'dart:convert';
import 'package:bookverse/tabScreens/home_screens/user_profile_Screen/user_profile_tab_screens/trails/trailProgreesScreen.dart';
import 'package:bookverse/tabScreens/home_screens/user_profile_Screen/user_profile_tab_screens/trails/create_trail/createTrailStepOne.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TrailsScreen extends StatefulWidget {
  final String userId;
  final VoidCallback onClose;



  const TrailsScreen({super.key, required this.userId, required this.onClose,});

  @override
  _TrailsScreenState createState() => _TrailsScreenState();
}

class _TrailsScreenState extends State<TrailsScreen> {
  List<dynamic> trails = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTrails();
  }

  Future<void> fetchTrails() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8080/reading-trails/person/${widget.userId}'));
      if (response.statusCode == 200) {
        setState(() {
          trails = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load trails');
      }
    } catch (error) {
      print('Error fetching trails: $error');
      setState(() => isLoading = false);
    }
  }

  Future<void> _refreshTrails() async {
    await fetchTrails(); // Call fetchTrails when user pulls down
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(  // Make everything scrollable
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Image.asset(
                  'assets/trail_background.png',
                  height: 120,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                "Trails List",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 60),  
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _refreshTrails,
                      child: Column(
                        children: [
                          trails.isEmpty
                              ? const Center(child: Text("No trails available."))
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: trails.length,
                                  itemBuilder: (context, index) {
                                    final trail = trails[index];
                                    //final booksRead = trail['progress'] ?? 0;
                                    final pagesRead = trail['pagesRead'] ?? 0;
                                    //final totalBooks = trail['totalBooks'] ?? 2;
                                    final totalBooksPages = trail['trail']['totalPages'] ?? 1;
                                    final progress = (pagesRead / totalBooksPages).clamp(0.0, 1.0);final progressPercentage = (progress * 100).toStringAsFixed(0); // Convert to percentage string
                                    final trailBooks = trail['trail']['trailBooks'] as List<dynamic>;
                                    print(totalBooksPages);
                                    return Card(
                                      color: Colors.white,
                                      margin: const EdgeInsets.only(
                                          top: 8.0, bottom: 8.0, left: 20.0, right: 20.0),
                                      elevation: 1,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ListTile(
                                                  title: Text(
                                                    trail['trail']['title'] ?? 'No Title',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  subtitle: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      
                                                      Text(
                                                        trail['trail']['description'] ?? 'No description available',
                                                        style: const TextStyle(
                                                          color: Colors.black45,
                                                          fontSize: 12,
                                                        ),
                                                        maxLines: 5, 
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      const SizedBox(height: 6),
                                                      
                                                      GestureDetector(
                                                        onTap: () {
                                                          // Navigate to the TrailProgressScreen with the trail details
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => Trailprogreesscreen(
                                                                trail: trail['trail'],
                                                                createdType: trail['createdType'],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: const Text(
                                                          'View trail ..',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                           // fontWeight: FontWeight.w500,
                                                            color: Colors.black54,  // Text color
                                                          ),
                                                        ),
                                                      ),

                                                    ],
                                                  ),
                                                 leading: ClipOval(
                                                  child: trail['trail']['imageUrl'] != null
                                                      ? Image.network(
                                                          trail['trail']['imageUrl'],
                                                          width: 40,
                                                          height: 40,
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image.asset(
                                                          'assets/user_profile_backgrounds_screen.png',
                                                          width: 40,
                                                          height: 40,
                                                          fit: BoxFit.cover,
                                                        ),
                                                ),

                                                ),
                                              ),

                                              SizedBox(
                                                width: 60, // Set width for the circular progress
                                                height: 60,
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    CircularProgressIndicator(
                                                      value: progress,
                                                      backgroundColor: Colors.grey[300], // Background color of the progress circle
                                                      color: const Color.fromARGB(255, 251, 207, 146), // Color of the progress
                                                      strokeWidth: 4, // You can also adjust the stroke width if needed
                                                    ),
                                                    Text(
                                                      '$progressPercentage%', // Display progress percentage
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 12, // Adjust font size for better visibility
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // Button moved inside ListTile
    
                                            ],
                                          ),
                                              
                                          ],
                                      ),
                                    );
                                  },
                                ),
                        ],
                      ),
                    ),
              const SizedBox(height: 60),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  CreateTrailStepOne(userId: widget.userId,)));
                },
                child: Container(
                  width: 120,
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFFFFDCAA),
                  ),
                  child: const Center(
                    child: Text(
                      'Create trail',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
