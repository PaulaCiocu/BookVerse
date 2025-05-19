import 'package:bookverse/controller/trailController.dart';
import 'package:bookverse/controller/userProfileController.dart';
import 'package:bookverse/tabScreens/home_screens/explore_trails/trail_details.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SeeAnotherUserProfileScreen extends StatefulWidget {
  final String userId;
  const SeeAnotherUserProfileScreen({super.key, required this.userId});

  @override
  State<SeeAnotherUserProfileScreen> createState() => _SeeAnotherUserProfileScreenState();
}

class _SeeAnotherUserProfileScreenState extends State<SeeAnotherUserProfileScreen> {
  Future<Map<String, dynamic>>? _userProfile; 
  List<dynamic> trails = [];
 
  void _loadUserProfile() {
    setState(() {
      _userProfile = UserProfileController.fetchUserProfileById(widget.userId);
    });
  }

  Future<void> _loadTrails() async {
    final trailsList = await TrailController.fetchTrails(widget.userId);
    setState(() {
      trails = trailsList;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadTrails();
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black87, Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Stack(
        children: 
        [
          SafeArea(
            child: SingleChildScrollView(
              child: FutureBuilder<Map<String, dynamic>>(
                future: _userProfile,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final user = snapshot.data!;
                    return Column(
                      children: [
                        // User Profile Info
                        Column(
                          children: [
                          Stack(
                              clipBehavior: Clip.none,  
                              children: [
                                // Background image
                                SizedBox(
                                  width: double.infinity,
                                  child: Image.asset(
                                    'assets/brown background.png',
                                    height: 120,
                                    fit: BoxFit.cover,
                                    alignment: Alignment.topCenter,
                                  ),
                                ),
                                // Profile picture (Avatar)
                                Positioned(
                                  top: 70, // Adjust this value to position the avatar on top of the background
                                  left: MediaQuery.of(context).size.width / 2 - 50, // Center the avatar horizontally
                                  child: CircleAvatar(
                                    radius: 50, // Set the size of the avatar
                                    backgroundImage: user['profilePictureUrl'] != null
                                      ? CachedNetworkImageProvider(user['profilePictureUrl']!)
                                      : const AssetImage('assets/avatars/avatar_woman.png') as ImageProvider,
                                  ),
                                ),
                              ],
                            ),
              
                          const SizedBox(height: 60), // Space between avatar and name
                  
                          Text(user['fullName'] ?? 'Unknown User', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black87)),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical:10.0),
                            child: Center( 
                              child: Text(
                                user['bio'] != null && user['bio']!.isNotEmpty 
                                    ? '"${user['bio']}"'
                                    : '"No bio available"',
                                style: const TextStyle(
                                  fontSize: 16, 
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black54
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          ],
                        ),
                        const SizedBox(height: 40,),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Other trails', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color.fromARGB(255, 225, 209, 179), )),
                            ],
                          ),
                        ),
          
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: trails.length,
                            itemBuilder: (context, index) {
                              final trail = trails[index];
                        
                              return InkWell(
                                onTap: (){
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => TrailDetails( userId: widget.userId, trailId:  trail['trail']['id'].toString(), onClose: () {},),
                                    ),
                                  );
                                },
                                child: Card(
                                  color: Colors.white,
                                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
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
                                                    ],
                                              ),
                                              leading: trail['trail']['imageUrl'] != null
                                                ? ClipOval(
                                                    child: CachedNetworkImage(
                                                      imageUrl: trail['trail']['imageUrl'],
                                                      width: 50,
                                                      height: 50,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                                : const Icon(Icons.book, size: 50),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                            
                      
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ]
      ),
    );
  }
}