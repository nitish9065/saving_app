import 'package:flutter/material.dart';
import 'package:saving/core/extensions/context_extension.dart';
import 'package:saving/core/extensions/num_extension.dart';
import 'package:saving/core/models/bank_card.dart';
import 'package:saving/core/theme/app_color.dart';

class BankCardWidget extends StatelessWidget {
  const BankCardWidget({super.key, required this.card});
  final BankCard card;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 207,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/black-card.png'),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 75.0,
            left: 50.0,
            child: Text(
              card.name,
              style: context.textTheme.headlineMedium
                  ?.copyWith(color: AppColor.whiteColor, letterSpacing: .5),
            ),
          ),
          Positioned(
            bottom: 60,
            left: 50.0,
            right: 50.0,
            child: Text(
              card.number,
              style: context.textTheme.bodyLarge?.copyWith(
                color: AppColor.whiteColor,
                letterSpacing: 5.0,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 50.0,
            right: 50.0,
            child: Text(
              'Rs. ${card.balance.toCommaSeparated()}',
              style: context.textTheme.bodyLarge?.copyWith(
                color: AppColor.whiteColor,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
