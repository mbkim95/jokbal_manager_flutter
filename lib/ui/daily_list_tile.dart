import 'package:flutter/material.dart';
import 'package:jokbal_manager/model/order.dart';

import 'order_info_dialog.dart';

class DailyListTile extends StatefulWidget {
  final int maxDay;
  final int index;
  final DayOrder order;

  const DailyListTile(
      {required this.index,
      required this.maxDay,
      required this.order,
      Key? key})
      : super(key: key);

  @override
  _DailyListTileState createState() => _DailyListTileState();
}

class _DailyListTileState extends State<DailyListTile> {
  bool _showChildLayout = false;
  int totalPrice = 0;
  double totalWeight = 0.0;
  int totalBalance = 0;
  List<int> prices = [0, 0, 0];
  List<double> weights = [0.0, 0.0, 0.0];
  List<int> balances = [0, 0, 0];
  bool isFront = false;
  bool isBack = false;
  bool isMix = false;

  void _initialize() {
    totalPrice = 0;
    totalWeight = 0;
    totalBalance = 0;
    prices = [0, 0, 0];
    weights = [0, 0, 0];
    balances = [0, 0, 0];
    isFront = false;
    isBack = false;
    isMix = false;
  }

  void sumTotalValue(DayOrder order) {
    _initialize();
    for (var e in order.orders) {
      totalPrice += e.price;
      totalWeight += e.weight;
      totalBalance += (e.price * e.weight).toInt() - e.deposit;
      if (e.type == LegType.front) {
        isFront = true;
        prices[0] = e.price;
        weights[0] = e.weight;
        balances[0] = (e.price * e.weight).toInt() - e.deposit;
      } else if (e.type == LegType.back) {
        isBack = true;
        prices[1] = e.price;
        weights[1] = e.weight;
        balances[1] = (e.price * e.weight).toInt() - e.deposit;
      } else {
        isMix = true;
        prices[2] = e.price;
        weights[2] = e.weight;
        balances[2] = (e.price * e.weight).toInt() - e.deposit;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    sumTotalValue(order);
    return GestureDetector(
      onTap: () {
        setState(() {
          _showChildLayout = !_showChildLayout;
        });
      },
      child: !_showChildLayout
          ? _renderDailyText(order.date, totalWeight, totalPrice, totalBalance)
          : Column(
              children: [
                _renderDailyText(
                    order.date, totalWeight, totalPrice, totalBalance),
                isFront
                    ? GestureDetector(
                        child: _renderDailyText(
                            '앞발', weights[0], prices[0], balances[0]),
                        onTap: () {
                          var dialog = _renderOrderInfoDialog(order.date, 0);
                          showDialog(
                              context: context, builder: (context) => dialog);
                        },
                      )
                    : Container(),
                isBack
                    ? GestureDetector(
                        child: _renderDailyText(
                            '뒷발', weights[1], prices[1], balances[1]),
                        onTap: () {
                          var dialog = _renderOrderInfoDialog(order.date, 1);
                          showDialog(
                              context: context, builder: (context) => dialog);
                        },
                      )
                    : Container(),
                isMix
                    ? GestureDetector(
                        child: _renderDailyText(
                            '혼합', weights[2], prices[2], balances[2]),
                        onTap: () {
                          var dialog = _renderOrderInfoDialog(order.date, 2);
                          showDialog(
                              context: context, builder: (context) => dialog);
                        },
                      )
                    : Container(),
              ],
            ),
    );
  }

  OrderInfoDialog _renderOrderInfoDialog(String date, int index) {
    return OrderInfoDialog(
      type: index == 0
          ? LegType.front
          : index == 1
              ? LegType.back
              : LegType.mix,
      date: date,
      weight: weights[index],
      price: prices[index],
      deposit: (weights[index] * prices[index]).toInt() + balances[index],
      updateCallback: (order) {},
      removeCallback: (order) {},
    );
  }

  Widget _renderDailyText(String title, double weight, int price, int deposit) {
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
                Text('$deposit원'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
