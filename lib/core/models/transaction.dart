import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

@freezed
@HiveType(typeId: 2, adapterName: 'transactions')
class Transaction with _$Transaction {
  const factory Transaction({
    @HiveField(0) required int id,
    @HiveField(1) required String name,
    @HiveField(2) required int cardId,
    @HiveField(3) required double amount,
    @HiveField(4) required bool addOn,
    @HiveField(5) required DateTime createdAt,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
}
