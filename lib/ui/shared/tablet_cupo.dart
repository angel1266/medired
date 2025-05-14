import 'dart:math';

import 'package:flutter/material.dart';
import 'package:medired/ui/constants/app_colors.dart';

class CupoWidget extends StatelessWidget {
  final String nombre;
  final String precio;
  final List<String> servicios;
  final Color color;
  final double maxHeight;
  final double maxWidth;

  const CupoWidget({
    super.key,
    required this.nombre,
    required this.precio,
    required this.servicios,
    required this.color,
    required this.maxHeight,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Línea de color
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Container(
              height: max(1, maxWidth * 0.01),
              width: maxWidth,
              color: color,
            ),
          ),

          // Container transparente
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: color, width: max(1, maxWidth * 0.007)),
              borderRadius: BorderRadius.circular(maxWidth * 0.1),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: maxHeight * 0.9,
                minWidth: maxWidth,
              ),
              child: Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Cupo information
                    Text(nombre,
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(
                                color: AppColors.blueBackground,
                                fontWeight: FontWeight.w700)),
                    Text(precio,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                color: const Color.fromARGB(255, 108, 136, 161),
                                fontWeight: FontWeight.w700)),
                    SizedBox(
                      height: maxHeight * 0.1,
                    ),
                    // Services list
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: servicios
                          .map((servicio) => Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(Icons.check),
                                  Text(
                                    servicio,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(color: Colors.black),
                                  ),
                                ],
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Botón de selección
          ButtonTheme(
            minWidth: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text('Elegir $nombre',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
