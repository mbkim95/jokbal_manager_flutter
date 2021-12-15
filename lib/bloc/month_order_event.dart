import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:jokbal_manager/model/order_entity.dart';

@immutable
abstract class MonthOrderEvent extends Equatable {}

class LoadDayOrderListEvent extends MonthOrderEvent {
  @override
  List<Object?> get props => [];
}

class CreateDayOrderEvent extends MonthOrderEvent {
  final OrderEntity order;

  CreateDayOrderEvent({required this.order});

  @override
  List<Object?> get props => [order];
}

class DeleteDayOrderEvent extends MonthOrderEvent {
  final OrderEntity order;

  DeleteDayOrderEvent({required this.order});

  @override
  List<Object?> get props => [order];
}

class UpdateOrderEvent extends MonthOrderEvent {
  final String prevDate;
  final OrderEntity order;

  UpdateOrderEvent({required this.prevDate, required this.order});

  @override
  List<Object?> get props => [prevDate, order];
}

class ChangeMonthEvent extends MonthOrderEvent {
  final int year;
  final int month;

  ChangeMonthEvent({required this.year, required this.month});

  @override
  List<Object?> get props => [year, month];
}

class NextMonthEvent extends MonthOrderEvent {
  @override
  List<Object?> get props => [];
}

class PrevMonthEvent extends MonthOrderEvent {
  @override
  List<Object?> get props => [];
}
