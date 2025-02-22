import 'package:flutter/material.dart';
import 'package:saving/core/extensions/context_extension.dart';
import 'package:saving/features/card/widgets/create_card.dart';

Future<void> createCardSheet({required BuildContext context}) async {
  showModalBottomSheet(
    showDragHandle: true,
    isDismissible: false,
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CreateCard(
            showLabel: false,
            onSuccess: () {
              Navigator.of(context).pop();
            },
          ),
          Padding(padding: EdgeInsets.only(bottom: context.bottomPadding))
        ],
      );
    },
  );
}
