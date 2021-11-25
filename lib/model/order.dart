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
