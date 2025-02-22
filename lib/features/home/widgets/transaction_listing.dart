import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saving/core/extensions/context_extension.dart';
import 'package:saving/core/extensions/date_time_extension.dart';
import 'package:saving/core/extensions/num_extension.dart';
import 'package:saving/core/theme/app_color.dart';
import 'package:saving/features/card/providers/card_service_provider.dart';
import 'package:saving/features/home/pages/home_page.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TransactionListing extends ConsumerWidget {
  const TransactionListing({
    super.key,
    this.cardId,
    this.fullListing = false,
  });
  final int? cardId;
  final bool fullListing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(transactionListingProvider(cardId)).when(
          data: (transactions) {
            if (transactions.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: Center(
                  child: Text(
                    'No Transaction Found!',
                    style: context.textTheme.bodyLarge,
                  ),
                ),
              );
            }
            return fullListing
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...transactions.map(
                        (transaction) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            UserCard(
                              inOut: true,
                              title: transaction.name,
                              subtitle: transaction.createdAt.formatDate(),
                              trailing:
                                  '${transaction.addOn ? '+' : '-'} Rs ${transaction.amount.toCommaSeparated()}',
                            ),
                            const Divider(
                              color: AppColor.blackColorFaded,
                              thickness: .25,
                            )
                          ],
                        ),
                      )
                    ],
                  )
                : ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return UserCard(
                        inOut: true,
                        title: transaction.name,
                        subtitle: transaction.createdAt.formatDate(),
                        trailing:
                            '${transaction.addOn ? '+' : '-'} Rs ${transaction.amount.toCommaSeparated()}',
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(
                      color: AppColor.blackColorFaded,
                      thickness: .25,
                    ),
                    itemCount: transactions.take(4).length,
                  );
          },
          error: (error, stackTrace) => Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
            child: Text(
              error.toString(),
            ),
          ),
          loading: () => Skeletonizer(
            child: Column(
              children: [
                UserCard(
                  inOut: true,
                  title: 'Settlement',
                  subtitle: '12 Mar 2024',
                  trailing: '+ ${32123.toDouble().toCommaSeparated()}',
                  onTap: () {},
                ),
                const Divider(
                  color: AppColor.blackColorFaded,
                  thickness: .25,
                ),
                UserCard(
                  inOut: true,
                  title: 'Google Play',
                  subtitle: '12 April 2024',
                  trailing: 80000.toDouble().toCommaSeparated(),
                  onTap: () {},
                ),
                const Divider(
                  color: AppColor.blackColorFaded,
                  thickness: .25,
                ),
                UserCard(
                  inOut: true,
                  title: 'Nohan Putra',
                  subtitle: '12 May 2024',
                  trailing: '+ ${1500000.toDouble().toCommaSeparated()}',
                  onTap: () {},
                ),
              ],
            ),
          ),
        );
  }
}
