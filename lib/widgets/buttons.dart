import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String label;
  final double? width;
  final double? height;
  final Color? color;
  final Color? textColor;
  final VoidCallback onPressed;

  const CustomButton(
      {Key? key,
      required this.label,
      this.width,
      this.height,
      required this.onPressed,
      this.color, this.textColor})
      : super(key: key);

  @override
  State<CustomButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? 200,
      height: widget.height ?? 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.color ?? const Color(0xff4c5dd2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: widget.onPressed,
        child: Text(widget.label,
            style: TextStyle(color: widget.textColor ?? Colors.white, fontSize: 23)),
      ),
    );
  }
}
