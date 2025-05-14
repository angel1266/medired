import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/shared/custom_flat_button.dart';
//import 'package:medired/ui/shared/global.dart';

Future<void> location(BuildContext contexts) async {
  return showModalBottomSheet(
    context: contexts,
    useRootNavigator: true,
    isScrollControlled: true,
    enableDrag: false,
    builder: (context) {
      return DraggableScrollableSheet(
        minChildSize: .4,
        maxChildSize: 1,
        expand: false,
        initialChildSize: .8,
        builder: (context, scrollController) {
          return MapBottomSheet(
            contexts: contexts,
          );
        },
      );
    },
  );
}

class MapBottomSheet extends StatefulWidget {
  final BuildContext contexts;

  const MapBottomSheet({
    super.key,
    required this.contexts,
  });
  @override
  State<MapBottomSheet> createState() => _MapBottomSheetState();
}

class _MapBottomSheetState extends State<MapBottomSheet> {
  LatLng markerLocation = const LatLng(
      18.4790, -69.8906); // Ubicación inicial en la capital (Santo Domingo)

  @override
  Widget build(BuildContext context) {
    return Column(
      //mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(
                    18.4790, -69.8906), // Ubicación inicial en Santo Domingo
                zoom: 15,
              ),
              onMapCreated: (GoogleMapController controller) {},
              markers: {
                Marker(
                    markerId: const MarkerId('selected_location'),
                    position: markerLocation,
                    draggable: true, // Permite arrastrar el marcador
                    onDragEnd: (LatLng location) {
                      setState(() {
                        markerLocation = location;
                      });
                    }),
              },
              onTap: (LatLng location) {
                setState(() {
                  markerLocation = location;
                  /*   print(
                        markerLocation);*/ // Actualiza la ubicación del marcador al tocar el mapa
                });
              },
            ),
          ),
        ),
        CustomFlatButton(
          buttonColor: AppColors.blueBackground,
          text: 'Aceptar Ubicacion',
          onPressed: () {
            //  print(markerLocation);
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
