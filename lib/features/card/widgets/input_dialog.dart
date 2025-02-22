import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saving/core/extensions/context_extension.dart';
import 'package:saving/core/widgets/app_textfield.dart';

class InputDialog extends StatelessWidget {
  const InputDialog({super.key, required this.textEditingController});
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8.0,
        children: [
          Text(
            'Enter Amount',
            style: context.textTheme.bodyLarge,
          ),
          AppTextfield(
            controller: textEditingController,
            hintText: 'Enter amount',
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              context.pop();
            },
            child: const Text('OK'))
      ],
    );
  }
}

Future<void> showInputDialog({
  required BuildContext context,
  required TextEditingController controller,
}) async {
  await showDialog(
    context: context,
    builder: (context) => InputDialog(textEditingController: controller),
  );
}
