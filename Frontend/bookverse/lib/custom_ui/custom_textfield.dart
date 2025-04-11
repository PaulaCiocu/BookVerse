import 'package:flutter/material.dart';

Widget buildTextField({
  required TextEditingController controller,
  required bool isObscure,
  required String hintText,
  required String? Function(String?) validator,
  required bool isValid,
  required void Function(String) onChanged,
  int maxLines = 1,
  double minHeight = 50,
}) {
  return Container(
    width: double.infinity,
    constraints: BoxConstraints(minHeight: minHeight),
    child: TextFormField(
      controller: controller,
      obscureText: isObscure,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 14, color: Color(0xFF171719), height: 1.36),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(12),
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: isValid ? Colors.green : Colors.red),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: isValid ? Colors.green : const Color(0xFFD7D7DC)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: validator,
      onChanged: onChanged,
    ),
  );
}
