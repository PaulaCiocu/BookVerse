import 'package:flutter/material.dart';


void showTopSnackBar(
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
