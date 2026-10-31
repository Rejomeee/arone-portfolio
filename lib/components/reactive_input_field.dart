import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../constant/style.dart';

class ReactiveInputField extends StatelessWidget {
  const ReactiveInputField({
    super.key,
    required this.formControlName,
    required this.title,
    this.validationMessages,
    this.maxLines = 1,
    this.keyboardType,
    this.autofillHints,
  });

  final String formControlName;
  final String title;
  final Map<String, ValidationMessageFunction>? validationMessages;
  final int maxLines;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: kCardBorder),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReactiveTextField<String>(
          formControlName: formControlName,
          maxLines: maxLines,
          keyboardType: keyboardType,
          autofillHints: autofillHints,
          validationMessages: validationMessages,
          style: kTextSub,
          cursorColor: kMainColor,
          decoration: InputDecoration(
            labelText: title,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            filled: true,
            fillColor: kColorWhite,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines == 1 ? 14 : 12,
            ),
            border: border,
            enabledBorder: border,
            focusedBorder: border.copyWith(
              borderSide: const BorderSide(color: kMainColor, width: 1.4),
            ),
            errorStyle: kTextCaption.copyWith(
              color: kColorRed,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
