import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jokbal_manager/bloc/year/year_order_event.dart';
import 'package:jokbal_manager/bloc/year/year_order_state.dart';
import 'package:jokbal_manager/model/order.dart';
import 'package:jokbal_manager/model/order_sum.dart';
import 'package:jokbal_manager/repository/order_repository.dart';
import 'package:jokbal_manager/util.dart';

class YearOrderBloc extends Bloc<YearOrderEvent, YearOrderState> {
  final OrderRepository repository;
  late int year;
  List<MonthOrder> orders = [];

  YearOrderBloc(this.repository)
      : super(LoadedState(
            orders: generateDummyMonth(),
            year: 2022,
            totalWeight: 0.0,
            totalPrice: 0,
            totalBalance: 0)) {
    final now = DateTime.now();
    year = now.year;
  }

  @override
  Stream<YearOrderState> mapEventToState(YearOrderEvent event) async* {
    if (event is LoadMonthOrderListEvent) {
      yield* _mapLoadMonthListEvent(event);
    } else if (event is ChangeYearEvent) {
      yield* _mapChangeMonthEvent(event.year);
    } else if (event is NextYearEvent) {
      yield* _mapChangeMonthEvent(year < 2099 ? year + 1 : year);
    } else if (event is PrevYearEvent) {
      yield* _mapChangeMonthEvent(year > 2015 ? year - 1 : year);
    } else {
      yield* super.mapEventToState(event);
    }
  }

  Stream<YearOrderState> _mapLoadMonthListEvent(
      LoadMonthOrderListEvent event) async* {
    try {
      yield LoadingState();
      orders = await repository.getYearOrders(year);

      var total = _sumTotalOrders(orders);
      yield LoadedState(
          orders: orders,
          year: year,
          totalWeight: total.totalWeight,
          totalPrice: total.totalPrice,
          totalBalance: total.totalBalance);
    } on Exception catch (e) {
      yield ErrorState(message: e.toString());
    }
  }

  Stream<YearOrderState> _mapChangeMonthEvent(int year) async* {
    try {
      yield LoadingState();

      this.year = year;

      orders = await repository.getYearOrders(year);

      var total = _sumTotalOrders(orders);
      yield LoadedState(
          orders: orders,
          year: year,
          totalWeight: total.totalWeight,
          totalPrice: total.totalPrice,
          totalBalance: total.totalBalance);
    } on Exception catch (e) {
      yield ErrorState(message: e.toString());
    }
  }

  OrderSum _sumTotalOrders(List<MonthOrder> orders) {
    double weights = 0.0;
    int prices = 0;
    int balances = 0;

    for (MonthOrder order in orders) {
      weights += order.weight;
      prices += order.price;
      balances += order.balance;
    }
    return OrderSum(weights, prices, balances);
  }
}
