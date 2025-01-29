import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DataField extends StatelessWidget {
  const DataField(
      {required this.text,
      required this.controller,
      required this.inputType,
      super.key});

  final String text;
  final TextEditingController controller;
  final TextInputType inputType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: GoogleFonts.poppins(fontSize: 16),
        ),
        Container(
          color: Colors.grey,
          child: TextField(
            keyboardType: inputType,
            controller: controller,
          ),
        ),
      ],
    );
  }
}
