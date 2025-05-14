import 'package:fluro/fluro.dart';
import 'package:medired/ui/views/main_servicios_page.dart';
import 'package:medired/ui/views/planes.dart';
import 'package:medired/ui/views/contacto.dart';
import 'package:medired/ui/views/home_page.dart';
import 'package:medired/ui/views/login_admin_page.dart';
import 'package:medired/ui/views/prestadores_page.dart';
import 'package:medired/ui/views/provedores.dart';
import 'package:medired/ui/views/servicios_menbresias.dart';
import 'package:medired/ui/views/servicios_page.dart';
import 'package:medired/ui/views/login_page.dart';
import 'package:medired/ui/views/membership.dart';
import 'package:medired/ui/views/recover_password.dart';
import 'package:medired/ui/views/register_page.dart';
import 'package:medired/ui/views/solicitud_paciente.dart';
import 'package:medired/ui/views/solicitudes.dart';
import 'package:medired/ui/views/view_404.dart';

// Handlers
final defaultPageHandler = Handler(handlerFunc: (context, params) {
  return const Home();
});
final membresiasHandler = Handler(handlerFunc: (context, params) {
  return const Membresias();
});
final membresias2Handler = Handler(handlerFunc: (context, params) {
  int? index = int.tryParse(params['index']![0]);
  index ??= 3;
  return ServiciosMenber(
    heartIndex: index,
  );
});

final loginHandler = Handler(handlerFunc: (context, params) {
  return const LoginPage();
});
final loginAdminHandler = Handler(
  handlerFunc: (context, parameters) => const LoginAdminPage(),
);
final contactoHandler = Handler(handlerFunc: (context, params) {
  return const Contacto();
});

final prestadoresHandler = Handler(handlerFunc: (context, params) {
  return const PrestadoresPage();
});
final ServiciosHandler = Handler(handlerFunc: (context, params) {
  return   MainServiciosPage(id: (params['id']![0] ?? "").toString(),);
});

final planesHandler = Handler(handlerFunc: (context, params) {
  return const Planes();
});
final provedoresHandler = Handler(handlerFunc: (context, params) {
  return const Provedores();
});
final registerHandler = Handler(handlerFunc: (context, params) {
  return const RegisterPage();
});
// final systemHandler = Handler(handlerFunc: (context, params) {
//   return const SystemPage();
// });
final serviciosHandler = Handler(handlerFunc: (context, params) {
  return const Servicios();
});

final solicitudesHandler = Handler(handlerFunc: (context, params) {
  return const Solicitudes();
});
final solicitudpacienteHandler = Handler(handlerFunc: (context, params) {
  return const Solicitudpage();
});

final forgotHandler = Handler(handlerFunc: (context, params) {
  return const Forgot();
});
// 404

final pageNotFound = Handler(handlerFunc: (_, __) => const View404());