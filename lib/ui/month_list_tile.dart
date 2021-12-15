import 'package:flutter/material.dart';
import 'package:jokbal_manager/model/order.dart';

class MonthListTile extends StatelessWidget {
  final String date;
  final MonthOrder orders;

  const MonthListTile({required this.date, required this.orders, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _renderMonthText(date, orders.weight, orders.price, orders.balance);
  }

  Widget _renderMonthText(String title, double weight, int price, int balance) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          SizedBox(
              width: 80,
              child: Text(
                title,
                textAlign: TextAlign.center,
              )),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('${weight}kg'),
                Text('$price원'),
                Text('$balance원'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
