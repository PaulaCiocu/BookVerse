import 'package:flutter/material.dart';


void showBottomSnackBar(
  BuildContext context,
  String message, {
  Color backgroundColor = Colors.black87,
  Color textColor = Colors.white,
  IconData? icon,
  Duration duration = const Duration(seconds: 3),
}) {
 final topInset = MediaQuery.of(context).padding.top + kToolbarHeight;

  final snackBar = SnackBar(
    elevation: 0, 
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.fromLTRB(28, topInset, 28, 14),
    backgroundColor: backgroundColor,
    duration: duration,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    content: Container(
      height: 18,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, color: textColor, size: 20),
            const SizedBox(width: 8),
          ],
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: textColor),
          ),
        ],
      ),
    ),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

 void showCustomSnackbar(BuildContext context, String errorMessage,{
      Color backgroundColor = Colors.transparent,
      Color textColor = Colors.white,
      IconData? icon,
      Duration duration = const Duration(seconds: 3),
    }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 60, 
        left: 40,
        right: 40,
        child: Material(
          color: backgroundColor,
          child: Container(
            width: 300,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color:  Colors.white, // Match button color
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                errorMessage,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

