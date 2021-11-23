import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jokbal Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: '세라 입고 관리'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  LegType? _selectedLeg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final dialog = _renderDialog();
          showDialog(context: context, builder: (context) => dialog);
        },
        tooltip: '등록하기',
        child: const Icon(Icons.add),
      ),
    );
  }

  // TODO: 키보드 누르면 overflow 발생
  // TODO: 금액, 차액 수정해야함
  Widget _renderDialog() {
    final queryData = MediaQuery.of(context);
    final width = queryData.size.width * 0.8;
    final height = queryData.size.height * 0.6;

    return Dialog(
      child: StatefulBuilder(builder: (context, setState) {
        return SizedBox(
          width: width,
          height: height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  width: width,
                  color: Theme.of(context).primaryColor,
                  child: const Text(
                    '추가하기',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                ),
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
                _renderListTile(label: '날짜'),
                _renderListTile(label: '중량', unit: 'kg'),
                _renderListTile(label: '단가', unit: '원/kg'),
                _renderListTile(label: '금액', unit: '원'),
                _renderListTile(label: '입금', unit: '원'),
                _renderListTile(label: '차액', unit: '원'),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                        width: 100,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('취소'))),
                    SizedBox(
                        width: 100,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('추가'))),
                  ],
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _renderRadioButton<T>(
      {required String label,
      required T value,
      required T? groupValue,
      required ValueChanged<T?>? onChanged}) {
    return Row(
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
    );
  }

  Widget _renderListTile({required String label, String? unit}) {
    double fontSize = 18;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Container(
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
                  const Expanded(
                      child: TextField(
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        border: OutlineInputBorder()),
                  )),
                  unit == null
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            unit,
                            style: TextStyle(fontSize: fontSize),
                          )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

enum LegType { front, back, mix }
