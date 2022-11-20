import 'package:flutter/material.dart';

class SimpleField extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final int? maxLines;

  const SimpleField({
    Key? key,
    required this.hint,
    this.maxLines,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: hint,
        ),
      ),
    );
  }
}
