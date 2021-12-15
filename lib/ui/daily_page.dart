import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jokbal_manager/bloc/month/month_order_bloc.dart';
import 'package:jokbal_manager/bloc/month/month_order_event.dart';
import 'package:jokbal_manager/bloc/month/month_order_state.dart';
import 'package:jokbal_manager/model/order.dart';
import 'package:jokbal_manager/ui/daily_list_tile.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class DailyPage extends StatefulWidget {
  const DailyPage({Key? key}) : super(key: key);

  @override
  _DailyPageState createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<MonthOrderBloc, MonthOrderState>(
          builder: (context, state) {
            if (state is LoadingState || state is ErrorState) {
              return _renderMaterialWidget(context, "", 0.0, 0, 0);
            }
            String date =
                "${(state as LoadedState).year}-${state.month < 10 ? '0${state.month}' : state.month}";
            return _renderMaterialWidget(context, date, state.totalWeight,
                state.totalPrice, state.totalBalance);
          },
        ),
        Expanded(
          child: BlocBuilder<MonthOrderBloc, MonthOrderState>(
              builder: (BuildContext context, state) {
            if (state is LoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ErrorState) {
              return const Center(child: Text("Error"));
            }
            return _renderList((state as LoadedState).orders);
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
                      BlocProvider.of<MonthOrderBloc>(context)
                          .add(PrevMonthEvent());
                    },
                  ),
                  ElevatedButton(
                    child: SizedBox(
                      width: 92,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(date),
                      ),
                    ),
                    onPressed: () async {
                      var _pickedMonth = await showMonthPicker(
                          context: context,
                          initialDate: DateTime.parse("$date-01"));
                      if (_pickedMonth != null) {
                        BlocProvider.of<MonthOrderBloc>(context).add(
                            ChangeMonthEvent(
                                year: _pickedMonth.year,
                                month: _pickedMonth.month));
                      }
                    },
                  ),
                  ElevatedButton(
                    child: const Icon(Icons.arrow_right),
                    onPressed: () {
                      BlocProvider.of<MonthOrderBloc>(context)
                          .add(NextMonthEvent());
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

  ListView _renderList(List<DayOrder> orders) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return Container(
          padding: index == 0
              ? const EdgeInsets.only(top: 16)
              : index == orders.length - 1
                  ? const EdgeInsets.only(bottom: 80)
                  : const EdgeInsets.all(0),
          child: DailyListTile(
            index: index,
            maxDay: orders.length,
            order: orders[index],
            updateCallback: (order) {
              var prevOrder = orders[index];
              BlocProvider.of<MonthOrderBloc>(context).add(
                  UpdateOrderEvent(prevDate: prevOrder.date, order: order));
            },
            removeCallback: (order) async {
              BlocProvider.of<MonthOrderBloc>(context)
                  .add(DeleteDayOrderEvent(order: order));
            },
          ),
        );
      },
      separatorBuilder: (context, index) =>
          const Divider(color: Colors.black38),
      itemCount: orders.length,
    );
  }
}
