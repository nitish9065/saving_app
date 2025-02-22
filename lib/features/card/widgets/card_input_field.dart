import 'package:flutter/material.dart';
import 'package:saving/core/theme/app_color.dart';

class CardInputField extends StatefulWidget {
  const CardInputField(
      {super.key, this.hintText = 'Name', required this.controller});

  final String? hintText;
  final TextEditingController controller;

  @override
  State<CardInputField> createState() => _CardInputFieldState();
}

class _CardInputFieldState extends State<CardInputField> {
  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      textCapitalization: TextCapitalization.words,
      maxLines: 1,
      style: const TextStyle(color: AppColor.whiteColor, letterSpacing: 0.5),
      cursorColor: AppColor.whiteColor.withValues(alpha: 0.7),
      scrollPadding: EdgeInsets.zero,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          color: AppColor.grey,
        ),
        filled: false,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColor.whiteColor,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColor.whiteColor,
          ),
        ),
      ),
    );
  }
}
