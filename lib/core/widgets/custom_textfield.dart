import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int? maxLines;
  final int? minLines;
  final bool? expands;
  final Color? focusedColor;
  final double? borderRadius;
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.maxLines,
    this.expands,
    this.minLines,
    this.focusedColor,
    this.borderRadius,

  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      expands: expands ?? false,
      minLines: maxLines,

      textAlignVertical: TextAlignVertical.top,
     maxLines: maxLines,

      decoration: InputDecoration(
        hintText: hintText,

        filled: true,
        fillColor: Colors.grey.shade50,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),

        hintStyle: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 16,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 18),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 18),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 18),
          borderSide: BorderSide(
            color: focusedColor ?? Colors.green,
            width: 2,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 18),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
