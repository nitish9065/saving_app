import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saving/core/extensions/context_extension.dart';
import 'package:saving/core/providers/auth_state_provider.dart';
import 'package:saving/core/providers/loader.dart';
import 'package:saving/core/state/auth_state.dart';
import 'package:saving/core/theme/app_color.dart';
import 'package:saving/core/widgets/app_constrained_scroll_view.dart';
import 'package:saving/core/widgets/app_scaffold.dart';
import 'package:saving/features/card/pages/card_page.dart';
import 'package:saving/features/card/providers/card_service_provider.dart';
import 'package:saving/features/card/widgets/bank_card_widget.dart';
import 'package:saving/features/card/widgets/input_dialog.dart';
import 'package:saving/features/home/pages/home_page.dart';
import 'package:saving/features/home/providers/active_balance_provider.dart';
import 'package:saving/features/home/widgets/transaction_listing.dart';

class CardDetail extends ConsumerStatefulWidget {
  const CardDetail(this.cardId, {super.key});
  final int cardId;

  static String route({int? id}) => '${CardPage.route}/${id ?? ':id'}';

  @override
  ConsumerState<CardDetail> createState() => _CardDetailState();
}

class _CardDetailState extends ConsumerState<CardDetail> {
  late final TextEditingController textEditingController;

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text('Card Detail'),
      ),
      body: AppConstrainedScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: ref.watch(cardDetailProvider(widget.cardId)).when(
              data: (data) {
                if (data == null) {
                  return Center(
                    child: Text(
                      'Card not found with givven Id',
                      style: context.textTheme.headlineMedium,
                    ),
                  );
                }
                return Column(
                  spacing: 16.0,
                  children: [
                    BankCardWidget(card: data),
                    const TitleNav(title: 'Operations'),
                    Row(
                      spacing: 16.0,
                      children: [
                        CardButton(
                          iconData: Icons.install_mobile_outlined,
                          subtitle: 'Add',
                          onTap: () async {
                            await doOperation(true, data.balance);
                          },
                          blackColor: true,
                        ),
                        CardButton(
                          iconData: Icons.send_to_mobile_outlined,
                          subtitle: 'Withdraw',
                          onTap: () async {
                            await doOperation(false, data.balance);
                          },
                          blackColor: true,
                        ),
                      ],
                    ),
                    const TitleNav(title: 'Transaction History'),
                    TransactionListing(
                      cardId: widget.cardId,
                      fullListing: true,
                    )
                  ],
                );
              },
              error: (error, stackTrace) => Center(
                child: Text(
                  error.toString(),
                ),
              ),
              loading: () => Center(
                child: CircularProgressIndicator(
                  color: AppColor.primary,
                ),
              ),
            ),
      ),
    );
  }

  Future<void> doOperation(bool addOn, double limit) async {
    textEditingController.clear();
    await showInputDialog(
      context: context,
      controller: textEditingController,
    );
    if (textEditingController.text.trim().isEmpty) {
      context.showSnackBar('Amount can not be empty!');
      return;
    }
    final amount = double.tryParse(textEditingController.text.trim()) ?? 0.0;
    if (!(amount > 0.0)) {
      context.showSnackBar('Amount must be greater than 0');
      return;
    }
    if (!addOn && amount > limit) {
      context.showSnackBar('Can not withdraw money greater than balance!');
      return;
    }
    ref.read(loaderProvider.notifier).showLoader();
    await Future.delayed(const Duration(seconds: 2));
    late Future<bool> operation;
    if (addOn) {
      operation = ref.read(cardServiceProvider).addBalance(
            name: (ref.read(authStateProvider) as AuthStateSuccess).user.name,
            addOn: amount,
            cardId: widget.cardId,
          );
    } else {
      operation = ref.read(cardServiceProvider).withdrawBalance(
            name: (ref.read(authStateProvider) as AuthStateSuccess).user.name,
            amount: amount,
            cardId: widget.cardId,
          );
    }

    operation.then(
      (value) {
        context.showSnackBar('Transaction added!');
        ref.invalidate(cardDetailProvider(widget.cardId));
        ref.invalidate(transactionListingProvider(widget.cardId));
        ref.invalidate(activeBalanceProvider);
      },
    ).catchError((e) {
      context.showSnackBar(
        e.toString(),
      );
    }).whenComplete(() {
      ref.read(loaderProvider.notifier).hideLoader();
    });
  }
}
