import 'package:bookverse/tabScreens/home_screens/explore_trails/trailDetails.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Add http package
import 'dart:convert'; // For jsonDecode

class ExploreTrails extends StatefulWidget {
  final String userId;
  final Function(String trailKey) onTrailsSelected;
  const ExploreTrails({super.key, required this.onTrailsSelected, required this.userId});

  @override
  State<ExploreTrails> createState() => _ExploreTrailsState();
}

class _ExploreTrailsState extends State<ExploreTrails> {
  List<dynamic> trails = []; // Use dynamic list to hold trail data
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTrails(); // Fetch trails when the widget is initialized
  }

  Future<void> fetchTrails() async {
    setState(() {
      isLoading = true; 
    });
    
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8080/trails/except/person/${widget.userId}'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          trails = jsonData;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load trails. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false; 
      });
      print('Error fetching trails: $e'); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: fetchTrails,
        child: isLoading
            ? const Center(child: CircularProgressIndicator()) 
            : Column(
              children: [
                const SizedBox(height: 100),
                const Text(
                  "Explore Trails",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: trails.length,
                      itemBuilder: (context, index) {
                        final trail = trails[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                          decoration: BoxDecoration(
                            color: Colors.white, 
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade200,
                                spreadRadius: 2, 
                                blurRadius: 2, 
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  trail['title'] ?? 'No Title',
                                  style: const TextStyle(
                                    fontSize: 16, 
                                    fontWeight: FontWeight.w500, 
                                  ),
                                ), 
                                subtitle: Text(
                                  trail['description'] ?? 'No Description',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis, 
                                  style: const TextStyle(
                                    fontSize: 14, 
                                  ),
                                ),
                                leading: ClipOval(
                                  child: trail['imageUrl'] != null
                                      ? Image.network(
                                          trail['imageUrl']!,
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          'assets/user_profile_backgrounds_screen.png', // Fallback image
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                                   
                              ),
                              GestureDetector(
                                onTap: () {
                                  widget.onTrailsSelected(trail['trailId'].toString());
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0, top: 6),
                                  child: Container(
                                    width: 100, // Set the desired width
                                    height: 30, // Set the desired height
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFDCAA),
                                      borderRadius: BorderRadius.circular(6),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.shade300,
                                          blurRadius: 3,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Explore',
                                          style: TextStyle(fontSize: 14, color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),
                  
                        
                        );
                      },
                    ),
                ),
              ],
            ),
      ),
    );
  }
}


