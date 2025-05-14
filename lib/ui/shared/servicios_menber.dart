import 'package:flutter/material.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/constants/ui_helper.dart';
import 'package:medired/ui/shared/lista_servicios.dart';

class ServiciosMenberView extends StatefulWidget {
  final int? servicio;
  const ServiciosMenberView({super.key, required this.servicio});

  @override
  State<ServiciosMenberView> createState() => _ServiciosMenberViewState();
}

class _ServiciosMenberViewState extends State<ServiciosMenberView> {
  List<ServiceInfo> serviceInfoList = [
    ServiceInfo(
      'Consultas',
      '4 coberturas de diferencia / Copago gratis anual',
      [
        'Ginecología',
        'Medicina interna',
        'Pediatría',
        'Medicina general',
        'Urología',
        'Oftalmología',
      ],
    ),
    ServiceInfo(
      'Imágenes',
      '4 coberturas de diferencia / Copago gratis anual',
      [
        'Rayos X',
        'Sonografía',
        'Cardiovasculares: Eco',
        'Electrocardiograma',
      ],
    ),
    ServiceInfo(
      'Laboratorios',
      '4 coberturas de diferencia / Copago gratis anual',
      [
        'Hemograma',
        'Orina',
        'Perfil lipídico',
        'Glucosa',
      ],
    ),
    ServiceInfo(
      'Odontología',
      '5% de descuento ilimitado en catálogo específico de servicios',
      ['1 visita de consulta general gratis'],
    ),
    ServiceInfo(
      'Audiometría',
      '10% de descuento',
      [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var serviceInfo = serviceInfoList[widget.servicio ?? 0];
    bool device = context.screenType() == ScreenType.desktop;

    void onTap(PointerDownEvent event) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }

    const images = [
      'assets/images/consultas modal bg.jpg',
      'assets/images/images modal bg.jpg',
      'assets/images/lab modal bg.jpg',
      'assets/images/odontología modal bg.jpg',
      'assets/images/audiometry modal bg.jpg',
    ];

    return TapRegion(
      onTapInside: onTap,
      onTapOutside: onTap,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.blue,
              width: 4.0,
            ),
            image: DecorationImage(
                image: AssetImage(
                  images[widget.servicio ?? 0],
                ),
                fit: BoxFit.cover),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 16,
              horizontal: MediaQuery.of(context).size.width * 0.05,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.blueBackground,
                  Colors.transparent,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  serviceInfo.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: device
                        ? MediaQuery.of(context).size.width * 0.06
                        : MediaQuery.of(context).size.width * 0.12,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  serviceInfo.subtitle,
                  style: TextStyle(
                    color: AppColors.greenBackground,
                    fontWeight: FontWeight.normal,
                    fontSize: device
                        ? MediaQuery.of(context).size.width * 0.02
                        : MediaQuery.of(context).size.width * 0.06,
                  ),
                ),
                const SizedBox(height: 12.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: serviceInfo.services
                      .map(
                        (service) => Text(
                          '• $service',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            fontSize: device
                                ? MediaQuery.of(context).size.width * 0.02
                                : MediaQuery.of(context).size.width * 0.06,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
