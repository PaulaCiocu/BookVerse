import 'dart:convert';

import 'package:bookverse/tabScreens/home_screens/settings/updateTrailScreen.dart';
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
  
  // Future<bool> updateTrail(String trailId, String title, String description) async {
  //   final url = Uri.parse('http://10.0.2.2:8080/trails/$trailId');
  //   final headers = {
  //     'Content-Type': 'application/json',
  //   };

  //   // Prepare the request body
  //   final body = json.encode({
  //     'title': title,
  //     'description': description,
  //   });

  //   // Send the PUT request to update the profile
  //   final response = await http.put(url, headers: headers, body: body);

  //   // Check the response status to confirm the update
  //   if (response.statusCode == 200) {
  //     return true; // Profile update successful
  //   } else {
  //     print('Failed to update profile: ${response.body}');
  //     return false; // Profile update failed
  //   }
  // }

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

   Future<bool> deleteCreatedTrail(String trailId, bool keepBooksConfirmed) async {
    final url = Uri.parse('http://10.0.2.2:8080/trails/delete/$trailId/${widget.userId}/$keepBooksConfirmed');
    
    try {
      final response = await http.delete(url);

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Trail deleted successfully
        print("Deleted successfully");
        return true;
      } else {
        // Failed to delete trail
        print('Failed to delete trail: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error deleting trail: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text(
        "Created trails",
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
                                                      
                                                      Row(
                                                        children: [
                                                          Center(
                                                            child: GestureDetector(
                                                              onTap: () async {

                                                                Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatetrailScreen(trail: trail, userId: widget.userId,)));
                                                                fetchTrails();  
                                                            },
                                                              child: Padding(
                                                              padding: const EdgeInsets.only(bottom: 12.0, top: 6),
                                                              child: Container(
                                                                width: 70,
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
                                                                      'UPDATE',
                                                                      style: TextStyle(fontSize: 12, color: Colors.black87),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            ),
                                                          ),

                                                          SizedBox(width: 20,),

                                                        
                                                          GestureDetector(
                                                            onTap: () async {
                                                              // Show confirmation dialog
                                                              bool? unfollowConfirmed = await showDialog<bool>(
                                                                context: context,
                                                                builder: (BuildContext context) {
                                                                  return AlertDialog(
                                                                    backgroundColor: Colors.white,
                                                                    contentPadding: EdgeInsets.zero,
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(16),  // Optional: Rounded corners for the dialog
                                                                    ),
                                                                    title: const Column(
                                                                      children: [
                                                                        Text(
                                                                          'Delete created trail', 
                                                                          style: TextStyle(
                                                                            color: Colors.black87,
                                                                            fontWeight: FontWeight.w500,
                                                                            fontSize: 18
                                                                          ),
                                                                        ),
                                                                        SizedBox(height: 20,),
                                                                        Text(
                                                                          'Are you sure you want to delete this trail?', 
                                                                          style: TextStyle(
                                                                            color: Colors.black54,
                                                                            fontSize: 16
                                                                          ),
                                                                        ),
                                                                       // SizedBox(height: 10,),
                                                                      ],
                                                                    ),
                                                                    actions: <Widget>[
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          TextButton(
                                                                            onPressed: () {
                                                                              Navigator.of(context).pop(false); // User cancels logout
                                                                            },
                                                                            child: const Text('CANCEL', style: TextStyle(color: Colors.grey, fontSize: 12),),
                                                                          ),
                                                                          const SizedBox(width: 20,),
                                                                          TextButton(
                                                                            onPressed: () {
                                                                              Navigator.of(context).pop(true); // User confirms logout
                                                                            },
                                                                            child: const Text('YES', style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500),),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                          
                                                              if (unfollowConfirmed == true) {
                                                                
                                                                // Ask user if they want to keep the books in their reading list
                                                                bool? keepBooksConfirmed = await showDialog<bool>(
                                                                  context: context,
                                                                  builder: (BuildContext context) {
                                                                    return AlertDialog(
                                                                      backgroundColor: Colors.white,
                                                                      title: const Text(
                                                                        'Keep Books in List?',
                                                                        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 18),
                                                                      ),
                                                                      content: const Text(
                                                                        'Do you want to keep the books from this trail in your reading list?',
                                                                        style: TextStyle(color: Colors.black54, fontSize: 16),
                                                                      ),
                                                                      actions: <Widget>[
                                                                        Row(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          children: [
                                                                            TextButton(
                                                                              onPressed: () {
                                                                                Navigator.of(context).pop(false); 
                                                                              },
                                                                              child: const Text('NO', style: TextStyle(color: Colors.grey, fontSize: 14)),
                                                                            ),
                                                                            const SizedBox(width: 20),
                                                                            TextButton(
                                                                              onPressed: () {
                                                                                Navigator.of(context).pop(true);
                                                                              },
                                                                              child: const Text('YES', style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500)),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                );
                                                          
                                                                deleteCreatedTrail(trail['trail']['id'].toString(), keepBooksConfirmed!);
                                                          
                                                              }
                                                               _refreshTrails();
                                                            },
                                                                              
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(bottom: 12.0, top: 6),
                                                              child: Container(
                                                                width: 70,
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
                                                                      'DELETE',
                                                                      style: TextStyle(fontSize: 12, color: Colors.black87),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
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