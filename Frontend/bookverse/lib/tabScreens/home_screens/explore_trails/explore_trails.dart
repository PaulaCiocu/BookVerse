import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  @override
  void initState() {
    super.initState();
    fetchTrails(); // Fetch trails when the widget is initialized
  }

  Future<void> fetchTrails({String? genre, String? author, String? bookTitle, String? trailName }) async {
    setState(() {
      isLoading = true;
    });

    final Map<String, String> queryParams = {};

    if (genre != null && genre.isNotEmpty) {
      queryParams['genre'] = genre;
    } else if (author != null && author.isNotEmpty) {
      queryParams['author'] = author;
    } else if (bookTitle != null && bookTitle.isNotEmpty) {
      queryParams['bookTitle'] = bookTitle;
    } else if (trailName != null && trailName.isNotEmpty) {
      queryParams['trailName'] = trailName;
    }

    Uri uri = Uri.parse('http://10.0.2.2:8080/trails/except/person/${widget.userId}')
        .replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri);
      print(response.body);

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

  void filterTrails(String filter) {
    setState(() {
      selectedFilter = filter;
      searchController.clear(); // Clear previous input when a new filter is selected
    });
  }

  void applyFilter() {
    String searchText = searchController.text;
    if (selectedFilter == "All" || searchText.isEmpty) {
      fetchTrails();
    } else {
      // Call fetchTrails based on the selected filter
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 100),
          const Text(
            "Explore Trails",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700
            ),
          ),
          const SizedBox(height: 100),
          // Search bar at the top of the body
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
                        hintText: 'Search trails by',
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
                        borderRadius: BorderRadius.circular(12), // Rounded corners for the menu
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
          const SizedBox(height: 20),
          // RefreshIndicator only wraps the ListView
          Expanded(
            child: RefreshIndicator(
              onRefresh: fetchTrails,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
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
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      trail['personName'] ?? 'Unknown',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.italic
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
                                          'assets/user_profile_backgrounds_screen.png',
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
                                    width: 100,
                                    height: 30,
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
          ),
        ],
      ),
    );
  }

}
