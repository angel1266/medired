import 'package:flutter/material.dart';

class AppDecorations {
  static final InputDecoration input = InputDecoration(
    hintStyle: const TextStyle(
      fontWeight: FontWeight.bold,
      color: Color.fromRGBO(33, 57, 118, 0.4),
    ),
    filled: true,
    fillColor: const Color.fromRGBO(255, 255, 255, 0.7),
    labelStyle: const TextStyle(fontSize: 12),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(15),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(15),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(15),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.red, width: 1.0),
      borderRadius: BorderRadius.circular(15),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(15),
    ),
  );
}
