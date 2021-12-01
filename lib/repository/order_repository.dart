import 'package:intl/intl.dart';
import 'package:jokbal_manager/model/order.dart';
import 'package:jokbal_manager/model/order_entity.dart';
import 'package:jokbal_manager/repository/order_dao.dart';
import 'package:jokbal_manager/util.dart';

class OrderRepository {
  static final _instance = OrderRepository._();
  final _dao = OrderDao();

  Future insertOrder(OrderEntity order) async {
    OrderEntity? searchedOrder =
        await _dao.findOrderByType(order.date, order.type);
    if (searchedOrder == null) {
      await _dao.insertOrder(order);
      return;
    }
    await _dao.addSameDate(order.date, order.type, order.weight, order.deposit);
  }

  Future<List<DayOrder>> getMonthOrders(int year, int month) async {
    var start = '$year-$month-01';
    var end = DateTime(year, month + 1, 0);
    var formatter = DateFormat('yyyy-MM-dd');
    var orders = await _dao.getOrderDate(start, formatter.format(end));
    return _convertEntityToOrder(orders, year, month);
  }

  Future<List<MonthOrder>> getYearOrders(int year) async {
    var orders = await _dao.getOrderDate('$year-01-01', '$year-12-31');
    var yearOrders = <MonthOrder>[];
    for (int i = 1; i <= 12; i++) {
      var month = i < 10 ? '0$i' : '$i';
      yearOrders.add(MonthOrder('$year-$month', 0, 0.0, 0));
    }
    for (var order in orders) {
      var m = int.parse(order.date.substring(5, 7));
      var totalPrice = (order.price * order.weight).toInt();
      yearOrders[m - 1].price += totalPrice;
      yearOrders[m - 1].weight += order.weight;
      yearOrders[m - 1].balance += (totalPrice - order.deposit);
    }
    return yearOrders;
  }

  Future deleteOrder(OrderEntity order) async {
    await _dao.deleteOrder(order);
  }

  Future updateOrder(String date, int type, OrderEntity order) async {
    var searchedOrder = await _dao.findOrderByType(order.date, order.type);
    // 날짜를 수정했더니 기존에 있는 품목에 추가해야하는 경우에는 수정 전 데이터를 삭제하고 기존에 있던 품목에 더해준다
    if (date != order.date && type == order.type && searchedOrder != null) {
      await _dao.deleteOrder(OrderEntity(
          date: date,
          type: type,
          price: order.price,
          weight: order.weight,
          deposit: order.deposit));
      await _dao.addSameDate(
          order.date, order.type, order.weight, order.deposit);
      return;
    }
    await _dao.updateOrder(
        date, type, order.date, order.price, order.weight, order.deposit);
  }

  List<DayOrder> _convertEntityToOrder(
      List<OrderEntity> entities, int year, int month) {
    var orders = generateDummyDateByParameter(year, month);
    for (var order in entities) {
      var day = order.date.split('-').map((e) => int.parse(e)).toList()[2];
      var type = order.type == 1
          ? LegType.front
          : (order.type == 2 ? LegType.back : LegType.mix);
      orders[day - 1].orders.add(Order(
          type: type,
          price: order.price,
          weight: order.weight,
          deposit: order.deposit));
    }
    return orders;
  }

  factory OrderRepository() => _instance;

  OrderRepository._();
}
