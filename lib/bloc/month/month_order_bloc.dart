import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jokbal_manager/bloc/month/month_order_event.dart';
import 'package:jokbal_manager/bloc/month/month_order_state.dart';
import 'package:jokbal_manager/model/order.dart';
import 'package:jokbal_manager/model/order_sum.dart';
import 'package:jokbal_manager/repository/order_repository.dart';
import 'package:jokbal_manager/util.dart';

class MonthOrderBloc extends Bloc<MonthOrderEvent, MonthOrderState> {
  final OrderRepository repository;
  final formatter = DateFormat("yyyy-MM");
  late int year;
  late int month;
  List<DayOrder> orders = [];

  MonthOrderBloc(this.repository)
      : super(LoadedState(
            orders: generateDummyDate(),
            year: 2022,
            month: 1,
            totalWeight: 0.0,
            totalPrice: 0,
            totalBalance: 0)) {
    final now = DateTime.now();
    year = now.year;
    month = now.month;
  }

  @override
  Stream<MonthOrderState> mapEventToState(MonthOrderEvent event) async* {
    if (event is LoadDayOrderListEvent) {
      yield* _mapLoadOrderListEvent(event);
    } else if (event is CreateDayOrderEvent) {
      yield* _mapCreateDayOrderEvent(event);
    } else if (event is DeleteDayOrderEvent) {
      yield* _mapDeleteDayOrderEvent(event);
    } else if (event is UpdateOrderEvent) {
      yield* _mapUpdateOrderEvent(event);
    } else if (event is ChangeMonthEvent) {
      yield* _mapChangeMonthEvent(event.year, event.month);
    } else if (event is NextMonthEvent) {
      year = month == 12 ? year + 1 : year;
      month = month == 12 ? 1 : month + 1;
      yield* _mapChangeMonthEvent(year, month);
    } else if (event is PrevMonthEvent) {
      year = month == 1 ? year - 1 : year;
      month = month == 1 ? 12 : month - 1;
      yield* _mapChangeMonthEvent(year, month);
    }
    yield* super.mapEventToState(event);
  }

  Stream<MonthOrderState> _mapLoadOrderListEvent(
      LoadDayOrderListEvent event) async* {
    try {
      yield LoadingState();
      orders = await repository.getMonthOrders(year, month);

      var total = _sumTotalOrders(orders);
      yield LoadedState(
          orders: orders,
          year: year,
          month: month,
          totalWeight: total.totalWeight,
          totalPrice: total.totalPrice,
          totalBalance: total.totalBalance);
    } on Exception catch (e) {
      yield ErrorState(message: e.toString());
    }
  }

  Stream<MonthOrderState> _mapCreateDayOrderEvent(
      CreateDayOrderEvent event) async* {
    try {
      yield LoadingState();
      await repository.insertOrder(event.order);

      var createdDate = DateTime.parse(event.order.date);
      if (createdDate.year == year && createdDate.month == month) {
        orders = await repository.getMonthOrders(year, month);
      }
      var total = _sumTotalOrders(orders);
      yield LoadedState(
          orders: orders,
          year: year,
          month: month,
          totalWeight: total.totalWeight,
          totalPrice: total.totalPrice,
          totalBalance: total.totalBalance);
    } on Exception catch (e) {
      yield ErrorState(message: e.toString());
    }
  }

  Stream<MonthOrderState> _mapDeleteDayOrderEvent(
      DeleteDayOrderEvent event) async* {
    try {
      yield LoadingState();
      await repository.deleteOrder(event.order);

      var deletedDate = DateTime.parse(event.order.date);
      if (deletedDate.year == year && deletedDate.month == month) {
        orders = await repository.getMonthOrders(year, month);
      }
      var total = _sumTotalOrders(orders);
      yield LoadedState(
          orders: orders,
          year: year,
          month: month,
          totalWeight: total.totalWeight,
          totalPrice: total.totalPrice,
          totalBalance: total.totalBalance);
    } on Exception catch (e) {
      yield ErrorState(message: e.toString());
    }
  }

  Stream<MonthOrderState> _mapUpdateOrderEvent(UpdateOrderEvent event) async* {
    try {
      yield LoadingState();
      await repository.updateOrder(
          event.prevDate, event.order.type, event.order);

      var updatedDate = DateTime.parse(event.order.date);
      if (updatedDate.year == year && updatedDate.month == month) {
        orders = await repository.getMonthOrders(year, month);
      }
      var total = _sumTotalOrders(orders);
      yield LoadedState(
          orders: orders,
          year: year,
          month: month,
          totalWeight: total.totalWeight,
          totalPrice: total.totalPrice,
          totalBalance: total.totalBalance);
    } on Exception catch (e) {
      yield ErrorState(message: e.toString());
    }
  }

  Stream<MonthOrderState> _mapChangeMonthEvent(int year, int month) async* {
    try {
      yield LoadingState();

      this.year = year;
      this.month = month;

      orders = await repository.getMonthOrders(year, month);

      var total = _sumTotalOrders(orders);
      yield LoadedState(
          orders: orders,
          year: year,
          month: month,
          totalWeight: total.totalWeight,
          totalPrice: total.totalPrice,
          totalBalance: total.totalBalance);
    } on Exception catch (e) {
      yield ErrorState(message: e.toString());
    }
  }

  OrderSum _sumTotalOrders(List<DayOrder> orders) {
    double weights = 0.0;
    int prices = 0;
    int balances = 0;

    for (DayOrder today in orders) {
      for (Order order in today.orders) {
        weights += order.weight;
        prices += order.price;
        balances += (order.weight * order.price).toInt() - order.deposit;
      }
    }

    return OrderSum(weights, prices, balances);
  }
}
