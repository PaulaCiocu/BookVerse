import 'package:bookverse/controller/trailController.dart';
import 'package:bookverse/controller/userProfileController.dart';
import 'package:bookverse/tabScreens/home_screens/explore_trails/trail_details.dart';
import 'package:bookverse/widgets/trail_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SeeAnotherUserProfileScreen extends StatefulWidget {
  final String userId;
  const SeeAnotherUserProfileScreen({super.key, required this.userId});

  @override
  State<SeeAnotherUserProfileScreen> createState() => _SeeAnotherUserProfileScreenState();
}

class _SeeAnotherUserProfileScreenState extends State<SeeAnotherUserProfileScreen> {
  Map<String, dynamic>? _userProfile;
  List<dynamic> trails = [];
  bool _isLoadingProfile = true;
  bool _isLoadingTrails = true;
  
  @override
  void initState() {
    super.initState();
    // Load data immediately in initState
    _loadDataImmediately();
  }
  
  Future<void> _loadDataImmediately() async {
    // Start both futures in parallel
    final profileFuture = UserProfileController.fetchUserProfileById(widget.userId);
    final trailsFuture = TrailController.fetchTrailsProfile(widget.userId);
    
    // Handle profile data
    try {
      final profile = await profileFuture;
      if (mounted) {
        setState(() {
          _userProfile = profile;
          _isLoadingProfile = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingProfile = false;
        });
      }
    }
    
    // Handle trails data
    try {
      final trailsList = await trailsFuture;
      if (mounted) {
        setState(() {
          trails = trailsList;
          _isLoadingTrails = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingTrails = false;
        });
      }
    }
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
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,  
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Image.asset(
                              'assets/brown background.png',
                              height: 120,
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                          Positioned(
                            top: 70, 
                            left: MediaQuery.of(context).size.width / 2 - 50,
                            child: _isLoadingProfile 
                              ? const CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.grey,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 50, 
                                  backgroundImage: _userProfile?['profilePictureUrl'] != null
                                    ? CachedNetworkImageProvider(_userProfile!['profilePictureUrl']!)
                                    : const AssetImage('assets/avatars/avatar_woman.png') as ImageProvider,
                                ),
                          ),
                        ],
                      ),
          
                      const SizedBox(height: 60), 
                    
                      _isLoadingProfile
                        ? Container(
                            width: 150,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          )
                        : Text(
                            _userProfile?['fullName'] ?? 'Unknown User', 
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black87)
                          ),
                          
                      const SizedBox(height: 10),
                   
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical:10.0),
                        child: Center( 
                          child: _isLoadingProfile
                            ? Container(
                                width: 250,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              )
                            : Text(
                                _userProfile?['bio'] != null && _userProfile!['bio']!.isNotEmpty 
                                    ? '"${_userProfile!['bio']}"'
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
                        Text('Other trails', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color.fromARGB(255, 225, 209, 179))),
                      ],
                    ),
                  ),
      
                 
                  _isLoadingTrails
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 3, 
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                          );
                        },
                      )
                    : trails.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            'No trails found for this user',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: trails.length,
                          itemBuilder: (context, index) {
                            final trail = trails[index];

                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => TrailDetails(
                                      userId: widget.userId,
                                      trailId: trail['id'].toString(),
                                      onClose: () {},
                                    ),
                                  ),
                                );
                              },
                              child: TrailCard(
                                title: trail['title'] as String? ?? 'No Title',
                                description: trail['description'] as String? ?? 'No description available',
                                imageUrl: trail['imageUrl'] as String?,
                                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                                elevation: 1,
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
          ),
        ]
      ),
    );
  }
}