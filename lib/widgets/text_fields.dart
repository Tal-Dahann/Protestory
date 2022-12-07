import 'package:flutter/material.dart';
import 'package:protestory/constants/colors.dart';

class CustomTextFormField extends StatefulWidget {
  final String? label;
  final double? width;
  final double? height;
  final Color? color;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;

  const CustomTextFormField(
      {Key? key,
      this.label,
      this.width,
      this.height,
      this.color,
      this.controller,
      this.validator})
      : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: widget.width ?? 360,
        height: widget.height ?? 55,
        child: TextFormField(
          validator: widget.validator,
          controller: widget.controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: white,
            border: OutlineInputBorder(
                borderSide: BorderSide(color: darkGray),
                borderRadius: BorderRadius.circular(8)),
            labelText: widget.label,
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: blue),
                borderRadius: BorderRadius.circular(8)),
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
        ));
  }
}
