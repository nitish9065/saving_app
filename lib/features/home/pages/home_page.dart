import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:saving/core/extensions/context_extension.dart';
import 'package:saving/core/extensions/num_extension.dart';
import 'package:saving/core/models/bank_card.dart';
import 'package:saving/core/models/transaction.dart';
import 'package:saving/core/providers/loader.dart';
import 'package:saving/core/theme/app_color.dart';
import 'package:saving/core/utils/strings.dart';
import 'package:saving/core/widgets/app_constrained_scroll_view.dart';
import 'package:saving/features/card/pages/card_detail.dart';
import 'package:saving/features/card/pages/card_page.dart';
import 'package:saving/features/card/providers/card_service_provider.dart';
import 'package:saving/features/card/widgets/create_card_sheet.dart';
import 'package:saving/features/home/pages/add_money_page.dart';
import 'package:saving/features/home/pages/transaction_listing_page.dart';
import 'package:saving/features/home/providers/active_balance_provider.dart';
import 'package:saving/features/home/widgets/transaction_listing.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({
    super.key,
  });

  static String get route => '/home';

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(cardListingProvider);
          ref.invalidate(transactionListingProvider(null));
          ref.invalidate(activeBalanceProvider);
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: SvgPicture.asset(
                'assets/images/logo-transparent.svg',
                width: 100,
              ),
              backgroundColor: AppColor.primary.withValues(alpha: 0.9),
              elevation: 5.0,
              pinned: true,
              centerTitle: false,
              expandedHeight: 224,
              actions: [
                IconButton(
                  onPressed: () async {
                    ref.read(loaderProvider.notifier).showLoader();
                    await Future.delayed(const Duration(seconds: 2));
                    await Hive.box<BankCard>('cards').clear();
                    await Hive.box<Transaction>('transactions').clear();
                    ref.read(loaderProvider.notifier).hideLoader();
                    ref.invalidate(cardListingProvider);
                    ref.invalidate(transactionListingProvider(null));
                    ref.invalidate(activeBalanceProvider);
                  },
                  iconSize: 28.0,
                  icon: const Icon(
                    Icons.delete,
                  ),
                )
              ],
              flexibleSpace: AppConstrainedScrollView(
                padding: const EdgeInsets.all(16.0)
                    .copyWith(top: kToolbarHeight * 1.5),
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Consumer(
                      builder: (context, ref, child) {
                        final balance = ref.watch(activeBalanceProvider);
                        return Text(
                          'Rs ${balance.toCommaSeparated()}',
                          style: context.textTheme.headlineSmall
                              ?.copyWith(color: AppColor.whiteColor),
                        );
                      },
                    ),
                    Text(
                      'Active Balance',
                      style: context.textTheme.bodySmall?.copyWith(
                          color: AppColor.whiteColor.withValues(alpha: 0.8)),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      spacing: 16.0,
                      children: [
                        CardButton(
                          iconData: Icons.install_mobile_outlined,
                          subtitle: 'Add',
                          onTap: () {
                            context.push(
                                '${MyHomePage.route}${AddMoneyPage.route}');
                          },
                        ),
                        CardButton(
                          iconData: Icons.send_to_mobile_outlined,
                          subtitle: 'Withdraw',
                          onTap: () {
                            context.go(CardPage.route);
                          },
                        ),
                        CardButton(
                          iconData: Icons.import_export_rounded,
                          subtitle: 'In & Out',
                          onTap: () {
                            context.push(
                                '${MyHomePage.route}${TransactionListingPage.route}');
                          },
                        ),
                        CardButton(
                          iconData: Icons.qr_code_2_outlined,
                          subtitle: 'QR Code',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Column(
                      spacing: 8.0,
                      children: [
                        TitleNav(
                          title: 'Card Center',
                          onTap: () {
                            context.go(CardPage.route);
                          },
                        ),
                        Card(
                          elevation: 0.5,
                          child: ref.watch(cardListingProvider).when(
                                data: (data) {
                                  if (data.isEmpty) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 32.0),
                                      child: Center(
                                        child: Column(
                                          spacing: 8.0,
                                          children: [
                                            const Text('No Card Found!'),
                                            TextButton(
                                              onPressed: () async {
                                                await createCardSheet(
                                                  context: context,
                                                );
                                              },
                                              child: const Text('Create one'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }

                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListView.separated(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return UserCard(
                                            title: data[index].name,
                                            subtitle:
                                                data[index].number.substring(4),
                                            trailing:
                                                'Rs ${data[index].balance.toCommaSeparated()}',
                                            onTap: () {
                                              context.push(CardDetail.route(
                                                  id: data[index].id));
                                            },
                                          );
                                        },
                                        separatorBuilder: (context, index) =>
                                            const Divider(
                                          color: AppColor.blackColorFaded,
                                          thickness: .25,
                                        ),
                                        itemCount: data.take(3).length,
                                      )
                                    ],
                                  );
                                },
                                error: (error, stackTrace) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 32.0),
                                  child: Center(
                                    child: Text(
                                      error.toString(),
                                    ),
                                  ),
                                ),
                                loading: () => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 32.0),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: AppColor.primary,
                                    ),
                                  ),
                                ),
                              ),
                        ),
                        // TitleNav(
                        //   title: 'Moneytory',
                        //   onTap: () {},
                        // ),
                        // Card(
                        //   elevation: .25,
                        //   child: Padding(
                        //     padding: const EdgeInsets.symmetric(
                        //         horizontal: 16.0, vertical: 16.0),
                        //     child: Column(
                        //       spacing: 8.0,
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       mainAxisAlignment: MainAxisAlignment.start,
                        //       children: [
                        //         Row(
                        //           mainAxisAlignment: MainAxisAlignment.start,
                        //           crossAxisAlignment: CrossAxisAlignment.center,
                        //           spacing: 32.0,
                        //           children: [
                        //             Column(
                        //               crossAxisAlignment:
                        //                   CrossAxisAlignment.start,
                        //               children: [
                        //                 Text(
                        //                   'Expenses',
                        //                   style: context.textTheme.bodyLarge,
                        //                 ),
                        //                 Text(
                        //                   '01 Mar 2024 - 13 Feb 2025',
                        //                   style: context.textTheme.bodyLarge
                        //                       ?.copyWith(
                        //                     color: AppColor.blackColorFaded,
                        //                   ),
                        //                 ),
                        //                 const SizedBox(
                        //                   height: 8.0,
                        //                 ),
                        //                 Text(
                        //                   'Rs ${540000.toDouble().toCommaSeparated()}',
                        //                   style:
                        //                       context.textTheme.headlineSmall,
                        //                 )
                        //               ],
                        //             ),
                        //             SizedBox(
                        //               width: 80,
                        //               height: 80,
                        //               child: PieChart(
                        //                 PieChartData(
                        //                   sections: [
                        //                     PieChartSectionData(
                        //                         color: Colors.blue,
                        //                         value: 40,
                        //                         title: '40%'),
                        //                     PieChartSectionData(
                        //                         color: Colors.red,
                        //                         value: 30,
                        //                         title: '30%'),
                        //                     PieChartSectionData(
                        //                         color: Colors.green,
                        //                         value: 20,
                        //                         title: '20%'),
                        //                     PieChartSectionData(
                        //                         color: Colors.yellow,
                        //                         value: 10,
                        //                         title: '10%'),
                        //                   ],
                        //                   sectionsSpace: 2,
                        //                   centerSpaceRadius:
                        //                       12.0, // Adjust for Doughnut effect
                        //                 ),
                        //               ),
                        //             )
                        //           ],
                        //         ),
                        //         const SizedBox(
                        //           height: 8.0,
                        //         ),
                        //         Wrap(
                        //           runSpacing: 2.0,
                        //           spacing: 4.0,
                        //           children: [
                        //             ...List.generate(
                        //               5,
                        //               (index) => Chip(
                        //                 label: Text('label $index'),
                        //                 backgroundColor: Color(
                        //                         (Random().nextDouble() *
                        //                                 0xFFFFFF)
                        //                             .toInt())
                        //                     .withValues(alpha: .8),
                        //               ),
                        //             )
                        //           ],
                        //         )
                        //       ],
                        //     ),
                        //   ),
                        // ),

                        // In & out..
                        TitleNav(
                          title: 'In & Out',
                          onTap: () {
                            context.push(
                                '${MyHomePage.route}${TransactionListingPage.route}');
                          },
                        ),
                        const Card(
                          elevation: .25,
                          child: TransactionListing(
                            cardId: null,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TitleNav extends StatelessWidget {
  const TitleNav({
    super.key,
    required this.title,
    this.onTap,
  });
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: context.textTheme.headlineSmall
                ?.copyWith(color: AppColor.blackColor.withValues(alpha: 0.85)),
          ),
          onTap != null
              ? const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColor.blackColorFaded,
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.onTap,
    this.inOut = false,
  });
  final String title;
  final String subtitle;
  final String trailing;
  final VoidCallback? onTap;
  final bool inOut;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.all(8.0)
            .copyWith(left: inOut ? 16.0 : null, right: inOut ? 16.0 : null),
        child: inOut
            ? Text(
                title.toUpperCase().characters.first,
                style: context.textTheme.headlineMedium?.copyWith(
                  color: AppColor.primary,
                ),
              )
            : Icon(
                Icons.credit_card,
                color: AppColor.primary,
              ),
      ),
      title: Text(
        title,
        style: context.textTheme.bodyLarge,
      ),
      subtitle: Text(
        inOut
            ? subtitle
            : '${Strings.dot} ${Strings.dot} ${Strings.dot} ${Strings.dot} $subtitle',
        style: context.textTheme.bodyMedium?.copyWith(
          color: AppColor.grey,
          fontWeight: FontWeight.bold,
          letterSpacing: .75,
        ),
      ),
      trailing: Text(
        trailing,
        style: context.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: inOut
                ? trailing.startsWith('+')
                    ? AppColor.green
                    : trailing.startsWith('-')
                        ? AppColor.redColor
                        : null
                : null),
      ),
    );
  }
}

class CardButton extends StatelessWidget {
  const CardButton({
    super.key,
    required this.iconData,
    required this.subtitle,
    this.onTap,
    this.blackColor = false,
  });
  final IconData iconData;
  final String subtitle;
  final VoidCallback? onTap;
  final bool blackColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 4.0,
      children: [
        IconButton(
          onPressed: onTap,
          style: IconButton.styleFrom(
            padding: const EdgeInsets.all(6.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                12.0,
              ),
            ),
          ),
          icon: Container(
            padding: const EdgeInsets.all(14.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: const Color(0xFF2F75FD),
            ),
            child: Icon(
              iconData,
              size: 30.0,
              color: AppColor.whiteColor,
            ),
          ),
        ),
        Text(
          subtitle,
          style: context.textTheme.bodyMedium?.copyWith(
              color: blackColor ? AppColor.blackColor : AppColor.whiteColor),
        )
      ],
    );
  }
}
