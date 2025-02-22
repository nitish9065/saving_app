import 'package:flutter/material.dart';
import 'package:saving/core/widgets/app_constrained_scroll_view.dart';
import 'package:saving/core/widgets/app_scaffold.dart';
import 'package:saving/features/home/widgets/transaction_listing.dart';

class TransactionListingPage extends StatelessWidget {
  const TransactionListingPage({super.key});

  static String get route => '/inOutListing';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text('In & Out'),
      ),
      body: const AppConstrainedScrollView(
        child: TransactionListing(
          cardId: null,
          fullListing: true,
        ),
      ),
    );
  }
}
