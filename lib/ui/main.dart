import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jokbal_manager/model/order_entity.dart';
import 'package:jokbal_manager/ui/add_order_dialog.dart';

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
        Container(
          child: Column(
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
                              onPressed: () {},
                            ),
                            ElevatedButton(
                              child: Text('2021-11-26'),
                              onPressed: () {},
                            ),
                            ElevatedButton(
                              child: const Icon(Icons.arrow_right),
                              onPressed: () {},
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
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: index == 0
                          ? const EdgeInsets.only(
                              top: 16, bottom: 4, left: 8, right: 8)
                          : index == 30
                              ? const EdgeInsets.only(
                                  top: 4, bottom: 64, left: 8, right: 8)
                              : const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                      child: Text('2021-11-${index + 1}'),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const Divider(color: Colors.black38),
                  itemCount: 31,
                ),
              ),
            ],
          ),
        ),
        Container()
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
}
