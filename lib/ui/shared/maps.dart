import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//import 'package:google_maps_flutter_web/google_maps_flutter_web.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(18.4750461,
        -69.9363125), // Coordenadas del Palacio Nacional de la República Dominicana
    zoom: 18.0, // Zoom inicial
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          markers: {
            const Marker(
              markerId: MarkerId('marker_1'),
              position: LatLng(18.475326, -69.9353576),
              infoWindow: InfoWindow(
                title:
                    'Torre Profesional Biltmore Av Abraham Lincoln 1003, Piantini, Distrito Nacional SD',
                snippet:
                    'Torre Profesional Biltmore Av Abraham Lincoln 1003, Piantini, Distrito Nacional SD',
              ),
            ),
          },
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ],
    );
  }
}
