import 'package:jokbal_manager/model/order_entity.dart';
import 'package:jokbal_manager/repository/database_provider.dart';

class OrderDao {
  final provider = DatabaseProvider.provider;

  Future insertOrder(OrderEntity order) async {
    final db = await provider.db;
    await db.insert('orders', order.toJson());
  }

  Future<List<OrderEntity>> getOrderDate(String start, String end) async {
    final db = await provider.db;
    var lists = await db.rawQuery(
        'SELECT * FROM orders WHERE date BETWEEN ? AND ?', [start, end]);
    return lists.map((json) => OrderEntity.fromJson(json)).toList();
  }

  Future<OrderEntity?> findOrderByType(String date, int type) async {
    final db = await provider.db;
    var lists = await db.rawQuery(
        'SELECT * FROM orders WHERE date = ? AND type = ?', [date, type]);
    if (lists.isEmpty) {
      return null;
    }
    return lists.map((json) => OrderEntity.fromJson(json)).toList()[0];
  }

  Future addSameDate(String date, int type, double weight, int deposit) async {
    final db = await provider.db;
    await db.execute(
        'UPDATE orders SET weight = weight + ?, deposit = deposit + ? WHERE date = ? AND type = ?',
        [weight, deposit, date, type]);
  }

  Future deleteOrder(OrderEntity order) async {
    final db = await provider.db;
    await db.delete('orders',
        where: 'date = ? AND type = ?', whereArgs: [order.date, order.type]);
  }

  Future updateOrder(String prevDate, int type, String date, int price,
      double weight, int deposit) async {
    final db = await provider.db;
    await db.execute(
        'UPDATE orders SET date = ?, price = ?, weight = ?, deposit = ?  WHERE date = ? AND type = ?',
        [date, price, weight, deposit, prevDate, type]);
  }
}
