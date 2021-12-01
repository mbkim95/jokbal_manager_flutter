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

List<DayOrder> generateDummyDate() {
  var today = DateTime.now();
  var year = today.year.toInt();
  var month = today.month.toInt();
  return generateDummyDateByParameter(year, month);
}

List<DayOrder> generateDummyDateByParameter(int year, int month) {
  var orders = <DayOrder>[];
  var days = getDaysOfMonthList(year, month);
  for (var order in days) {
    orders.add(DayOrder(order, <Order>[]));
  }
  return orders;
}

List<String> getDaysOfMonthList(int year, int month) {
  var dates = <String>[];
  var maxDay = DateTime(year, month + 1, 0).day;
  String textMonth = month < 10 ? '0$month' : '$month';
  for (int i = 1; i <= maxDay; i++) {
    var date = i < 10 ? '$year-$textMonth-0$i' : '$year-$textMonth-$i';
    dates.add(date);
  }
  return dates;
}
