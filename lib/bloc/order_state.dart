import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:jokbal_manager/model/order.dart';

@immutable
abstract class OrderState extends Equatable {}

class LoadingState extends OrderState {
  @override
  List<Object?> get props => [];
}

class ErrorState extends OrderState {
  String message;

  ErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

class LoadedState extends OrderState {
  int year;
  int month;
  List<DayOrder> orders;
  double totalWeight;
  int totalPrice;
  int totalBalance;

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
