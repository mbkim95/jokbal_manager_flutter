import 'package:json_annotation/json_annotation.dart';

part 'order_entity.g.dart';

@JsonSerializable()
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

  factory OrderEntity.fromJson(Map<String, dynamic> json) =>
      _$OrderEntityFromJson(json);

  Map<String, dynamic> toJson() => _$OrderEntityToJson(this);
}
