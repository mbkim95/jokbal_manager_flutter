import 'package:flutter/material.dart';
import 'package:jokbal_manager/model/order.dart';

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

extension EnumConverter on LegType {
  int toInt() {
    if (this == LegType.front) {
      return 1;
    } else if (this == LegType.back) {
      return 2;
    } else {
      return 3;
    }
  }
}
