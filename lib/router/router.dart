import 'package:fluro/fluro.dart';
import 'package:medired/router/route_generator.dart';
import 'package:medired/router/route_handlers.dart';

class Flurorouter {
  static final FluroRouter router = FluroRouter();

  static void configureRoutes() {
    router.define(RouteGenerator.defaultPage,
        handler: defaultPageHandler, transitionType: TransitionType.fadeIn);
    router.define(RouteGenerator.provedoresPage,
        handler: provedoresHandler, transitionType: TransitionType.fadeIn);

    // Stateful Rotues
    router.define(RouteGenerator.subscriptionPage,
        handler: membresiasHandler, transitionType: TransitionType.fadeIn);
    router.define(RouteGenerator.subscription2Page,
        handler: membresias2Handler, transitionType: TransitionType.fadeIn);
    // Provider Routes
    router.define(RouteGenerator.loginPage,
        handler: loginHandler, transitionType: TransitionType.fadeIn);
    router.define(RouteGenerator.loginAdminPage,
        handler: loginAdminHandler, transitionType: TransitionType.fadeIn);
    router.define(RouteGenerator.contactoPage,
        handler: contactoHandler, transitionType: TransitionType.fadeIn);
    router.define(RouteGenerator.planesPage,
        handler: planesHandler, transitionType: TransitionType.fadeIn);

    router.define(RouteGenerator.resetPasswordPage,
        handler: forgotHandler, transitionType: TransitionType.fadeIn);
    router.define(RouteGenerator.signUpPage,
        handler: registerHandler, transitionType: TransitionType.fadeIn);
    router.define(RouteGenerator.servicesPage,
        handler: serviciosHandler, transitionType: TransitionType.fadeIn);
    router.define(RouteGenerator.solicitudesPage,
        handler: solicitudesHandler, transitionType: TransitionType.fadeIn);

    router.define(RouteGenerator.solicitudpacientePage,
        handler: solicitudpacienteHandler,
        transitionType: TransitionType.fadeIn);

    // router.define(RouteGenerator.systemPage,
    //     handler: systemHandler, transitionType: TransitionType.fadeIn);
    // 404 - Not Page Found
    router.notFoundHandler = pageNotFound;
  }
}
