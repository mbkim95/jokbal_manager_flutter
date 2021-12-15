import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:jokbal_manager/model/order.dart';

@immutable
abstract class YearOrderState extends Equatable {}

class LoadingState extends YearOrderState {
  @override
  List<Object?> get props => [];
}

class ErrorState extends YearOrderState {
  final String message;

  ErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

class LoadedState extends YearOrderState {
  final int year;
  final List<MonthOrder> orders;
  final double totalWeight;
  final int totalPrice;
  final int totalBalance;

  LoadedState(
      {required this.year,
      required this.orders,
      required this.totalWeight,
      required this.totalPrice,
      required this.totalBalance});

  @override
  List<Object?> get props =>
      [year, orders, totalWeight, totalPrice, totalBalance];
}
