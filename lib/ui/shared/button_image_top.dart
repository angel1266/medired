import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medired/ui/shared/custom_flat_buttonsize.dart';

Widget selectorview(String text, Color fondo, String image, Function onpressed,
    double width, double height) {
  return GestureDetector(
    onTap: () => onpressed(),
    child: Center(
        child: Column(
      children: [
        Image(
          height: 76,
          image: AssetImage('assets/images/$image'),
        ),
        CustomFlatButtonsize(
          verticalPadding: 1,
          width: width,
          height: height,
          text: text,
          onPressed: onpressed,
          buttonColor: fondo,
        )
      ],
    )),
  );
}

Widget selectorview2(String text, Color fondo, Color textcolor, String image,
    Function onpressed, double width, double fonsize) {
  return GestureDetector(
    onTap: () => onpressed(),
    child: Container(
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(width * 0.045),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                textcolor, // Your color
                BlendMode.srcIn, // This blend mode will replace the SVG's color
              ),
              child: SvgPicture.asset(
                'assets/images/$image',
                height: 76,
              ),
            ),
            Text(
              text,
              style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: fonsize,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                  color: textcolor),
            )
          ],
        ),
      ),
    ),
  );
}

Widget selectorview3(String text, Color fondo, Color textcolor, String image,
    double imagensize, Function onpressed, double width, double fonsize) {
  return GestureDetector(
    onTap: () => onpressed(),
    child: Container(
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(width),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              height: imagensize,
              image: AssetImage('assets/images/$image'),
            ),
            Text(
              text,
              style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: fonsize,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                  color: textcolor),
            )
          ],
        ),
      ),
    ),
  );
}
