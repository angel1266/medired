import 'package:flutter/material.dart';
import 'package:medired/ui/shared/servicios_menber.dart';

class ServiciosMenber extends StatelessWidget {
  final int? heartIndex;
  const ServiciosMenber({super.key, this.heartIndex});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
          ),
          Image(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            image: const AssetImage('assets/images/camas.png'),
            fit: BoxFit.cover,
          ),
          Container(
            padding: const EdgeInsets.only(top: 0),
            child: ServiciosMenberView(servicio: heartIndex ?? 1),
          ),
        ],
      ),
    );
  }
}
