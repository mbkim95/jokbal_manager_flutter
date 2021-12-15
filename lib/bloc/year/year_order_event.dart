import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class YearOrderEvent extends Equatable {}

class LoadMonthOrderListEvent extends YearOrderEvent {
  @override
  List<Object?> get props => [];
}

class ChangeYearEvent extends YearOrderEvent {
  final int year;

  ChangeYearEvent({required this.year});

  @override
  List<Object?> get props => [year];
}

class NextYearEvent extends YearOrderEvent {
  @override
  List<Object?> get props => [];
}

class PrevYearEvent extends YearOrderEvent {
  @override
  List<Object?> get props => [];
}
