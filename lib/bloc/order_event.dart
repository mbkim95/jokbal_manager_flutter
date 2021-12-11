import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:jokbal_manager/model/order_entity.dart';

@immutable
abstract class OrderEvent extends Equatable {}

class LoadDayOrderListEvent extends OrderEvent {
  @override
  List<Object?> get props => [];
}

class CreateDayOrderEvent extends OrderEvent {
  OrderEntity order;

  CreateDayOrderEvent({required this.order});

  @override
  List<Object?> get props => [order];
}

class DeleteDayOrderEvent extends OrderEvent {
  OrderEntity order;

  DeleteDayOrderEvent({required this.order});

  @override
  List<Object?> get props => [order];
}

class UpdateOrderEvent extends OrderEvent {
  String prevDate;
  OrderEntity order;

  UpdateOrderEvent({required this.prevDate, required this.order});

  @override
  List<Object?> get props => [prevDate, order];
}

class ChangeMonthEvent extends OrderEvent {
  int year;
  int month;

  ChangeMonthEvent({required this.year, required this.month});

  @override
  List<Object?> get props => [year, month];
}

class NextMonthEvent extends OrderEvent {
  @override
  List<Object?> get props => [];
}

class PrevMonthEvent extends OrderEvent {
  @override
  List<Object?> get props => [];
}
