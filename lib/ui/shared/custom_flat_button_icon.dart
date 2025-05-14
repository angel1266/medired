import 'package:flutter/material.dart';

class CustomButtonWithIcon extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color textColor;
  final Color buttonColor;
  final double verticalPadding;
  final double horizontalPadding;
  final double fontsize;
  final double circularradius;
  final Function onPressed;
  final TextAlign textalign;
  final double? width; // Nuevo ancho personalizable

  const CustomButtonWithIcon({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
    this.fontsize = 20,
    this.textColor = Colors.white,
    this.buttonColor = Colors.transparent,
    this.verticalPadding = 10.0,
    this.circularradius = 20.0,
    this.horizontalPadding = 20.0,
    this.textalign = TextAlign.center,
    this.width, // Ancho personalizable
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
      onPressed: () => onPressed(),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: width ??
              horizontalPadding, // Ancho personalizable o predeterminado
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon),
            const SizedBox(
                width: 10), // Ajusta el espaciado entre el icono y el texto
            Text(
              text,
              textAlign: textalign,
              style: TextStyle(
                fontSize: fontsize,
                letterSpacing: 0.03,
                fontFamily: 'Outfit',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
