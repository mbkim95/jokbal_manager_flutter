import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:jokbal_manager/model/order.dart';
import 'package:jokbal_manager/model/order_entity.dart';
import 'package:jokbal_manager/util.dart';

final formatter = DateFormat('yyyy-MM-dd');

class AddOrderDialog extends StatefulWidget {
  const AddOrderDialog({Key? key}) : super(key: key);

  @override
  _AddOrderDialogState createState() => _AddOrderDialogState();
}

class _AddOrderDialogState extends State<AddOrderDialog> {
  late String date = formatter.format(DateTime.now());
  final double fontSize = 18;

  LegType? _selectedLeg = LegType.front;
  var _totalPrice = 0;
  var _diffPrice = 0;
  final _weightController = TextEditingController();
  final _priceController = TextEditingController();
  final _depositController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _weightController.addListener(() {
      int price = _priceController.toInt();
      double weight = _weightController.toDouble();
      int deposit = _depositController.toInt();
      setState(() {
        _totalPrice = (price * weight).toInt();
        _diffPrice = _totalPrice - deposit;
      });
    });

    _priceController.addListener(() {
      int price = _priceController.toInt();
      double weight = _weightController.toDouble();
      int deposit = _depositController.toInt();
      setState(() {
        _totalPrice = (price * weight).toInt();
        _diffPrice = _totalPrice - deposit;
      });
    });

    _depositController.addListener(() {
      int deposit = _depositController.toInt();
      setState(() {
        _diffPrice = _totalPrice - deposit;
      });
    });
  }

  @override
  void dispose() {
    _weightController.dispose();
    _priceController.dispose();
    _depositController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.8;

    return AlertDialog(
      titlePadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.all(0),
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        width: width,
        color: Theme.of(context).primaryColor,
        child: const Text(
          '추가하기',
          style: TextStyle(color: Colors.white, fontSize: 28),
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        _renderDialogButton(
            title: '취소',
            onPressed: () {
              Navigator.of(context).pop();
            }),
        _renderDialogButton(
            title: '추가',
            onPressed: () {
              Navigator.of(context).pop(OrderEntity(
                date: date,
                type: _selectedLeg!.toInt(),
                price: _priceController.toInt(),
                weight: _weightController.toDouble(),
                deposit: _depositController.toInt(),
              ));
            }),
      ],
      content: SizedBox(
        width: width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _renderRadioButton(
                      label: '앞발',
                      value: LegType.front,
                      groupValue: _selectedLeg,
                      onChanged: (LegType? value) {
                        setState(() {
                          _selectedLeg = value;
                        });
                      }),
                  _renderRadioButton(
                      label: '뒷발',
                      value: LegType.back,
                      groupValue: _selectedLeg,
                      onChanged: (LegType? value) {
                        setState(() {
                          _selectedLeg = value;
                        });
                      }),
                  _renderRadioButton(
                      label: '혼합',
                      value: LegType.mix,
                      groupValue: _selectedLeg,
                      onChanged: (LegType? value) {
                        setState(() {
                          _selectedLeg = value;
                        });
                      }),
                ],
              ),
              _renderDateList(label: '날짜'),
              _renderListTile(
                  label: '중량',
                  unit: 'kg',
                  isInt: false,
                  controller: _weightController),
              _renderListTile(
                  label: '단가', unit: '원/kg', controller: _priceController),
              _renderListTile(
                  label: '금액',
                  unit: '원',
                  canEdit: false,
                  initValue: _totalPrice),
              _renderListTile(
                  label: '입금', unit: '원', controller: _depositController),
              _renderListTile(
                  label: '차액',
                  unit: '원',
                  canEdit: false,
                  initValue: _diffPrice),
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderDialogButton(
      {required String title, Color? color, required VoidCallback onPressed}) {
    return SizedBox(
        width: 100,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: color),
            onPressed: onPressed,
            child: Text(title)));
  }

  Widget _renderRadioButton<T>(
      {required String label,
      required T value,
      required T? groupValue,
      required ValueChanged<T?> onChanged}) {
    return GestureDetector(
      onTap: () {
        onChanged(value);
      },
      child: Row(
        children: [
          Radio(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 18),
          )
        ],
      ),
    );
  }

  Widget _renderListTile(
      {required String label,
      String? unit,
      TextEditingController? controller,
      bool canEdit = true,
      bool isInt = true,
      int initValue = 0}) {
    if (canEdit && controller == null) {
      throw ('The value of canEdit is true, then controller must not be null!');
    }

    var formatters = isInt
        ? [
            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
          ]
        : [FilteringTextInputFormatter.allow(RegExp(r"[0-9.]"))];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(fontSize: fontSize),
            ),
            const SizedBox(
              width: 40,
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: canEdit
                        ? TextField(
                            controller: controller,
                            textAlign: TextAlign.end,
                            keyboardType: TextInputType.number,
                            inputFormatters: formatters,
                            style: TextStyle(fontSize: fontSize),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                              border: OutlineInputBorder(),
                            ),
                          )
                        : Text(initValue.toString(),
                            textAlign: TextAlign.end,
                            style: TextStyle(fontSize: fontSize)),
                  ),
                  unit == null
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            unit,
                            style: TextStyle(fontSize: fontSize),
                          ),
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _renderDateList({required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(fontSize: fontSize),
            ),
            const SizedBox(
              width: 40,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  var pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2015),
                      lastDate: DateTime(2099));
                  setState(() {
                    date = formatter.format(pickedDate!);
                  });
                },
                child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black38),
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                  ),
                  child: Text(
                    date,
                    style: TextStyle(fontSize: fontSize),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
