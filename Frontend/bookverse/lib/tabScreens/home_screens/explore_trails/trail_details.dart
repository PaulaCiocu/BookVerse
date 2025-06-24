import 'package:bookverse/controller/trailController.dart';
import 'package:bookverse/tabScreens/home_screens/explore_trails/see_another_user_profile_screen.dart';
import 'package:bookverse/tabScreens/home_screens/search_screen/book_details_screen.dart';
import 'package:bookverse/widgets/book_tile.dart';
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
  bool _isAddedToList = false;
  late final Future<void> _initFuture;
  Map<String, dynamic>? _trail;

  @override
  void initState() {
    super.initState();
    _initFuture = Future.wait([
      TrailController.fetchTrailDetails(widget.trailId),
      TrailController.checkIfTrailInReadingList(widget.userId, widget.trailId),
    ]).then((results) {
      _trail = results[0] as Map<String, dynamic>;
      _isAddedToList = results[1] as bool;
      if (_trail!['imageUrl'] != null) {
        precacheImage(NetworkImage(_trail!['imageUrl']), context);
      }
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
      body: FutureBuilder<void>(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Failed to load trail details"));
          } else {
            final trail = _trail!;
            return Stack(
              children: [
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
                              child: SizedBox(
                                height: 200, 
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: (trail['trailBookDTODetails'] as List).length,
                                  itemBuilder: (ctx, i) {
                                    final book = (trail['trailBookDTODetails'] as List)[i] as Map<String, dynamic>;
                                    return BookTile(
                                      book: book,
                                      icon: const Icon(Icons.arrow_forward, size: 16, color: Colors.white),
                                      backgroundColor: const Color(0xFFFFDCAA),
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => BookDetailScreen(
                                              bookKey: book['bookKey'] as String,
                                              onClose: () {},
                                              userId: widget.userId,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
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
