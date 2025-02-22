import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saving/core/theme/app_color.dart';
import 'package:saving/core/widgets/app_constrained_scroll_view.dart';
import 'package:saving/core/widgets/app_scaffold.dart';
import 'package:saving/core/widgets/whitish_text_button.dart';
import 'package:saving/features/card/pages/card_detail.dart';
import 'package:saving/features/card/providers/card_service_provider.dart';
import 'package:saving/features/card/widgets/bank_card_widget.dart';
import 'package:saving/features/card/widgets/create_card.dart';
import 'package:saving/features/card/widgets/create_card_sheet.dart';
import 'package:saving/features/home/pages/home_page.dart';
import 'package:saving/features/home/widgets/transaction_listing.dart';

class CardPage extends ConsumerStatefulWidget {
  const CardPage({super.key});

  static String get route => '/card';

  @override
  ConsumerState<CardPage> createState() => _CardPageState();
}

class _CardPageState extends ConsumerState<CardPage> {
  late PageController carouselController;
  late ValueNotifier<int> pageListener;

  @override
  void initState() {
    super.initState();
    carouselController = PageController();
    pageListener = ValueNotifier(0);
  }

  @override
  void dispose() {
    carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text('Cards'),
        centerTitle: false,
        actions: [
          BlurIconButton(
            iconData: Icons.add,
            onTap: () async {
              await createCardSheet(
                context: context,
              );
            },
          ),
          const SizedBox(
            width: 4.0,
          )
        ],
      ),
      releaseFocus: true,
      body: RefreshIndicator(
        onRefresh: () async{
          ref.invalidate(cardListingProvider);          
        },
        child: AppConstrainedScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: Column(
            children: [
              Consumer(
                builder: (context, ref, child) {
                  return ref.watch(cardListingProvider).when(
                        data: (data) {
                          if (data.isEmpty) {
                            return const CreateCard();
                          }
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 8.0,
                            children: [
                              SizedBox(
                                height: 220,
                                child: PageView.builder(
                                  controller: carouselController,
                                  itemBuilder: (context, index) => InkWell(
                                      onTap: () {
                                        context.push(
                                            CardDetail.route(id: data[index].id));
                                      },
                                      child: BankCardWidget(card: data[index])),
                                  itemCount: data.length,
                                  onPageChanged: (page) {
                                    pageListener.value = page;
                                  },
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ...List.generate(
                                    data.length,
                                    (index) => ValueListenableBuilder(
                                      valueListenable: pageListener,
                                      builder: (context, page, _) =>
                                          AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 2.0),
                                        width: page == index ? 40 : 10,
                                        height: 5,
                                        decoration: BoxDecoration(
                                          color: page == index
                                              ? AppColor.green
                                              : AppColor.grey,
                                          borderRadius: BorderRadius.circular(
                                            8.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const Text('Tap on the card for more features!'),
                              const SizedBox(
                                height: 16.0,
                              ),
                              const TitleNav(title: 'Transaction History'),
                              ValueListenableBuilder(
                                valueListenable: pageListener,
                                builder: (context, page, child) =>
                                    TransactionListing(
                                  cardId: data[page].id,
                                  fullListing: true,
                                ),
                              ),
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
                      );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
