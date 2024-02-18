import 'package:flutter/material.dart';

class CtextField extends StatelessWidget {
  TextEditingController controller;
  bool readOnly;
  bool filled;
  String label;
  TextInputAction? textInputAction;
  void Function()? onEditingComplete;
  Color? fillColor;
  CtextField({
    super.key,
    required this.controller,
    this.readOnly = false,
    required this.label,
    this.fillColor,
    this.filled = false,
    this.textInputAction,
    this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      textInputAction: textInputAction,
      onEditingComplete: onEditingComplete,
      decoration: InputDecoration(
        filled: filled,
        fillColor: fillColor,
        label: Text(label),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 18,
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.blue.shade400,
            )),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
