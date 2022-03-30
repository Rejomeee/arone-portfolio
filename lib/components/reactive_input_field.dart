import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_my_portfolio/constant/style.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ReactiveInputField extends StatelessWidget {
  const ReactiveInputField({
    Key? key,
    this.padding = const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 26.0),
    this.textCapitalization = TextCapitalization.none,
    @required this.formControlName,
    this.maxLines = 1,
    this.textInputAction = TextInputAction.next,
    this.title,
    this.helperText,
    this.suffixIcon,
    this.prefixIcon,
    this.readOnly = false,
    this.validationMessages,
    this.withBorder = false,
    this.keyboardType,
    this.inputFormatters,
    this.onSubmitted,
    this.labelText,
    this.prefixText,
    this.floatingLabelBehavior = FloatingLabelBehavior.never,
    this.requiredField = false,
    this.obscureText = false,
    this.valueAccessor,
    this.hintText,
    this.inputBorder,
    this.maxLength,
    this.isFilled = false,
  }) : super(key: key);

  final EdgeInsetsGeometry? padding;
  final TextCapitalization textCapitalization;
  final String? formControlName;
  final int? maxLines;
  final TextInputAction? textInputAction;
  final String? title;
  final String? helperText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? hintText;
  final bool readOnly;
  final Map<String, String> Function(FormControl<dynamic>)? validationMessages;
  final bool withBorder;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Function()? onSubmitted;
  final String? labelText;
  final String? prefixText;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final bool requiredField;
  final bool obscureText;
  final ControlValueAccessor<dynamic, dynamic>? valueAccessor;
  final InputBorder? inputBorder;
  final int? maxLength;
  final bool isFilled;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /* Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 20.w, right: 15.h, top: 20.w),
          child: Text(title, style: kTextFieldTitle),
        ),
        Container(
          padding: padding,
          child: ReactiveTextField(
            formControlName: formControlName,
            maxLines: maxLines,
            textInputAction: textInputAction,
            decoration: InputDecoration(
              helperText: helperText,
              helperStyle: kTextBody.copyWith(
                fontSize: 16.ssp,
                fontWeight: FontWeight.w500,
              ),
              helperMaxLines: 2,
              suffixIcon: suffixIcon,
            ),
            readOnly: readOnly,
            valueAccessor: valueAccessor,
          ),
        ), */

        title != null
            ? Container(
                alignment: Alignment.centerLeft,
                child: withBorder
                    ? Row(
                        children: [
                          Text(
                            title!,
                            style: kTextSub.copyWith(color: kColorBlack),
                          ),
                          if (requiredField)
                            Text(' *', style: TextStyle(color: kColorRed))
                        ],
                      )
                    : Row(
                        children: [
                          Text(title!, style: kTextSub),
                          requiredField
                              ? Text(
                                  ' *',
                                  style: TextStyle(color: kColorRed),
                                )
                              : SizedBox.shrink()
                        ],
                      ),
              )
            : SizedBox.shrink(),
        title != null ? SizedBox(height: 5) : SizedBox.shrink(),
        Container(
          padding: padding,
          child: ReactiveTextField(
            style: kTextSub,
            textCapitalization: textCapitalization,
            formControlName: formControlName,
            obscureText: obscureText,
            maxLines: maxLines,
            validationMessages: validationMessages,
            textInputAction: textInputAction,
            onSubmitted: onSubmitted,
            maxLength: maxLength,
            decoration: InputDecoration(
              fillColor: isFilled ? kBackgroundColor : kColorWhite,
              filled: isFilled,
              border: withBorder
                  ? OutlineInputBorder()
                  : inputBorder == InputBorder.none
                      ? InputBorder.none
                      : null,
              labelText: labelText,
              helperText: helperText,
              helperStyle: kTextBody,
              helperMaxLines: 2,
              suffixIcon: suffixIcon,
              prefixIcon: prefixIcon,
              prefixText: prefixText,
              floatingLabelBehavior: floatingLabelBehavior,
              hintText: hintText,
              errorStyle: kTextBody.copyWith(
                color: kColorRed,
              ),
            ),
            readOnly: readOnly,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            autocorrect: false,
            // valueAccessor: valueAccessor,
          ),
        ),
      ],
    );
  }
}
