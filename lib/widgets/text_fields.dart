import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:protestory/constants/colors.dart';

class CustomTextFormField extends StatefulWidget {
  final String? label;
  final double width;
  final double height;
  final Color? color;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final String? hintText;
  final String? errorText;
  final AutovalidateMode? autovalidateMode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final Widget? icon;
  final bool readOnly;
  final AsyncValueGetter? onTap;
  final FocusNode? focusNode;
  final int? maxLines;

  const CustomTextFormField({
    Key? key,
    this.label,
    this.width = 360,
    this.height = 85,
    this.color,
    this.controller,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.hintText,
    this.errorText,
    this.autovalidateMode,
    this.textInputAction,
    this.onChanged,
    this.onFieldSubmitted,
    this.icon,
    this.readOnly = false,
    this.onTap,
    this.focusNode,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: widget.width,
        height: widget.height,
        child: TextFormField(
          maxLines: widget.maxLines,
          focusNode: widget.focusNode,
          onTap: widget.onTap,
          readOnly: widget.readOnly,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          controller: widget.controller,
          autovalidateMode: widget.autovalidateMode,
          textInputAction: widget.textInputAction,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onFieldSubmitted,
          decoration: InputDecoration(
              suffixIcon: widget.icon,
              suffixIconColor: widget.icon != null ? blue : null,
              filled: true,
              fillColor: white,
              border: OutlineInputBorder(
                  borderSide: const BorderSide(color: darkGray),
                  borderRadius: BorderRadius.circular(8)),
              labelText: widget.label,
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: blue),
                  borderRadius: BorderRadius.circular(8)),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              hintText: widget.hintText,
              errorText: widget.errorText),
        ));
  }
}
