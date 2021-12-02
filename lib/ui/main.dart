import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:jokbal_manager/model/order.dart';
import 'package:jokbal_manager/model/order_entity.dart';
import 'package:jokbal_manager/repository/order_repository.dart';
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
        home: MyHomePage(title: '세라 입고 관리'),
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
  final String title;

  MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  var _index = 0;
  final OrderRepository repository = OrderRepository();
  late int year;
  late int month;
  int totalPrice = 0;
  double totalWeight = 0.0;
  int totalBalance = 0;
  List<DayOrder> monthOrder = [];

  Future _loadOrder(int year, int month) async {
    var list = await repository.getMonthOrders(year, month);
    setState(() {
      monthOrder = list;
    });
  }

  Row _renderTotalValue() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const SizedBox(width: 40),
        Text('${totalWeight}kg'),
        Text('$totalPrice원'),
        Text('$totalBalance원')
      ],
    );
  }

  ListView _renderList() {
    return ListView.separated(
      itemBuilder: (context, index) {
        return Container(
          padding: index == 0
              ? const EdgeInsets.only(top: 16)
              : index == monthOrder.length - 1
                  ? const EdgeInsets.only(bottom: 80)
                  : const EdgeInsets.all(0),
          child: DailyListTile(
              index: index,
              maxDay: monthOrder.length,
              order: monthOrder[index]),
        );
      },
      separatorBuilder: (context, index) =>
          const Divider(color: Colors.black38),
      itemCount: monthOrder.length,
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController!.addListener(() {
      setState(() {
        _index = _tabController!.index;
      });
    });
    var now = DateTime.now();
    year = now.year;
    month = now.month;
    _loadOrder(year, month);
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
                              if (year == 2015 && month == 1) {
                                return;
                              }
                              month--;
                              if (month == 0) {
                                month = 12;
                                year--;
                              }
                              _loadOrder(year, month);
                            },
                          ),
                          ElevatedButton(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                  '$year-${month < 10 ? "0$month" : "$month"}'),
                            ),
                            onPressed: () async {
                              var _pickedMonth = await showMonthPicker(
                                  context: context,
                                  initialDate: DateTime.parse(
                                      '${'$year-${month < 10 ? "0$month" : "$month"}'}-01'));
                              if (_pickedMonth != null) {
                                year = _pickedMonth.year;
                                month = _pickedMonth.month;
                                _loadOrder(year, month);
                              }
                            },
                          ),
                          ElevatedButton(
                            child: const Icon(Icons.arrow_right),
                            onPressed: () {
                              month++;
                              if (month == 13) {
                                month = 1;
                                year++;
                              }
                              _loadOrder(year, month);
                            },
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Text('합계',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('중량'),
                        Text('금액'),
                        Text('잔고'),
                      ],
                    ),
                    _renderTotalValue(),
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
                OrderEntity? order = await showDialog(
                    context: context, builder: (context) => dialog);
                if (order != null) {
                  await repository.insertOrder(order);
                  await _loadOrder(year, month);
                }
              },
              tooltip: '등록하기',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
