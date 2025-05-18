import 'package:bookverse/controller/trailController.dart';
import 'package:bookverse/tabScreens/home_screens/explore_trails/see_another_user_profile_screen.dart';
import 'package:bookverse/tabScreens/home_screens/search_screen/book_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class TrailDetails extends StatefulWidget {
  final String trailId;
  final String userId;
  final VoidCallback onClose;

  const TrailDetails({super.key, required this.trailId, required this.onClose, required this.userId});

  @override
  State<TrailDetails> createState() => _TrailDetailsState();
}

class _TrailDetailsState extends State<TrailDetails> {
  Future<Map<String, dynamic>>? _trailFuture;
  bool _isAddedToList = false;

  @override
  void initState() {
    super.initState();
    _trailFuture = TrailController.fetchTrailDetails(widget.trailId);
    _checkIfTrailInReadingList();
  }

  Future<void> _checkIfTrailInReadingList() async {
    final isAdded = await TrailController.checkIfTrailInReadingList(widget.userId, widget.trailId);
    setState(() {
      _isAddedToList = isAdded;
    });
  }

  Future<void> addToReadingList() async {
    final isAdded = await TrailController.addToReadingList(widget.userId, widget.trailId);
    setState(() {
      _isAddedToList = isAdded;
    });
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
      body: FutureBuilder<Map<String, dynamic>>(
        future: _trailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Failed to load trail details"));
          } else {
            final trail = snapshot.data!;
            return Stack(
              children: [
                // background image
                SizedBox(
                  width: double.infinity,
                  height: 160,
                  child: CachedNetworkImage(
                    imageUrl: trail['imageUrl'] ?? '',
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Image.asset(
                      'assets/user_profile_backgrounds_screen.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // main content
                Padding(
                  padding: const EdgeInsets.only(top: 180.0),
                  child: SafeArea(
                    top: false,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(trail['title'] ?? 'No Title', style: Theme.of(context).textTheme.titleLarge),
                                    Row(
                                      children: [
                                        Text(
                                          trail['personName'] ?? 'Unknown',
                                          style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.remove_red_eye, size: 16),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => SeeAnotherUserProfileScreen(userId: trail['creatorId']),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "Readings: ${trail['numberOfReadings'] ?? 0}",
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                                ElevatedButton.icon(
                                  onPressed: _isAddedToList ? null : addToReadingList,
                                  label: Text(_isAddedToList ? "Trail Added" : "Add Trail"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _isAddedToList ? Colors.green : const Color(0xFFFFDCAA),
                                    foregroundColor: Colors.black87,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  icon: const Icon(Icons.bookmark_add_outlined),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Card(
                              elevation: 1,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      trail['description'] ?? 'No Description',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Genre:', style: Theme.of(context).textTheme.bodyMedium),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: Text(
                                            trail['genre'] != null
                                                ? trail['genre'].join(", ")
                                                : 'No genre info available',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                            style: Theme.of(context).textTheme.bodyMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Text('Books', style: Theme.of(context).textTheme.titleMedium),
                            Card(
                              elevation: 3,
                              margin: const EdgeInsets.symmetric(vertical: 12),
                              color: Colors.white,
                              child: Column(
                                children: (trail['trailBookList'] as List<dynamic>? ?? []).map((bookEntry) {
                                  var book = bookEntry['book'];
                                  return ListTile(
                                    leading: book['coverImageUrl'] != null
                                        ? ClipOval(
                                            child: CachedNetworkImage(
                                              imageUrl: book['coverImageUrl']!,
                                              width: 45,
                                              height: 45,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : const Icon(Icons.book, size: 50),
                                    title: Text(
                                      book['title'] ?? 'No Title',
                                      style: Theme.of(context).textTheme.titleSmall,
                                    ),
                                    subtitle: Text(
                                      book['author'] ?? 'Unknown',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            fontStyle: FontStyle.italic,
                                            color: Colors.grey[600],
                                          ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => BookDetailScreen(
                                            bookKey: book['key'],
                                            onClose: () {},
                                            userId: widget.userId,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
