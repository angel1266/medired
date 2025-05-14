import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:medired/ui/views/main_servicios_page.dart';
import 'package:medired/ui/views/planes.dart';
import 'package:medired/ui/views/contacto.dart';
import 'package:medired/ui/views/home_page.dart';
import 'package:medired/ui/views/login_admin_page.dart';
import 'package:medired/ui/views/prestadores_page.dart';
import 'package:medired/ui/views/servicios_page.dart';
import 'package:medired/ui/views/login_page.dart';
import 'package:medired/ui/views/membership.dart';
import 'package:medired/ui/views/recover_password.dart';
import 'package:medired/ui/views/register_page.dart';
import 'package:medired/ui/views/solicitud_paciente.dart';
import 'package:medired/ui/views/solicitudes.dart';
import 'package:medired/ui/views/view_404.dart';

class RouteGenerator {
  static const String defaultPage = '/';
  static const String subscriptionPage = '/membership';
  static const String subscription2Page = '/ServMembresias';
  static const String usersList = '/users';
  static const String loginPage = '/login';
  static const String loginAdminPage = '/loginAdmin';
  static const String signUpPage = '/sign-up';
  static const String systemPage = '/System';
  static const String resetPasswordPage = '/Forgot';
  static const String servicesPage = '/Servicios/';
  static const String planesPage = '/Planes';
  static const String contactoPage = '/contact';
  static const String provedoresPage = '/providers';
  static const String prestadoresPage = '/prestadores';
  static const String serviciosPage = '/servicios';

  static const String solicitudesPage = '/Solicitudes';
  static const String solicitudpacientePage = '/Paciente';

  static const String notFoundPage = '/404';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case defaultPage:
        return _fadeRoute(const Home(), defaultPage);

      case subscriptionPage:
        return _fadeRoute(const Membresias(), subscriptionPage);
      case subscription2Page:
        return _fadeRoute(const Membresias(), subscription2Page);
      case loginPage:
        return _fadeRoute(const LoginPage(), loginPage);
      case prestadoresPage:
        return _fadeRoute(const PrestadoresPage(), prestadoresPage);
      case serviciosPage:
        return _fadeRoute(const MainServiciosPage(), serviciosPage);

      case loginAdminPage:
        return _fadeRoute(const LoginAdminPage(), loginAdminPage);
      case signUpPage:
        return _fadeRoute(const RegisterPage(), signUpPage);
      // case systemPage:
      //   return _fadeRoute(const SystemPage(), systemPage);
      case resetPasswordPage:
        return _fadeRoute(const Forgot(), resetPasswordPage);
      case servicesPage:
        return _fadeRoute(const Servicios(), servicesPage);
      case contactoPage:
        return _fadeRoute(const Contacto(), contactoPage);
      case planesPage:
        return _fadeRoute(const Planes(), planesPage);
      case solicitudesPage:
        return _fadeRoute(const Solicitudes(), solicitudesPage);
      case solicitudpacientePage:
        return _fadeRoute(const Solicitudpage(), solicitudpacientePage);
      default:
        return _fadeRoute(const View404(), notFoundPage);
    }
  }

  static PageRoute _fadeRoute(Widget child, String routeName) {
    return PageRouteBuilder(
        settings: RouteSettings(name: routeName),
        pageBuilder: (_, __, ___) => child,
        transitionDuration: const Duration(milliseconds: 200),
        transitionsBuilder: (_, animation, __, ___) => (kIsWeb)
            ? FadeTransition(
                opacity: animation,
                child: child,
              )
            : CupertinoPageTransition(
                primaryRouteAnimation: animation,
                secondaryRouteAnimation: __,
                linearTransition: true,
                child: child,
              ));
  }
}
