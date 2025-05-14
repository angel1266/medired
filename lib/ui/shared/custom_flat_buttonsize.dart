import 'package:flutter/material.dart';

class CustomFlatButtonsize extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color buttonColor;
  final double verticalPadding;
  final double horizontalPadding;
  final double fontSize;
  final double circularRadius;
  final double width;
  final double height;
  final Function onPressed;

  const CustomFlatButtonsize({
    required this.text,
    required this.onPressed,
    this.fontSize = 20,
    this.textColor = Colors.white,
    this.buttonColor = Colors.transparent,
    this.verticalPadding = 10.0,
    this.circularRadius = 20.0,
    this.horizontalPadding = 20.0,
    this.width = 200.0, // Ancho deseado
    this.height = 50.0, // Alto deseado
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: textColor,
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(circularRadius),
          ),
        ),
        onPressed: () => onPressed(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: verticalPadding,
            horizontal: horizontalPadding,
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              letterSpacing: 0.03,
              fontFamily: 'Outfit',
            ),
          ),
        ),
      ),
    );
  }
}
