import 'package:cached_network_image/cached_network_image.dart';
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
      extendBodyBehindAppBar:true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: 
        [
          SizedBox(
                  width: double.infinity, 
                  height: 140,
                  child: trail['imageUrl'] != null
                    ? CachedNetworkImage(
                        imageUrl: trail['imageUrl']!,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/user_profile_backgrounds_screen.png',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                ),
          Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trail['title'] ?? 'No Title',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)
                        ),
                        const SizedBox(height: 20),
                       
                        Text(
                          trail['description'] ?? 'No Description',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 20),
                
                        Text(
                          "Books",
                          style: Theme.of(context).textTheme.titleMedium
                        ),
                        const SizedBox(height: 8),
                            
                        Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          color: Colors.grey.shade100,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
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
                                          leading:  book['coverImageUrl'] != null
                                            ? ClipOval(
                                                child: CachedNetworkImage(
                                                  imageUrl: book['coverImageUrl']!,
                                                  width: 50,
                                                  height: 50,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            : const Icon(Icons.book, size: 50),
                                          title: Text(
                                            "$index. ${book['title'] ?? 'No Title'}",
                                            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500)                                      ),
                                          subtitle: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("${book['author'] ?? 'Unknown'}", 
                                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600], fontStyle:FontStyle.italic,)),
                                              Text("Pages: $pagesRead/ $totalPages", style: Theme.of(context).textTheme.bodySmall),
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
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            ),
          ),
        ]
      ),
    );
  }
}