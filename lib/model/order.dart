enum LegType { front, back, mix }

class Order {
  LegType type;
  int price;
  double weight;
  int deposit;

  Order(
      {required this.type,
      required this.price,
      required this.weight,
      required this.deposit});
}

class DayOrder {
  String date;
  List<Order> orders;

  DayOrder(this.date, this.orders);
}

class MonthOrder {
  String month;
  int price;
  double weight;
  int balance;

  MonthOrder(this.month, this.price, this.weight, this.balance);
}
