import 'dart:convert';
import 'package:bookverse/tabScreens/user_screens/create_trail/createTrailStepOne.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TrailsScreen extends StatefulWidget {
  final String userId;
  final VoidCallback onClose;

  const TrailsScreen({super.key, required this.userId, required this.onClose});

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
                  'assets/book_reading_background.png',
                  height: 160,
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
              const SizedBox(height: 60),  // Adjust space between title and list
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _refreshTrails,
                      child: Column(
                        children: [
                          trails.isEmpty
                              ? const Center(child: Text("No trails available."))
                              : ListView.builder(
                                  shrinkWrap: true,  // Make the ListView take only the required space
                                  itemCount: trails.length,
                                  itemBuilder: (context, index) {
                                    final trail = trails[index]['trail'];
                                    final createdType = trails[index]['createdType'];
                                    return Card(
                                      color: Colors.white,
                                      margin: const EdgeInsets.only(
                                          top: 8.0, bottom: 8.0, left: 20.0, right: 20.0),
                                      elevation: 1,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            title: Text(
                                              trail['title'] ?? 'No Title',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            subtitle: Text(
                                              createdType ?? 'Created type',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Colors.black45,
                                                fontSize: 12,
                                              ),
                                            ),
                                            leading: ClipOval(
                                              child: Image.asset(
                                                'assets/book_background.png',
                                                width: 40,
                                                height: 40,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
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
