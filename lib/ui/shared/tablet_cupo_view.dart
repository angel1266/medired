import 'dart:math';

import 'package:flutter/material.dart';
import 'package:medired/ui/shared/tablet_cupo.dart';

class CupoWidgetData {
  final String nombre;
  final String precio;
  final List<String> servicios;
  final Color color;

  CupoWidgetData({
    required this.nombre,
    required this.precio,
    required this.servicios,
    required this.color,
  });
}

class CupoWidgetList extends StatelessWidget {
  final List<CupoWidgetData> cupos;

  // Nuevos parámetros para las dimensiones
  final double itemWidth;
  final double itemHeight;

  CupoWidgetList({
    super.key,
    required this.cupos,
    required this.itemWidth,
    required this.itemHeight,
  });
  final _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: itemHeight + 50,
      child: Stack(
        children: [
          SizedBox(
            height: itemHeight + 50,
            child: ListView.builder(
              controller: _controller,
              scrollDirection: Axis.horizontal,
              itemCount: cupos.length,
              itemBuilder: (context, index) {
                return CupoWidget(
                  nombre: cupos[index].nombre,
                  precio: cupos[index].precio,
                  servicios: cupos[index].servicios,
                  color: cupos[index].color,
                  maxHeight: itemHeight,
                  maxWidth: max(125, itemWidth / 4),
                );
              },
            ),
          ),
          /* Center(
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_forward_ios),
                color: Colors.white,
                onPressed: () {
                  if (_controller.position.pixels <
                      _controller.position.maxScrollExtent) {
                    _controller.animateTo(
                        _controller.position.pixels + itemWidth / 2,
                        duration: Duration(microseconds: 10),
                        curve: Curves.bounceIn);
                  }
                  // Implement scrolling logic here
                },
              ),
            ),
          ),*/
        ],
      ),
    );
  }
}
