import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BookTile extends StatelessWidget {
  final Map book;
  final VoidCallback onTap;
  final Icon icon;
  final Color backgroundColor;

  const BookTile({
    super.key,
    required this.book,
    required this.onTap,
    required this.icon,
    this.backgroundColor = const Color(0xFFFFDCAA),
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        book['title'] ?? 'Unknown Title',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      subtitle: Text(
        book['author'] ?? 'Unknown Author',
        style: Theme.of(context).textTheme.bodySmall,
      ),
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
      trailing: IconButton(
        onPressed: onTap,
        icon: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: backgroundColor,
                blurRadius: 2,
              ),
            ],
          ),
          child: icon,
        ),
      ),
    );
  }
}
