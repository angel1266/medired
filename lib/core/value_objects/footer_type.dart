import 'package:medired/router/route_generator.dart';

final List<String> servicesList = [
  'Consultas',
  'Imágenes',
  'Laboratorios',
];

final Map<String, String> navegacionMap = {
  'Inicio': RouteGenerator.defaultPage,
  'Servicios': RouteGenerator.serviciosPage,
  'Prestadores': RouteGenerator.prestadoresPage,
  'Quieres ser prestador': RouteGenerator.provedoresPage,
  'Contáctanos': RouteGenerator.contactoPage,
  'Registro': RouteGenerator.signUpPage,
  'Términos y Condiciones': '/documents/Terminos%20y%20Condiciones.pdf',
  'Políticas de privacidad': '/documents/politicasdeprivacidad.pdf',

  // 'Prestadores': RouteGenerator.prestadoresPage,
};
