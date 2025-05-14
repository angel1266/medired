import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medired/core/router/router.dart';
import 'package:medired/core/utils/responsive.dart';
import 'package:medired/features/authentication/authentication_export.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/molecules/custom_flex.dart';
import 'package:medired/ui/views/payment_subscription_page.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:sembast/sembast.dart';
import 'package:universal_html/html.dart' as html;

final databaseFactory = databaseFactoryWeb;
Database? db;

Future<void> openDatabase() async {
  db = await databaseFactory.openDatabase('local.db');
}

Future<void> deleteCollection() async {
  if (db == null) {
    await openDatabase();
  }
  final store = intMapStoreFactory.store('authentication');
  await store.delete(db!);
}

class CustomAppMenu extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomAppMenu({required this.scaffoldKey, super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => (constraints.maxWidth > 1200)
          ? _TabletDesktopMenu()
          : _MobileMenu(scaffoldKey: scaffoldKey),
    );
  }
}

class _TabletDesktopMenu extends StatefulWidget {
  @override
  State<_TabletDesktopMenu> createState() => _TableDesktopMenuState();
}

class _TableDesktopMenuState extends State<_TabletDesktopMenu> {
  final ValueNotifier<String> currentRoute =
      ValueNotifier<String>('${router.routeInformationProvider.value.uri}');
  bool homeLink = false;
  String? _selectedItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        color: Color(0XFFe7f0f4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => homeLink ? router.push(RoutePath.home) : null,
              child: Image(
                image: const AssetImage('assets/images/logo.png'),
                width: MediaQuery.of(context).size.width * 0.16,
                height: 69,
              ),
            ),
          ),
          const Spacer(),
          /* _appBarButton(
            'Inicio',
            onPressed: () => router.go(RoutePath.home),
          ),
          _appBarButton(
            'Servicios',
            onPressed: () => router.go(RoutePath.servicios),
          ),
          _appBarButton(
            'Prestadores',
            onPressed: () => html.window.location.href = "/#/servicios",
          ),
          _appBarButton(
            'Quieres ser prestador',
            onPressed: () => router.go(RoutePath.providers),
          ),
          _appBarButton(
            'Contáctanos',
            onPressed: () => router.go(RoutePath.contact),
          ),*/
          BlocConsumer<AuthBloc, AuthState>(
            listener: _authListener,
            listenWhen: (previous, current) =>
                (previous is AuthenticatedState &&
                    current is AuthenticatedState &&
                    previous.user == current.user) ||
                (previous is SuccessAuthState &&
                    current is AuthenticatedState) ||
                (previous is AuthenticatedState && current is SuccessAuthState),
            builder: (context, state) {
              if (state is AuthenticatedState) {
                homeLink = false;
                return ValueListenableBuilder<String>(
                  valueListenable: currentRoute,
                  builder: (context, value, child) {
                    if (!mounted) return const SizedBox.shrink();
                    if (currentRoute.value == RoutePath.users ||
                        currentRoute.value == RoutePath.profile ||
                        currentRoute.value == RoutePath.appointments) {
                      return Row(children: [
                        _appBarButton(
                          'Inicio',
                          onPressed: () => html.window.location.href = "/",
                        ),
                        _appBarButton(
                          'Servicios',
                          onPressed: () =>
                              html.window.location.href = "/#/servicios",
                        ),
                        _appBarButton(
                          'Prestadores',
                          onPressed: () =>
                              html.window.location.href = "/#/prestadores",
                        ),
                        _appBarButton(
                          'Quieres ser prestador',
                          onPressed: () =>
                              html.window.location.href = "/#/providers",
                        ),
                        _appBarButton(
                          'Contáctanos',
                          onPressed: () =>
                              html.window.location.href = "/#/contact",
                        ),
                      ]);
                    } else {
                      homeLink = true;

                      return Row(
                        children: [
                          _appBarButton(
                            'Inicio',
                            onPressed: () => html.window.location.href = "/",
                          ),
                          _appBarButton(
                            'Servicios',
                            onPressed: () =>
                                html.window.location.href = "/#/servicios",
                          ),
                          _appBarButton(
                            'Prestadores',
                            onPressed: () =>
                                html.window.location.href = "/#/prestadores",
                          ),
                          _appBarButton(
                            'Quieres ser prestador',
                            onPressed: () =>
                                html.window.location.href = "/#/providers",
                          ),
                          _appBarButton(
                            'Contáctanos',
                            onPressed: () =>
                                html.window.location.href = "/#/contact",
                          ),
                        ],
                      );
                    }
                  },
                );
              } else {
                homeLink = true;

                return Row(
                  children: [
                    _appBarButton(
                      'Inicio',
                      onPressed: () => html.window.location.href = "/",
                    ),
                    _appBarButton(
                      'Servicios',
                      onPressed: () =>
                          html.window.location.href = "/#/servicios",
                    ),
                    _appBarButton(
                      'Prestadores',
                      onPressed: () =>
                          html.window.location.href = "/#/prestadores",
                    ),
                    _appBarButton(
                      'Quieres ser prestador',
                      onPressed: () =>
                          html.window.location.href = "/#/providers",
                    ),
                    _appBarButton(
                      'Contáctanos',
                      onPressed: () => html.window.location.href = "/#/contact",
                    ),
                  ],
                );
              }
            },
          ),
          const Expanded(child: SizedBox.shrink()),
          BlocConsumer<AuthBloc, AuthState>(
            listener: _authListener,
            listenWhen: (previous, current) =>
                (previous is AuthenticatedState &&
                    current is AuthenticatedState &&
                    previous.user == current.user) ||
                (previous is SuccessAuthState &&
                    current is AuthenticatedState) ||
                (previous is AuthenticatedState && current is SuccessAuthState),
            builder: (context, state) {
              if (state is AuthenticatedState) {
                return ValueListenableBuilder<String>(
                  valueListenable: currentRoute,
                  builder: (context, value, child) {
                    if (!mounted) return const SizedBox.shrink();
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.greenBackground,
                      ),
                      child: Text(
                        currentRoute.value == RoutePath.profile
                            ? 'Cerrar sesión'
                            : 'Mi Perfil',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.white),
                      ),
                      onPressed: () {
                        if (currentRoute.value == RoutePath.profile) {
                          context
                              .read<AuthBloc>()
                              .add(LogOut(auth: state.user));
                          deleteCollection().then((_) {
                            html.window.location.href = "/";
                          });

                          router.push(RoutePath.login);
                        } else {
                          html.window.location.href = "/#/system/profile";
                        }
                      },
                    );
                  },
                );
              } else {
                return CustomFlex(
                  direction: Axis.horizontal,
                  separation: 10.0,
                  children: [
                    _appBarButton(
                      'Registrarse',
                      onPressed: () => router.go(RoutePath.signUp),
                    ),
                    _appBarButton(
                      'Iniciar sesión',
                      onPressed: () => router.go(RoutePath.login),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _authListener(BuildContext context, AuthState state) {
    if (state is SuccessAuthState && mounted) {
      router.push(RoutePath.login);
    }
  }

  TextButton _appBarButton(
    String title, {
    void Function()? onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}

class _MobileMenu extends StatefulWidget {
  const _MobileMenu({required this.scaffoldKey});
  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  State<_MobileMenu> createState() => _MobileMenuState();
}

class _MobileMenuState extends State<_MobileMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.black,
            ),
            onPressed: () {
              widget.scaffoldKey.currentState?.openDrawer();
            },
          ),
          const Spacer(),
          const Image(
            image: AssetImage('assets/images/logo.png'),
            width: 200,
            height: 46,
          ),
          const Spacer()
        ],
      ),
    );
  }
}
