import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:jokbal_manager/model/order_entity.dart';
import 'package:jokbal_manager/ui/add_order_dialog.dart';
import 'package:jokbal_manager/ui/daily_list_tile.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

final formatter = DateFormat('yyyy-MM');

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
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ko', 'KR'),
        ]);
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  var _index = 0;
  var formatter = DateFormat('yyyy-MM');
  late var month = formatter.format(DateTime.now());
  late var maxDay = DateTime(DateTime.parse('$month-01').year,
          DateTime.parse('$month-01').month + 1, 0)
      .day;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _index = _tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Padding(
              padding: EdgeInsets.all(8),
              child: Text('일별 보기', style: TextStyle(fontSize: 18)),
            ),
            Padding(
                padding: EdgeInsets.all(8),
                child: Text('합계 보기', style: TextStyle(fontSize: 18)))
          ],
        ),
      ),
      body: TabBarView(controller: _tabController, children: [
        Column(
          children: [
            Material(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            child: const Icon(Icons.arrow_left),
                            onPressed: () {
                              var now = DateTime.parse("$month-01");
                              setState(() {
                                maxDay = DateTime(now.year, now.month, 0).day;
                                month = formatter
                                    .format(DateTime(now.year, now.month - 1));
                              });
                            },
                          ),
                          ElevatedButton(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(month),
                            ),
                            onPressed: () async {
                              var _pickedMonth = await showMonthPicker(
                                  context: context,
                                  initialDate: DateTime.parse('$month-01'));
                              setState(() {
                                maxDay = DateTime(_pickedMonth!.year,
                                        _pickedMonth.month + 1, 0)
                                    .day;
                                month = formatter.format(_pickedMonth);
                              });
                            },
                          ),
                          ElevatedButton(
                            child: const Icon(Icons.arrow_right),
                            onPressed: () {
                              var now = DateTime.parse("$month-01");
                              setState(() {
                                maxDay =
                                    DateTime(now.year, now.month + 2, 0).day;
                                month = formatter
                                    .format(DateTime(now.year, now.month + 1));
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          '합계',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text('중량'),
                        Text('금액'),
                        Text('잔고')
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 40,
                        ),
                        Text('0.0kg'),
                        Text('0원'),
                        Text('0원')
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: _renderList(),
            ),
          ],
        ),
        Container(
          color: Colors.grey,
        )
      ]),
      floatingActionButton: _index == 0
          ? FloatingActionButton(
              onPressed: () async {
                const dialog = AddOrderDialog();
                OrderEntity order = await showDialog(
                    context: context, builder: (context) => dialog);
                // TODO: DB에 저장
              },
              tooltip: '등록하기',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  ListView _renderList() {
    return ListView.separated(
      itemBuilder: (context, index) {
        return DailyListTile(index: index, month: month, maxDay: maxDay);
      },
      separatorBuilder: (context, index) =>
          const Divider(color: Colors.black38),
      itemCount: maxDay,
    );
  }
}
