import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saving/core/models/bank_card.dart';

part 'active_balance_provider.g.dart';

@Riverpod(keepAlive: true)
class ActiveBalance extends _$ActiveBalance {
  @override
  double build() {
    _init();
    return 0.0;
  }

  void _init() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final cardBox = Hive.box<BankCard>('cards');
    final keys = cardBox.keys;
    if (keys.isEmpty) {
      state = 0.0;
      return;
    }
    final balance = cardBox
        .valuesBetween(startKey: keys.first, endKey: keys.last)
        .fold(0.0, (previousValue, element) => previousValue + element.balance);
    state = balance;
  }

  void refresh() {
    _init();
  }
}
