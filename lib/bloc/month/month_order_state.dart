import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:jokbal_manager/model/order.dart';

@immutable
abstract class MonthOrderState extends Equatable {}

class LoadingState extends MonthOrderState {
  @override
  List<Object?> get props => [];
}

class ErrorState extends MonthOrderState {
  final String message;

  ErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

class LoadedState extends MonthOrderState {
  final int year;
  final int month;
  final List<DayOrder> orders;
  final double totalWeight;
  final int totalPrice;
  final int totalBalance;

  LoadedState(
      {required this.year,
      required this.month,
      required this.orders,
      required this.totalWeight,
      required this.totalPrice,
      required this.totalBalance});

  @override
  List<Object?> get props =>
      [year, month, orders, totalWeight, totalPrice, totalBalance];
}
