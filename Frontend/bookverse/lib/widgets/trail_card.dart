import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TrailCard extends StatelessWidget {
  final String title;
  final String description;
  final String? imageUrl;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry margin;
  final double elevation;

  const TrailCard({
    Key? key,
    required this.title,
    required this.description,
    this.imageUrl,
    this.onTap,
    this.margin = const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
    this.elevation = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: margin,
      elevation: elevation,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    leading: imageUrl != null
                        ? ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: imageUrl!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(Icons.book, size: 50),
                    title: Text(
                      title,
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
                          description,
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
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
