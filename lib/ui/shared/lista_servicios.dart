import 'package:flutter/material.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/constants/ui_helper.dart';

class ServiceInfo {
  final String title;
  final String subtitle;
  final List<String> services;

  ServiceInfo(this.title, this.subtitle, this.services);
}

class ServiceList extends StatelessWidget {
  final int selectedContainerIndex; // Índice del contenedor seleccionado
  final List<ServiceInfo> serviceInfoList; // Lista de información de servicios

  final BuildContext contextt;
  const ServiceList(
      this.selectedContainerIndex, this.serviceInfoList, this.contextt,
      {super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    bool device = context.screenType() == ScreenType.desktop;
    // Encuentra la posición del índice seleccionado
    final selectedOffset = selectedContainerIndex *
        300.0; // Cambia el valor 300.0 según sea necesario

    // Desplaza automáticamente al índice seleccionado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        selectedOffset - 10,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });

    return ListView.builder(
      controller: scrollController,
      itemCount: serviceInfoList.length,
      itemBuilder: (context, index) {
        final serviceInfo = serviceInfoList[index];
        final isSelected = index == selectedContainerIndex;

        return Container(
          margin: isSelected ? const EdgeInsets.all(10.0) : null,
          padding: EdgeInsets.symmetric(
              vertical: 16,
              horizontal: MediaQuery.of(context).size.width * 0.05),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border:
                isSelected ? Border.all(color: Colors.blue, width: 4.0) : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                serviceInfo.title,
                style: TextStyle(
                  color: isSelected
                      ? AppColors.blueBackground
                      : Colors.transparent,
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
                  color: isSelected
                      ? AppColors.greenBackground
                      : Colors.transparent,
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
                    .map((service) => Text(
                          '• $service',
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.blueBackground
                                : Colors.transparent,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            fontSize: device
                                ? MediaQuery.of(context).size.width * 0.02
                                : MediaQuery.of(context).size.width * 0.06,
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
