import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreatedTrailsscreen extends StatefulWidget {
  final String userId;
  const CreatedTrailsscreen({super.key, required this.userId});

  @override
  State<CreatedTrailsscreen> createState() => _CreatedTrailsscreenState();
}

class _CreatedTrailsscreenState extends State<CreatedTrailsscreen> {
  
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
      final response = await http.get(Uri.parse('http://10.0.2.2:8080/reading-trails/created/person/${widget.userId}'));
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
    await fetchTrails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text(
        "Followed trails",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20, 
          color: Colors.black87, 
        ),
      ),
      backgroundColor: const Color(0xFFFFDCAA), 
      elevation: 0,
    ),
      body: SafeArea(
        child: SingleChildScrollView( 
          child: Column(
            children: [
              const SizedBox(height: 60),  
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
                                                          
                                                        },
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(bottom: 12.0, top: 6),
                                                          child: Container(
                                                            width: 120,
                                                            height: 20,
                                                            decoration: BoxDecoration(
                                                              color: const Color(0xFFFFDCAA),
                                                              borderRadius: BorderRadius.circular(3),
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
                                                                  'UPDATE/DELETE',
                                                                  style: TextStyle(fontSize: 12, color: Colors.black87),
                                                                ),
                                                              ],
                                                            ),
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
              
            ],
          ),
        ),
      ),
    );
  }
}