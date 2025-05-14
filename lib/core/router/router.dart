import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medired/features/appointments/presentation/bloc/appointments_bloc.dart';
import 'package:medired/features/authentication/presentation/bloc/auth_info/auth_info_bloc.dart';
import 'package:medired/features/authentication/presentation/bloc/base_info/base_info_bloc.dart';
import 'package:medired/features/authentication/presentation/bloc/medical_tests/medical_tests_bloc.dart';
import 'package:medired/features/authentication/presentation/bloc/sign_up/sign_up_bloc.dart';
import 'package:medired/features/payment/presentation/bloc/payment_bloc.dart';
import 'package:medired/features/payments/presentation/bloc/payments_bloc.dart';
import 'package:medired/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:medired/core/router/router_transition_factory.dart';
import 'package:medired/core/router/transition_type.dart';
import 'package:medired/features/single_appointment/presentation/bloc/single_appointment_bloc.dart';
import 'package:medired/features/subscription/presentation/bloc/subscription_bloc.dart';
import 'package:medired/services/locator.dart';
import 'package:medired/ui/layout/main_layout_page.dart';
import 'package:medired/ui/views/appointments_page.dart';
import 'package:medired/ui/views/contacto.dart';
import 'package:medired/ui/views/create_appointment_page.dart';
import 'package:medired/ui/views/home_page.dart';
import 'package:medired/ui/views/login_page.dart';
import 'package:medired/ui/views/main_servicios_page.dart';
import 'package:medired/ui/views/membership.dart';
import 'package:medired/ui/views/prestadores_page.dart';
import 'package:medired/ui/views/profile_page.dart';
import 'package:medired/ui/views/provedores.dart';
import 'package:medired/ui/views/recover_password.dart';
import 'package:medired/ui/views/register_page.dart';
import 'package:medired/ui/views/system_page.dart';
import 'package:medired/ui/views/users_page.dart';
import 'package:medired/ui/views/website_page.dart';

part 'routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _mainPageNavigatorKey = GlobalKey<NavigatorState>();
final _websiteNavigatorKey = GlobalKey<NavigatorState>();
final _systemNavigatorKey = GlobalKey<NavigatorState>();

final router =
    GoRouter(initialLocation: '/', navigatorKey: _rootNavigatorKey, routes: [
  ShellRoute(
      navigatorKey: _mainPageNavigatorKey,
      builder: (context, state, child) => MainLayoutPage(child: child),
      routes: [
        /// Website
        ShellRoute(
          parentNavigatorKey: _mainPageNavigatorKey,
          navigatorKey: _websiteNavigatorKey,
          builder: (context, state, child) => WebsitePage(child: child),
          routes: [
            /// Login
            GoRoute(
              parentNavigatorKey: _websiteNavigatorKey,
              path: RoutePath.login,
              pageBuilder: (context, state) =>
                  RouterTransitionFactory.getTransitionPage(
                context: context,
                state: state,
                type: TransitionType.fade,
                child: const LoginPage(),
              ),
            ),
            GoRoute(
              parentNavigatorKey: _websiteNavigatorKey,
              path: RoutePath.prestadores,
              pageBuilder: (context, state) =>
                  RouterTransitionFactory.getTransitionPage(
                context: context,
                state: state,
                type: TransitionType.fade,
                child: const PrestadoresPage(),
              ),
            ),
            GoRoute(
              parentNavigatorKey: _websiteNavigatorKey,
              path: RoutePath.servicios,
              pageBuilder: (context, state) =>
                  RouterTransitionFactory.getTransitionPage(
                context: context,
                state: state,
                type: TransitionType.fade,
                child: const MainServiciosPage(),
              ),
            ),
            GoRoute(
              parentNavigatorKey: _websiteNavigatorKey,
              path: RoutePath.signUp,
              pageBuilder: (context, state) =>
                  RouterTransitionFactory.getTransitionPage(
                context: context,
                state: state,
                type: TransitionType.fade,
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider<SignUpBloc>(
                      create: (context) => SignUpBloc(sl(), sl()),
                    ),
                    BlocProvider(
                      create: (context) => SubscriptionBloc(
                          sl(), sl(), sl(), sl(), sl(), sl(), sl()),
                    ),
                    BlocProvider(
                      create: (context) => BaseInfoBloc(),
                    ),
                    BlocProvider(
                      create: (context) => AuthInfoBloc(),
                    ),
                    BlocProvider(
                      create: (context) =>
                          MedicalTestsBloc(sl())..add(GetMedicalTests()),
                    ),
                    BlocProvider(
                      create: (context) => PaymentsBloc(sl(), sl(), sl()),
                    ),
                    BlocProvider(
                      create: (context) =>
                          ProfileBloc(sl(), sl(), sl(), sl(), sl()),
                    ),
                  ],
                  child: const RegisterPage(),
                ),
              ),
            ),
            GoRoute(
              parentNavigatorKey: _websiteNavigatorKey,
              path: RoutePath.forgotPassword,
              pageBuilder: (context, state) =>
                  RouterTransitionFactory.getTransitionPage(
                context: context,
                state: state,
                type: TransitionType.fade,
                child: const Forgot(),
              ),
            ),

            /// Landing page
            GoRoute(
              parentNavigatorKey: _websiteNavigatorKey,
              path: RoutePath.membership,
              pageBuilder: (context, state) =>
                  RouterTransitionFactory.getTransitionPage(
                context: context,
                state: state,
                type: TransitionType.fade,
                child: const Membresias(),
              ),
            ),
            GoRoute(
              parentNavigatorKey: _websiteNavigatorKey,
              path: RoutePath.home,
              pageBuilder: (context, state) =>
                  RouterTransitionFactory.getTransitionPage(
                context: context,
                state: state,
                type: TransitionType.fade,
                child: const Home(),
              ),
            ),
            GoRoute(
              parentNavigatorKey: _websiteNavigatorKey,
              path: RoutePath.contact,
              pageBuilder: (context, state) =>
                  RouterTransitionFactory.getTransitionPage(
                context: context,
                state: state,
                type: TransitionType.fade,
                child: const Contacto(),
              ),
            ),
            GoRoute(
              parentNavigatorKey: _websiteNavigatorKey,
              path: RoutePath.providers,
              pageBuilder: (context, state) =>
                  RouterTransitionFactory.getTransitionPage(
                context: context,
                state: state,
                type: TransitionType.fade,
                child: const Provedores(),
              ),
            ),
          ],
        ),

        /// System
        ShellRoute(
          parentNavigatorKey: _mainPageNavigatorKey,
          navigatorKey: _systemNavigatorKey,
          pageBuilder: (context, state, child) =>
              RouterTransitionFactory.getTransitionPage(
            context: context,
            state: state,
            type: TransitionType.fade,
            child: SystemPage(child: child),
          ),
          routes: [
            GoRoute(
              parentNavigatorKey: _systemNavigatorKey,
              // navigatorKey: _appointmentsNavigatorKey,
              path: RoutePath.appointments,
              builder: (_, __) => BlocProvider(
                create: (context) => AppointmentsBloc(sl(), sl(), sl(), sl()),
                child: const AppointmentsPage(),
              ),
            ),
            GoRoute(
              parentNavigatorKey: _systemNavigatorKey,
              path: RoutePath.profile,
              builder: (_, __) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) =>
                        ProfileBloc(sl(), sl(), sl(), sl(), sl()),
                  ),
                  BlocProvider<SubscriptionBloc>(
                      create: (context) => SubscriptionBloc(
                          sl(), sl(), sl(), sl(), sl(), sl(), sl())),
                ],
                child: const ProfilePage(),
              ),
            ),
             GoRoute(
              parentNavigatorKey: _systemNavigatorKey,
              path: RoutePath.users,
              builder: (_, __) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) =>
                        ProfileBloc(sl(), sl(), sl(), sl(), sl()),
                  ),
                  BlocProvider<SubscriptionBloc>(
                      create: (context) => SubscriptionBloc(
                          sl(), sl(), sl(), sl(), sl(), sl(), sl())),
                ],
                child: const UserPage(),
              ),
            ),
            // GoRoute(
            //   parentNavigatorKey: _systemNavigatorKey,
            //   path: RoutePath.payments,
            //   builder: (_, state) {
            //     var extra = state.extra as Map<String, dynamic>;
            //     return MultiBlocProvider(
            //       providers: [
            //         BlocProvider<SubscriptionBloc>(
            //             create: (context) => SubscriptionBloc(
            //                 sl(), sl(), sl(), sl(), sl(), sl(), sl())),
            //         BlocProvider(
            //           create: (context) => PaymentBloc(
            //               sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()),
            //         ),
            //         BlocProvider(
            //           create: (context) => PaymentsBloc(sl(), sl(), sl()),
            //         ),
            //       ],
            //       child: Container(),
            //     );
            //   },
            // ),
            // Appointments
            GoRoute(
              parentNavigatorKey: _systemNavigatorKey,
              path: RoutePath.createAppointment,
              builder: (_, __) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => SingleAppointmentBloc(sl(), sl(), sl())
                      ..add(const UpdateServiceType(serviceType: null)),
                  ),
                  BlocProvider(
                    create: (context) => SubscriptionBloc(
                        sl(), sl(), sl(), sl(), sl(), sl(), sl()),
                  ),
                  BlocProvider(
                    create: (context) => PaymentBloc(
                        sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()),
                  ),
                ],
                child: const CreateAppointmentPage(),
              ),
            ),
          ],
        ),
      ]),
]);
