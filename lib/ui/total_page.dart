import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jokbal_manager/bloc/year/year_order_bloc.dart';
import 'package:jokbal_manager/bloc/year/year_order_event.dart';
import 'package:jokbal_manager/bloc/year/year_order_state.dart';
import 'package:jokbal_manager/model/order.dart';
import 'package:jokbal_manager/ui/month_list_tile.dart';

class TotalPage extends StatefulWidget {
  const TotalPage({Key? key}) : super(key: key);

  @override
  _TotalPageState createState() => _TotalPageState();
}

class _TotalPageState extends State<TotalPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<YearOrderBloc>(context).add(LoadMonthOrderListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<YearOrderBloc, YearOrderState>(
          builder: (context, state) {
            if (state is LoadingState || state is ErrorState) {
              return _renderMaterialWidget(context, "", 0.0, 0, 0);
            }
            String date = "${(state as LoadedState).year}";
            return _renderMaterialWidget(context, date, state.totalWeight,
                state.totalPrice, state.totalBalance);
          },
        ),
        Expanded(
          child: BlocBuilder<YearOrderBloc, YearOrderState>(
              builder: (BuildContext context, state) {
            if (state is LoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ErrorState) {
              return const Center(child: Text("Error"));
            }

            return _renderList((state as LoadedState).year, state.orders);
          }),
        ),
      ],
    );
  }

  Widget _renderMaterialWidget(BuildContext context, String date,
      double totalWeight, int totalPrice, int totalBalance) {
    return Material(
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
                      BlocProvider.of<YearOrderBloc>(context)
                          .add(PrevYearEvent());
                    },
                  ),
                  ElevatedButton(
                    child: SizedBox(
                      width: 92,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Center(child: Text(date)),
                      ),
                    ),
                    onPressed: () async {
                      var yearPicker = YearPicker(
                          firstDate: DateTime(2015),
                          lastDate: DateTime(2099),
                          selectedDate: DateTime.now(),
                          onChanged: (date) {
                            Navigator.of(context).pop(date);
                          });
                      DateTime pickedYear = await showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              content: SizedBox(
                                  width: 300, height: 450, child: yearPicker)));
                      print(pickedYear);
                      BlocProvider.of<YearOrderBloc>(context)
                          .add(ChangeYearEvent(year: pickedYear.year));
                    },
                  ),
                  ElevatedButton(
                    child: const Icon(Icons.arrow_right),
                    onPressed: () {
                      BlocProvider.of<YearOrderBloc>(context)
                          .add(NextYearEvent());
                    },
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Text('합계',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('중량'),
                Text('금액'),
                Text('잔고'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(width: 40),
                Text('${totalWeight}kg'),
                Text('$totalPrice원'),
                Text('$totalBalance원')
              ],
            )
          ],
        ),
      ),
    );
  }

  ListView _renderList(int year, List<MonthOrder> orders) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return Container(
          padding: index == 0
              ? const EdgeInsets.only(top: 16)
              : index == orders.length - 1
                  ? const EdgeInsets.only(bottom: 80)
                  : const EdgeInsets.all(0),
          child: MonthListTile(
            date: '$year-${index + 1 < 10 ? "0${index + 1}" : index + 1}',
            orders: orders[index],
          ),
        );
      },
      separatorBuilder: (context, index) =>
          const Divider(color: Colors.black38),
      itemCount: orders.length,
    );
  }
}
