import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppColors {
  static const Color greenBackground = Color(0xFF94a10c);
  static const Color blueBackground = Color(0xFF242f5c);
  static const Color whiteBackground = Color.fromRGBO(255, 255, 255, 1);
  static const Color lightBackground = Color.fromRGBO(237, 241, 249, 1);

  static const Color whiteBorder = Color.fromRGBO(255, 255, 255, 1);
  static const Color lightBorder = Color.fromRGBO(190, 212, 255, 0.719);

  static const Color boxShadow = Color.fromRGBO(0, 0, 0, 0.15);

  
  static const Color lightBlueBackground = Color(0xFFB3E5FC); // Este es un tono de azul claro

  
   static IconData getIconForService(String serviceName) {
    switch (serviceName.toLowerCase()) {
      case 'consultas':
        return Icons.medical_services_outlined;
      case 'imágenes':
        return FontAwesomeIcons.xRay;
      case 'laboratorio':
        return Icons.science_outlined;
      case 'odontología':
        return Icons.masks;
      case 'audiometría':
        return Icons.hearing;
      case 'hospitalización':
        return Icons.local_hospital;
      case 'óptica':
        return Icons.visibility;
      case 'farmacia':
        return Icons.local_pharmacy;
      default:
        return Icons.help_outline;
    }
  }
}
