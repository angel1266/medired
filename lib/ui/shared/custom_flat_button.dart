import 'package:flutter/material.dart';

class CustomFlatButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color buttonColor;
  final double verticalPadding;
  final double horizontalPadding;
  final double fontsize;
  final double circularradius;
  final void Function()? onPressed;
  final TextAlign textalign;

  const CustomFlatButton({
    required this.text,
    required this.onPressed,
    this.fontsize = 20,
    this.textColor = Colors.white,
    this.buttonColor = Colors.transparent,
    this.verticalPadding = 10.0,
    this.circularradius = 20.0,
    this.horizontalPadding = 20.0,
    this.textalign = TextAlign.center,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: textColor,
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(circularradius),
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        child: Text(
          text,
          textAlign: textalign,
          style: TextStyle(
            fontSize: fontsize,
            letterSpacing: 0.03,
            fontFamily: 'Outfit',
          ),
        ),
      ),
    );
  }
}
