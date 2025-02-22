import 'package:saving/core/models/bank_card.dart';
import 'package:saving/core/models/transaction.dart';

abstract class CardService {
  Future<List<BankCard>> fetchCards();

  Future<bool> createCard({
    required String cardName,
    required String number,
    required double balance,
  });

  Future<bool> addBalance({
    required int cardId,
    required double addOn,
    required String name,
  });
  Future<bool> withdrawBalance({
    required int cardId,
    required double amount,
    required String name,
  });

  Future<bool> deleteCard({required int cardId});

  Future<BankCard?> getCard({required int cardId});

  Future<List<Transaction>> fetchAllTransaction({int? cardId});

  Future<int> createTransaction({
    required String name,
    required double amount,
    required int cardId,
    required bool addOn,
  });
}
