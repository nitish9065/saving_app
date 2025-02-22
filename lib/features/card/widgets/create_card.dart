import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saving/core/extensions/context_extension.dart';
import 'package:saving/core/providers/loader.dart';
import 'package:saving/core/theme/app_color.dart';
import 'package:saving/core/utils/card_number.dart';
import 'package:saving/core/widgets/whitish_text_button.dart';
import 'package:saving/features/card/providers/card_service_provider.dart';

import 'card_input_field.dart';

class CreateCard extends ConsumerStatefulWidget {
  const CreateCard({super.key, this.onSuccess, this.showLabel = true});
  final VoidCallback? onSuccess;
  final bool showLabel;

  @override
  ConsumerState<CreateCard> createState() => _CreateCardState();
}

class _CreateCardState extends ConsumerState<CreateCard> {
  late final TextEditingController inputController;
  String cardNumber = '';

  @override
  void initState() {
    super.initState();
    inputController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8.0,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showLabel) ...[
          Text(
            'No Card Found, Create one!',
            style: context.textTheme.bodyLarge?.copyWith(
              color: AppColor.redColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
        Container(
          height: 207,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/black-card.png',
              ),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 56.0,
                left: 50.0,
                child: SizedBox(
                  width: context.width / 2,
                  child: CardInputField(
                    controller: inputController,
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 50.0,
                right: 50.0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Card Number',
                          style: context.textTheme.bodyLarge?.copyWith(
                            color: AppColor.whiteColor.withValues(alpha: 0.5),
                          ),
                        ),
                        WhitishTextButton(
                          text: cardNumber.isEmpty ? 'Generate' : 'Regenerate',
                          onTap: () {
                            setState(() {
                              cardNumber = generateCreditCardNumber();
                            });
                          },
                        )
                      ],
                    ),
                    Text(
                      cardNumber,
                      style: context.textTheme.headlineSmall?.copyWith(
                          color: AppColor.whiteColor, letterSpacing: 2.5),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        ElevatedButton.icon(
          onPressed: inputController.text.isNotEmpty && cardNumber.isNotEmpty
              ? () async {
                  ref.read(loaderProvider.notifier).showLoader();
                  await Future.delayed(const Duration(seconds: 2));
                  ref
                      .read(cardServiceProvider)
                      .createCard(
                        cardName: inputController.text.trim(),
                        number: cardNumber,
                        balance: 0.0,
                      )
                      .then(
                    (value) {
                      context.showSnackBar(value
                          ? 'Card created successfully!'
                          : 'Failed to create card!');
                      if (value) {
                        ref.invalidate(cardListingProvider);
                        widget.onSuccess?.call();
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
              : null,
          label: const Text('Create'),
          icon: const Icon(
            Icons.add,
            color: AppColor.whiteColor,
          ),
        )
      ],
    );
  }
}
