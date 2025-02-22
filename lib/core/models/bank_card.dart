import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'bank_card.freezed.dart';
part 'bank_card.g.dart';

@freezed
@HiveType(typeId: 1, adapterName: 'cards')
class BankCard with _$BankCard {
  const factory BankCard({
    @HiveField(0) required int id,
    @HiveField(1) required String name,
    @HiveField(2) required String number,
    @HiveField(3) required double balance,
  }) = _BankCard;

  factory BankCard.fromJson(Map<String, dynamic> json) =>
      _$BankCardFromJson(json);
}
