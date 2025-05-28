import 'package:bookverse/controller/trailController.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


class ExploreTrails extends StatefulWidget {
  final String userId;
  final Function(String trailKey) onTrailsSelected;

  const ExploreTrails({super.key, required this.onTrailsSelected, required this.userId});

  @override
  State<ExploreTrails> createState() => _ExploreTrailsState();
}

class _ExploreTrailsState extends State<ExploreTrails> {
  List<dynamic> trails = [];
  bool isLoading = true;
  String selectedFilter = "All"; 
  TextEditingController searchController = TextEditingController(); 

  void filterTrails(String filter) {
    setState(() {
      selectedFilter = filter;
      searchController.clear();
    });
  }

  void applyFilter() {
    String searchText = searchController.text;
    if (selectedFilter == "All" || searchText.isEmpty) {
      fetchTrails();
    } else {
      if (selectedFilter == "Genre") {
        fetchTrails(genre: searchText);
      } else if (selectedFilter == "Title") {
        fetchTrails(bookTitle: searchText);
      } else if (selectedFilter == "Author") {
        fetchTrails(author: searchText);
      } else if (selectedFilter == "Trail") {
        fetchTrails(trailName: searchText);
      }
    }
  }

  Future<void> fetchTrails({String? genre, String? author, String? bookTitle, String? trailName }) async {
    final trailList = await TrailController.fetchTrailsExcept(genre: genre, author: author,bookTitle: bookTitle,trailName: trailName, userId: widget.userId);
    setState(() {
      trails = List.of(trailList);
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchTrails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 60),
          const Text(
            "Explore Trails",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700
            ),
          ),
          const SizedBox(height: 40),
          // Search bar 
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
            child: Row(
              children: [
                // Search TextField
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        hintText: 'Search trails by $selectedFilter',
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: applyFilter,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  onSelected: filterTrails,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), 
                  ),
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: "All", child: Text("All")),
                    const PopupMenuItem(value: "Genre", child: Text("Genre")),
                    const PopupMenuItem(value: "Title", child: Text("Book Title")),
                    const PopupMenuItem(value: "Author", child: Text("Book Author")),
                    const PopupMenuItem(value: "Trail", child: Text("Trail Name")),
                  ],
                  icon: const Icon(Icons.filter_list),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: fetchTrails,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : trails.isEmpty
                    ? const Center(
                        child: Text(
                          'No trails available',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                      )
                    : ListView.builder(
                        itemCount: trails.length,
                        itemBuilder: (context, index) {
                          final trail = trails[index];
                          return GestureDetector(
                            onTap: () {
                              widget.onTrailsSelected(trail['trailId'].toString());
                            },
                            child: Container(
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
                                    title: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          trail['personName'] ?? 'Unknown',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w800,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          trail['title'] ?? 'No Title',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Text(
                                      trail['description'] ?? 'No Description',
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    leading: ClipOval(
                                      child: trail['imageUrl'] != null
                                          ? CachedNetworkImage(
                                              imageUrl: trail['imageUrl']!,
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              'assets/user_profile_backgrounds_screen.png',
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ),
        ],
      ),
    );
  }

}
