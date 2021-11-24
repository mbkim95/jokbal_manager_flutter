import 'package:flutter/material.dart';

extension NumberParsing on TextEditingController {
  int toInt() {
    try {
      return int.parse(value.text);
    } on FormatException catch (_) {
      return 0;
    }
  }

  double toDouble() {
    try {
      return double.parse(value.text);
    } on FormatException catch (_) {
      return 0;
    }
  }
}
