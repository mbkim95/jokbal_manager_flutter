class OrderEntity {
  String date;
  int type;
  int price;
  double weight;
  int deposit;

  OrderEntity(
      {required this.date,
      required this.type,
      required this.price,
      required this.weight,
      required this.deposit});
}
