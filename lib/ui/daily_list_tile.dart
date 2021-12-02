import 'package:flutter/material.dart';
import 'package:jokbal_manager/model/order.dart';

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
      totalBalance += e.deposit;
      if (e.type == LegType.front) {
        isFront = true;
        prices[0] += e.price;
        weights[0] += e.weight;
        balances[0] += e.deposit;
      } else if (e.type == LegType.back) {
        isBack = true;
        prices[1] += e.price;
        weights[1] += e.weight;
        balances[1] += e.deposit;
      } else {
        isMix = true;
        prices[2] += e.price;
        weights[2] += e.weight;
        balances[2] += e.deposit;
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
                    ? _renderDailyText('앞발', weights[0], prices[0], balances[0])
                    : Container(),
                isBack
                    ? _renderDailyText('뒷발', weights[1], prices[1], balances[1])
                    : Container(),
                isMix
                    ? _renderDailyText('혼합', weights[2], prices[2], balances[2])
                    : Container(),
              ],
            ),
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
