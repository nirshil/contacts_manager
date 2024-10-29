import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final InputBorder border;
  final InputBorder enabledBorder;
  final InputBorder focusedBorder;
  final EdgeInsets padding;
  final TextStyle? style;
  final Color enteredTextColor;
  final TextInputType keyboardType;
  final int? maxlength;
  Function(String)? onchange;
  AppTextfield(
      {super.key,
      this.maxlength,
      this.onchange,
      this.keyboardType = TextInputType.name,
      this.enteredTextColor = Colors.black,
      this.focusedBorder = InputBorder.none,
      this.style,
      this.padding = const EdgeInsets.only(left: 10),
      required this.controller,
      required this.hintText,
      this.border = InputBorder.none,
      this.enabledBorder = InputBorder.none});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onchange,
      maxLength: maxlength,
      keyboardType: keyboardType,
      style: TextStyle(color: enteredTextColor),
      controller: controller,
      decoration: InputDecoration(
          contentPadding: padding,
          hintText: hintText,
          hintStyle: style,
          border: border,
          enabledBorder: enabledBorder,
          focusedBorder: focusedBorder),
    );
  }
}
