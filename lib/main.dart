import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:jokbal_manager/bloc/month_order_bloc.dart';
import 'package:jokbal_manager/bloc/month_order_event.dart';
import 'package:jokbal_manager/model/order_entity.dart';
import 'package:jokbal_manager/repository/order_repository.dart';
import 'package:jokbal_manager/ui/add_order_dialog.dart';
import 'package:jokbal_manager/ui/daily_page.dart';
import 'package:jokbal_manager/ui/total_page.dart';

final formatter = DateFormat('yyyy-MM');

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MonthOrderBloc(OrderRepository()),
      child: MaterialApp(
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
          ]),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  var _index = 0;
  final OrderRepository repository = OrderRepository();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController!.addListener(() {
      setState(() {
        _index = _tabController!.index;
      });
    });
    BlocProvider.of<MonthOrderBloc>(context).add(LoadDayOrderListEvent());
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
        const DailyPage(),
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
                  BlocProvider.of<MonthOrderBloc>(context)
                      .add(CreateDayOrderEvent(order: order));
                }
              },
              tooltip: '등록하기',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
