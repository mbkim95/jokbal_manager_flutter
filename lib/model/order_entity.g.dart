// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderEntity _$OrderEntityFromJson(Map<String, dynamic> json) => OrderEntity(
      date: json['date'] as String,
      type: json['type'] as int,
      price: json['price'] as int,
      weight: (json['weight'] as num).toDouble(),
      deposit: json['deposit'] as int,
    );

Map<String, dynamic> _$OrderEntityToJson(OrderEntity instance) =>
    <String, dynamic>{
      'date': instance.date,
      'type': instance.type,
      'price': instance.price,
      'weight': instance.weight,
      'deposit': instance.deposit,
    };
