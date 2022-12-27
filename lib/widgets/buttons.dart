import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final double width;
  final double height;
  final Color? color;
  final Color? textColor;
  final VoidCallback onPressed;

  const CustomButton(
      {Key? key,
      required this.text,
      this.width = 200,
      this.height = 50,
      required this.onPressed,
      this.color,
      this.textColor})
      : super(key: key);

  @override
  State<CustomButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(widget.width, widget.height),
        backgroundColor: widget.color ?? const Color(0xff4c5dd2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: widget.onPressed,
      child: Text(widget.text,
          style:
              TextStyle(color: widget.textColor ?? Colors.white, fontSize: 23)),
    );
  }
}

/////////////////////////////////
//
//
/////////////////////////////////

class CustomButtonWithLogo extends StatefulWidget {
  final String text;
  final double width;
  final double height;
  final Color? color;
  final Color? textColor;
  final VoidCallback onPressed;
  final String svgLogoPath;

  const CustomButtonWithLogo(
      {Key? key,
      required this.text,
      this.width = 200,
      this.height = 50,
      required this.onPressed,
      this.color,
      this.textColor,
      required this.svgLogoPath})
      : super(key: key);

  @override
  State<CustomButtonWithLogo> createState() => _CustomButtonWithLogoState();
}

class _CustomButtonWithLogoState extends State<CustomButtonWithLogo> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(widget.width, widget.height),
        backgroundColor: widget.color ?? const Color(0xff4c5dd2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: widget.onPressed,
      icon: SvgPicture.asset(
        widget.svgLogoPath,
        width: widget.height * 0.7,
        height: widget.height * 0.7,
      ),
      label: Text(
        widget.text,
        style: TextStyle(color: widget.textColor ?? Colors.black, fontSize: 23),
      ),
    );
  }
}
