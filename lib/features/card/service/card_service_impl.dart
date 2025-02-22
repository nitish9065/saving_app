import 'package:hive_flutter/hive_flutter.dart';
import 'package:saving/core/exceptions/api_exception.dart';
import 'package:saving/core/exceptions/app_exception.dart';
import 'package:saving/core/models/bank_card.dart';
import 'package:saving/core/models/transaction.dart';
import 'package:saving/core/services/card_service.dart';

class CardServiceImpl implements CardService {
  final Box<BankCard> cardBox;
  final Box<Transaction> transactionBox;

  CardServiceImpl(this.cardBox, this.transactionBox);
  @override
  Future<bool> addBalance(
      {required int cardId,
      required double addOn,
      required String name}) async {
    try {
      var card = cardBox.get(cardId);
      if (card == null) {
        throw AppException(message: 'Card not found with given Id');
      }
      var balance = card.balance;
      balance = balance + addOn;
      card = card.copyWith(balance: balance);
      await cardBox.put(cardId, card);
      await createTransaction(
        name: name,
        amount: addOn,
        cardId: cardId,
        addOn: true,
      );
      return true;
    } catch (e) {
      throw ApiExcepion.onError(e);
    }
  }

  @override
  Future<bool> createCard(
      {required String cardName,
      required String number,
      required double balance}) async {
    try {
      final exists = cardBox.values.any(
        (element) => element.number == number,
      );
      if (exists) {
        throw AppException(message: 'Card already exist with same number');
      }
      final key = cardBox.length + 1;
      final card = BankCard(
        id: key,
        name: cardName,
        number: number,
        balance: balance,
      );
      await cardBox.put(key, card);
      return true;
    } catch (e) {
      throw ApiExcepion.onError(e);
    }
  }

  @override
  Future<bool> deleteCard({required int cardId}) async {
    try {
      var card = cardBox.get(cardId);
      if (card == null) {
        throw AppException(message: 'Card not found with given Id');
      }
      await cardBox.delete(cardId);
      return true;
    } catch (e) {
      throw ApiExcepion.onError(e);
    }
  }

  @override
  Future<bool> withdrawBalance(
      {required int cardId,
      required double amount,
      required String name}) async {
    try {
      var card = cardBox.get(cardId);
      if (card == null) {
        throw AppException(message: 'Card not found with given Id');
      }
      var balance = card.balance;
      if (amount > balance) {
        throw AppException(
            message: 'Withdrawal balance is greater than current balance!');
      }
      balance = balance - amount;
      card = card.copyWith(balance: balance);
      await cardBox.put(cardId, card);
      await createTransaction(
        name: name,
        amount: amount,
        cardId: cardId,
        addOn: false,
      );
      return true;
    } catch (e) {
      throw ApiExcepion.onError(e);
    }
  }

  @override
  Future<List<BankCard>> fetchCards() async {
    try {
      final keys = cardBox.keys;
      if (keys.isEmpty) {
        return <BankCard>[];
      }
      var values =
          cardBox.valuesBetween(startKey: keys.first, endKey: keys.last);
      return values.toList();
    } catch (e) {
      throw ApiExcepion.onError(e);
    }
  }

  @override
  Future<BankCard?> getCard({required int cardId}) async {
    try {
      final exists = cardBox.containsKey(cardId);
      if (!exists) {
        return null;
      }
      return cardBox.get(cardId);
    } catch (e) {
      throw ApiExcepion.onError(e);
    }
  }

  @override
  Future<int> createTransaction({
    required String name,
    required double amount,
    required int cardId,
    required bool addOn,
  }) async {
    try {
      int key = transactionBox.length + 1;
      var transaction = Transaction(
        id: key,
        name: name,
        cardId: cardId,
        amount: amount,
        addOn: addOn,
        createdAt: DateTime.now().toLocal(),
      );
      await transactionBox.put(key, transaction);
      return key;
    } catch (e) {
      throw ApiExcepion.onError(e);
    }
  }

  @override
  Future<List<Transaction>> fetchAllTransaction({int? cardId}) async {
    try {
      final keys = transactionBox.keys;
      if (keys.isEmpty) {
        return <Transaction>[];
      }
      var values =
          transactionBox.valuesBetween(startKey: keys.first, endKey: keys.last);
      if (cardId != null) {
        values = values.where(
          (element) => element.cardId == cardId,
        );
      }
      return values.toList()
        ..sort(
          (a, b) => b.createdAt.compareTo(a.createdAt),
        );
    } catch (e) {
      throw ApiExcepion.onError(e);
    }
  }
}
