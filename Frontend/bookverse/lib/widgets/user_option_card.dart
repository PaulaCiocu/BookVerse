
import 'package:flutter/material.dart';

Widget buildOptionCard({
  required BuildContext context,
  required String label,
  required VoidCallback onTap,
  required String iconPath,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: const Color.fromARGB(255, 240, 225, 200),
      shadowColor: Colors.black12, 
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(iconPath, width: 45, height: 45),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600])
            ),
          ],
        ),
      ),
    ),
  );
}