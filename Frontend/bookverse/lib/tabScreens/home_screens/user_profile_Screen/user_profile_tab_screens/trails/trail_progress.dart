import 'package:flutter/material.dart';

class Trailprogreesscreen extends StatefulWidget {
  final dynamic trail;
  final String createdType;
  const Trailprogreesscreen({super.key, this.trail, required this.createdType});

  @override
  State<Trailprogreesscreen> createState() => _TrailprogreesscreenState();
}

class _TrailprogreesscreenState extends State<Trailprogreesscreen> {
   @override
  Widget build(BuildContext context) {
    final trail = widget.trail; 

    return Scaffold(
      appBar: AppBar(
        title: Text('Trail Details'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity, 
                child: trail['imageUrl'] != null
                    ? Image.network(
                        trail['imageUrl']!,
                        height: 180,
                        fit: BoxFit.cover, // Ensure it covers the width nicely
                        alignment: Alignment.topCenter, // Focus on the top part
                      )
                    : Image.asset(
                        'assets/user_profile_backgrounds_screen.png', // Use Image.asset for local assets
                        height: 180,
                        fit: BoxFit.cover, // Ensure it covers the width nicely
                        alignment: Alignment.topCenter, // Focus on the top part
                      ),
              ),
          
                    
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      trail['title'] ?? 'No Title',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.createdType,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      trail['description'] ?? 'No Description',
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 20),
            
                    // Display Books in the Trail
                    const Text(
                      "Books",
                      style: TextStyle(fontSize: 16,),
                    ),
                    const SizedBox(height: 8),
                        
                    Column(
                      children: (trail['trailBooks'] as List<dynamic>? ?? []).map((bookEntry) {
                        final book = bookEntry['book'];
                        final pagesRead = bookEntry['pagesRead'] ?? 0;
                        final index = bookEntry['orderIndex'].toString();
                          final totalPages = book['pages'] ?? 1;
                          final progress = (pagesRead / totalPages).clamp(0.0, 1.0);
                          final progressPercentage = (progress * 100).toStringAsFixed(0);
          
                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          color: Colors.white,
                          child: Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  leading: ClipOval(
                                    child: Image.network(
                                      book['coverImageUrl'] ?? 'assets/default_image.png', // Fallback to a default image if null
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Text(
                                    "$index. ${book['title'] ?? 'No Title'}",
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("${book['author'] ?? 'Unknown'}"),
                                      Text("Pages: $pagesRead/ $totalPages"),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 60,
                                height: 60,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      value: progress,
                                      backgroundColor: Colors.grey[300],
                                      color: const Color.fromARGB(255, 251, 207, 146),
                                      strokeWidth: 4,
                                    ),
                                    Text(
                                      '$progressPercentage%',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                     
                    
                  ],
                ),
              )
                  
             
            ],
          ),
        ),
      ),
    );
  }
}