import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saving/core/extensions/context_extension.dart';
import 'package:saving/core/models/bank_card.dart';
import 'package:saving/core/providers/auth_state_provider.dart';
import 'package:saving/core/providers/loader.dart';
import 'package:saving/core/state/auth_state.dart';
import 'package:saving/core/theme/app_color.dart';
import 'package:saving/core/widgets/app_constrained_scroll_view.dart';
import 'package:saving/core/widgets/app_scaffold.dart';
import 'package:saving/core/widgets/app_textfield.dart';
import 'package:saving/features/card/providers/card_service_provider.dart';
import 'package:saving/features/card/widgets/create_card_sheet.dart';
import 'package:saving/features/home/providers/active_balance_provider.dart';

class AddMoneyPage extends ConsumerStatefulWidget {
  const AddMoneyPage({super.key});

  static String get route => '/add-money';

  @override
  ConsumerState<AddMoneyPage> createState() => _AddMoneyPageState();
}

class _AddMoneyPageState extends ConsumerState<AddMoneyPage> {
  late final TextEditingController textEditingController;
  String optionSelected = 'no';
  BankCard? firstCard;
  BankCard? secondCard;

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
      releaseFocus: true,
      appBar: AppBar(
        title: const Text('Add Money'),
      ),
      body: AppConstrainedScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8.0,
          children: [
            _title('Annual Savings'),
            AppTextfield(
              controller: textEditingController,
              hintText: 'Enter amount',
              keyboardType: TextInputType.number,
            ),
            _title('Do You want to split?'),
            Row(
              spacing: 16.0,
              children: [
                ChoiceChip(
                  label: const Text('Yes'),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        optionSelected = 'yes';
                        firstCard = null;
                        secondCard = null;
                      });
                    }
                  },
                  selected: optionSelected == 'yes',
                ),
                ChoiceChip(
                  label: const Text('No'),
                  selected: optionSelected == 'no',
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        optionSelected = 'no';
                        firstCard = null;
                        secondCard = null;
                      });
                    }
                  },
                ),
              ],
            ),
            optionSelected == 'yes'
                ? ref.watch(cardListingProvider).whenData(
                      (cards) {
                        if (cards.isEmpty || cards.length == 1) {
                          return Column(
                            spacing: 8.0,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _title(
                                cards.isEmpty
                                    ? 'No cards found to split saving'
                                    : 'Needs atleast two cards to split',
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: cards.isEmpty
                                        ? () async {
                                            await createCardSheet(
                                                context: context);
                                          }
                                        : null,
                                    child: const Text('Create first'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await createCardSheet(context: context);
                                    },
                                    child: const Text('Create second'),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }
                        return Column(
                          spacing: 8.0,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _title('Select Cards to split :'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (firstCard != null) ...[
                                  _chip(firstCard!.name)
                                ],
                                if (secondCard != null) ...[
                                  const Icon(Icons.compare_arrows),
                                  _chip(secondCard!.name)
                                ],
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CardsMenuWidget(
                                  cards: cards,
                                  title: 'Select First Card',
                                  onTap: (id) {
                                    setState(() {
                                      firstCard = id;
                                    });
                                    log('now the first cardId is $firstCard');
                                  },
                                ),
                                CardsMenuWidget(
                                  cards: cards,
                                  title: 'Select Second Card',
                                  onTap: (id) {
                                    setState(() {
                                      secondCard = id;
                                    });
                                    log('now the first cardId is $secondCard');
                                  },
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ).value ??
                    const SizedBox.shrink()
                : ref.watch(cardListingProvider).whenData(
                      (data) {
                        if (data.isEmpty) {
                          return Column(
                            spacing: 8.0,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _title(
                                'No cards found!',
                              ),
                              TextButton(
                                onPressed: () async {
                                  await createCardSheet(context: context);
                                },
                                child: const Text('Create One'),
                              ),
                            ],
                          );
                        }
                        return Column(
                          spacing: 8.0,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _title('Select card to enter saving into :'),
                            if (firstCard != null) ...[_chip(firstCard!.name)],
                            CardsMenuWidget(
                              cards: data,
                              title: 'Select Card',
                              onTap: (card) {
                                setState(
                                  () {
                                    firstCard = card;
                                  },
                                );
                              },
                            )
                          ],
                        );
                      },
                    ).valueOrNull ??
                    Container(),
          ],
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () async {
          if (textEditingController.text.trim().isEmpty) {
            context.showSnackBar('Amount can not be empty!');
            return;
          }
          final amount =
              double.tryParse(textEditingController.text.trim() ?? '0.0') ??
                  0.0;
          if (!(amount > 0.0)) {
            context.showSnackBar('Amount must be greater than 0');
            return;
          }
          if (optionSelected == 'no') {
            if (firstCard == null) {
              context
                  .showSnackBar('Create/Select a card first to enter savings!');
              return;
            }
            await addSaving(amount, firstCard!.id);
            context.pop();
          } else {
            if (firstCard == null || secondCard == null) {
              context.showSnackBar(
                  'Must create/select two cards to split savings!');
              return;
            }
            final halfBalance = amount / 2;
            await addSaving(halfBalance, firstCard!.id);
            await addSaving(amount - halfBalance, secondCard!.id);
            context.pop();
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
          height: 60,
          decoration: BoxDecoration(
            color: AppColor.primaryFaded,
          ),
          child: Center(
              child: Text(
            'Save',
            style: context.textTheme.bodyLarge
                ?.copyWith(color: AppColor.whiteColor, fontSize: 24.0),
          )),
        ),
      ),
    );
  }

  Future<void> addSaving(double amount, int cardId) async {
    ref.read(loaderProvider.notifier).showLoader();
    await ref
        .read(cardServiceProvider)
        .addBalance(
          cardId: cardId,
          addOn: amount,
          name: (ref.read(authStateProvider) as AuthStateSuccess).user.name,
        )
        .then(
      (value) {
        context.showSnackBar(
            value ? 'Saving added successfully!' : 'Failed to add savimgs');
        if (value) {
          ref.invalidate(cardListingProvider);
          ref.invalidate(transactionListingProvider);
          ref.read(activeBalanceProvider.notifier).refresh();
        }
      },
    ).catchError((e) {
      context.showSnackBar(
        e.toString(),
      );
    }).whenComplete(() {
      ref.read(loaderProvider.notifier).hideLoader();
    });
  }

  Widget _title(String text) => Text(
        text,
        style: context.textTheme.bodyLarge,
      );
  Widget _chip(String text) => Chip(
        label: Text(text),
        backgroundColor: AppColor.primaryFaded,
        labelStyle: const TextStyle(color: AppColor.whiteColor),
      );
}

class CardsMenuWidget extends StatelessWidget {
  const CardsMenuWidget(
      {super.key,
      required this.cards,
      required this.title,
      required this.onTap});
  final List<BankCard> cards;
  final String title;
  final Function(BankCard card) onTap;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        ...cards.map(
          (e) {
            return PopupMenuItem<BankCard>(
              value: e,
              onTap: () {
                onTap.call(e);
              },
              child: Text('${e.name} (${e.number})'),
            );
          },
        )
      ],
      child: ColoredBox(
        color: AppColor.grey.withValues(alpha: 0.2),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 4.0,
            children: [Text(title), const Icon(Icons.more_vert)],
          ),
        ),
      ),
    );
  }
}
