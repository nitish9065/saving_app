import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:saving/core/models/bank_card.dart';
import 'package:saving/core/models/transaction.dart';
import 'package:saving/core/services/card_service.dart';
import 'package:saving/features/card/service/card_service_impl.dart';

final cardServiceProvider = Provider<CardService>(
  (ref) {
    return CardServiceImpl(
      Hive.box<BankCard>('cards'),
      Hive.box<Transaction>('transactions'),
    );
  },
);

final cardListingProvider = FutureProvider<List<BankCard>>(
  (ref) async {
    final repo = ref.read(cardServiceProvider);
    return repo.fetchCards();
  },
);

final transactionListingProvider =
    FutureProvider.family<List<Transaction>, int?>(
  (ref, int? cardId) async {
    final repo = ref.read(cardServiceProvider);
    return repo.fetchAllTransaction(cardId: cardId);
  },
);

final cardDetailProvider = FutureProvider.family<BankCard?, int>(
  (ref, int cardId) async {
    final repo = ref.read(cardServiceProvider);
    return repo.getCard(cardId: cardId);
  },
);
