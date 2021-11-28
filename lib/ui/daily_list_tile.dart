import 'package:flutter/material.dart';

class DailyListTile extends StatefulWidget {
  final int maxDay;
  final String month;
  final int index;

  const DailyListTile(
      {required this.index,
      required this.maxDay,
      required this.month,
      Key? key})
      : super(key: key);

  @override
  _DailyListTileState createState() => _DailyListTileState();
}

class _DailyListTileState extends State<DailyListTile> {
  bool _showChildLayout = false;

  @override
  Widget build(BuildContext context) {
    int index = widget.index;

    return GestureDetector(
        onTap: () {
          setState(() {
            _showChildLayout = !_showChildLayout;
          });
        },
        child: !_showChildLayout
            ? _renderDailyText(_getDateText(), 0.0, 0, 0)
            : Column(
                children: [
                  _renderDailyText(_getDateText(), 0.0, 0, 0),
                  _renderDailyText('앞발', 0.0, 0, 0),
                  _renderDailyText('뒷발', 0.0, 0, 0),
                  _renderDailyText('혼합', 0.0, 0, 0),
                ],
              ));
  }

  Widget _renderDailyText(String title, double weight, int price, int deposit) {
    int index = widget.index;
    return Padding(
      padding: index == 0
          ? const EdgeInsets.only(top: 16, bottom: 4, left: 8, right: 8)
          : index == widget.maxDay
              ? const EdgeInsets.only(top: 4, bottom: 64, left: 8, right: 8)
              : const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          Container(
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

  String _getDateText() {
    int index = widget.index;
    return index + 1 > 9
        ? '${widget.month}-${index + 1}'
        : '${widget.month}-0${index + 1}';
  }
}
