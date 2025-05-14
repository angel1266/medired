import 'package:flutter/material.dart';
import 'package:medired/core/value_objects/images_type.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/shared/carusel.dart';
import 'package:medired/ui/views/membership.dart';

class Homeview extends StatefulWidget {
  const Homeview({
    super.key,
  });

  @override
  State<Homeview> createState() => HomeviewState();
}

class HomeviewState extends State<Homeview> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Membresias(),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Container scrollhome(BuildContext context) {
    ScrollController controller = ScrollController();
    double size = MediaQuery.of(context).size.width * 0.25 > 250
        ? MediaQuery.of(context).size.width * 0.25
        : 250;

    return Container(
        color: Colors.white,
        height: 300,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SingleChildScrollView(
              controller: controller,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: imagesTypeToString[ImagesType.grupo1]!
                    .asMap()
                    .map((index, image) {
                      return MapEntry(
                        index,
                        Image(
                          height: 250,
                          image: AssetImage('assets/images/$image'),
                          width: size,
                          fit: BoxFit.cover,
                        ),
                      );
                    })
                    .values
                    .toList(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all<CircleBorder>(
                      const CircleBorder(
                        side: BorderSide(
                          color: Colors.white, // Color del borde blanco
                          width: 2.0, // Ancho del borde
                        ),
                      ),
                    ),
                    backgroundColor: WidgetStateProperty.all<Color>(
                        Colors.transparent), // Fondo transparente
                  ),
                  icon: const Icon(
                    Icons.arrow_circle_left,
                    color: AppColors.blueBackground,
                  ),
                  onPressed: () {
                    controller.animateTo(
                      controller.position.pixels - size,
                      duration: const Duration(
                          milliseconds:
                              500), // Ajusta la duración según tus preferencias
                      curve: Curves
                          .easeInOut, // Ajusta la curva de animación según tus preferencias
                    );
                    // Lógica para desplazarse a la izquierda\
                  },
                ),
                IconButton(
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all<CircleBorder>(
                      const CircleBorder(
                        side: BorderSide(
                          color: Colors.white, // Color del borde blanco
                          width: 2.0, // Ancho del borde
                        ),
                      ),
                    ),
                    backgroundColor: WidgetStateProperty.all<Color>(
                        Colors.transparent), // Fondo transparente
                  ),
                  icon: const Icon(
                    Icons.arrow_circle_right,
                    color: AppColors.blueBackground,
                  ),
                  onPressed: () {
                    controller.animateTo(
                      controller.position.pixels + size,
                      duration: const Duration(
                          milliseconds:
                              500), // Ajusta la duración según tus preferencias
                      curve: Curves
                          .easeInOut, // Ajusta la curva de animación según tus preferencias
                    );
                    // Lógica para desplazarse a la derecha
                  },
                ),
              ],
            ),
          ],
        ));
  }
}
