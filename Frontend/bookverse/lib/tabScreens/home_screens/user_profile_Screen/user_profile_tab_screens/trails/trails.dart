import 'dart:convert';

import 'package:bookverse/controller/trailController.dart';
import 'package:bookverse/tabScreens/home_screens/user_profile_Screen/user_profile_tab_screens/trails/create_trail/create_trail.dart';
import 'package:bookverse/tabScreens/home_screens/user_profile_Screen/user_profile_tab_screens/trails/create_trail/update_trail.dart';
import 'package:bookverse/tabScreens/home_screens/user_profile_Screen/user_profile_tab_screens/trails/trail_progress.dart';
import 'package:bookverse/widgets/dialogs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrailsScreen extends StatefulWidget {
  final String userId;
  final VoidCallback onClose;

  const TrailsScreen({
    super.key,
    required this.userId,
    required this.onClose,
  });

  @override
  _TrailsScreenState createState() => _TrailsScreenState();
}

class _TrailsScreenState extends State<TrailsScreen> {
  List<dynamic> _createdTrails = [];
  List<dynamic> _followedTrails = [];
  bool isLoading = true;

  static const String _cacheKeyPrefix = 'trails_';

  @override
  void initState() {
    super.initState();
    _loadCachedThenFetch();
  }

  /// 1) Load from cache (if any), then
  /// 2) Fetch fresh from server and overwrite both state & cache.
  Future<void> _loadCachedThenFetch() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$_cacheKeyPrefix${widget.userId}');

    if (raw != null) {
      if (!mounted) return; 
      // decode cached list
      final List<dynamic> all = jsonDecode(raw);
      setState(() {
        _createdTrails =
            all.where((t) => t['createdType'] == 'CREATED').toList();
        _followedTrails =
            all.where((t) => t['createdType'] == 'FOLLOWED').toList();
        isLoading = false;
      });
    }

    // now fetch fresh
    try {
      final allTrails = await TrailController.fetchTrails(widget.userId);
      // separate
      final created =
          allTrails.where((t) => t['createdType'] == 'CREATED').toList();
      final followed =
          allTrails.where((t) => t['createdType'] == 'FOLLOWED').toList();
      if (!mounted) return;
      setState(() {
        _createdTrails = created;
        _followedTrails = followed;
        isLoading = false;
      });

      // update cache
      await prefs.setString(
        '$_cacheKeyPrefix${widget.userId}',
        jsonEncode(allTrails),
      );
    } catch (e) {
      // if fetch fails, leave whatever we had (cache or empty)
      setState(() => isLoading = false);
      // optionally show a Snackbar or toast here
    }
  }

  Future<void> _loadTrailsOnly() async {
    // helper if you want pull-to-refresh
    setState(() => isLoading = true);
    await _loadCachedThenFetch();
  }

  Widget buildTrailCard(dynamic trail, {bool isFollowed = false}) {
    if (trail['trail']['deleted'] == true) {
      return Card(
        color: Colors.grey.shade300,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
        elevation: 1,
        child: ListTile(
          title: Text(trail['trail']['title'] ?? 'No Title'),
          subtitle: const Text("This trail was deleted by the owner."),
        ),
      );
    }

    final pagesRead = trail['pagesRead'] ?? 0;
    final totalBooksPages = trail['trail']['totalPages'] ?? 1;
    final progress = (pagesRead / totalBooksPages).clamp(0.0, 1.0);
    final progressPercentage = (progress * 100).toStringAsFixed(0);

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
      elevation: 1,
      child: ListTile(
        onTap: () {
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
        leading: trail['trail']['imageUrl'] != null
            ? ClipOval(
                child: CachedNetworkImage(
                  imageUrl: trail['trail']['imageUrl'],
                  width: 45,
                  height: 45,
                  fit: BoxFit.cover,
                ),
              )
            : const Icon(Icons.book, size: 45),
        title: Text(
          trail['trail']['title'] ?? 'No Title',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Text(
            trail['trail']['description'] ?? 'No description available',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey[600]),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Progress circle
            SizedBox(
              width: 50,
              height: 50,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[300],
                    color: const Color.fromARGB(255, 251, 207, 146),
                    strokeWidth: 4,
                  ),
                  Text('$progressPercentage%',
                      style: const TextStyle(fontSize: 10)),
                ],
              ),
            ),
            const SizedBox(width: 6),

            if (isFollowed)
              GestureDetector(
                onTap: () async {
                  bool? confirmed = await showRemoveTrailDialog(context);
                  if (confirmed == true) {
                    bool? keepBooks = await showKeepBooksDialog(context);
                    await TrailController.unfollowTrailFromReadingList(
                      widget.userId,
                      trail['trail']['id'].toString(),
                      keepBooks!,
                    );
                    await _loadTrailsOnly();
                  }
                },
                child: Icon(Icons.delete,
                    size: 20, color: Colors.red.shade400),
              )
            else
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdatetrailScreen(
                            trail: trail,
                            userId: widget.userId,
                          ),
                        ),
                      );
                      await _loadTrailsOnly();
                    },
                    child: const Icon(Icons.edit,
                        size: 20, color: Colors.black54),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () async {
                      bool? confirmed =
                          await showRemoveCreatedTrailDialog(context);
                      if (confirmed == true) {
                        bool? keepBooks = await showKeepBooksDialog(context);
                        await TrailController.deleteCreatedTrail(
                          widget.userId,
                          trail['trail']['id'].toString(),
                          keepBooks!,
                        );
                        await _loadTrailsOnly();
                      }
                    },
                    child: Icon(Icons.delete,
                        size: 20, color: Colors.red.shade400),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
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
          // top background
          SizedBox(
            width: double.infinity,
            child: Image.asset(
              'assets/trail_background.png',
              height: 140,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),

          // content
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text("Trails List",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 40),
                  Expanded(
                    child: DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          const TabBar(
                            indicatorColor: Colors.black,
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.grey,
                            tabs: [
                              Tab(text: 'Created'),
                              Tab(text: 'Followed'),
                            ],
                          ),
                          Expanded(
                            child: isLoading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : TabBarView(
                                    children: [
                                      // CREATED
                                      _createdTrails.isEmpty
                                          ? const Center(
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(top: 60),
                                                child: Text(
                                                  "You haven't created any trails yet.",
                                                ),
                                              ),
                                            )
                                          : RefreshIndicator(
                                              onRefresh: _loadTrailsOnly,
                                              child: ListView(
                                                padding: const EdgeInsets
                                                        .only(bottom: 40) +
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0),
                                                children: [
                                                  ..._createdTrails
                                                      .map((t) =>
                                                          buildTrailCard(t))
                                                      .toList(),
                                                  const SizedBox(height: 20),
                                                  Center(
                                                    child: GestureDetector(
                                                      onTap: () async {
                                                        await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                CreateTrailStepOne(
                                                                    userId: widget
                                                                        .userId),
                                                          ),
                                                        );
                                                        await _loadTrailsOnly();
                                                      },
                                                      child: Container(
                                                        width: 140,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: const Color(
                                                              0xFFFFDCAA),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            'Create trail',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyLarge
                                                                ?.copyWith(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 20),
                                                ],
                                              ),
                                            ),

                                      // FOLLOWED
                                      _followedTrails.isEmpty
                                          ? const Center(
                                              child: Padding(
                                              padding:
                                                  EdgeInsets.only(top: 60),
                                              child: Text(
                                                "You haven't followed any trails yet.",
                                              ),
                                            ))
                                          : RefreshIndicator(
                                              onRefresh: _loadTrailsOnly,
                                              child: ListView.builder(
                                                itemCount:
                                                    _followedTrails.length,
                                                itemBuilder: (ctx, idx) =>
                                                    buildTrailCard(
                                                  _followedTrails[idx],
                                                  isFollowed: true,
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
