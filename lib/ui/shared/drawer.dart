import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medired/core/router/router.dart';
import 'package:medired/core/utils/responsive.dart';
import 'package:medired/features/authentication/authentication_export.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/shared/custom_app_menu.dart';
import 'package:medired/ui/shared/custom_flat_button.dart';
import 'package:medired/ui/views/payment_subscription_page.dart';
import 'package:universal_html/html.dart' as html;

class DrawerContent extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  DrawerContent({super.key, required this.scaffoldKey});

  @override
  createState() => _DrawerContentState(scaffoldKey: scaffoldKey);
}

class _DrawerContentState extends State<DrawerContent> {
  _DrawerContentState({required this.scaffoldKey});

  final GlobalKey<ScaffoldState> scaffoldKey;
  final ValueNotifier<String> currentRoute =
      ValueNotifier<String>('${router.routeInformationProvider.value.uri}');
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.blueBackground,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Image(
                  image: AssetImage('assets/images/logob.png'),
                  width: 300,
                  height: 69,
                ),
                const SizedBox(height: 20),
                /* buildDrawerButton('Membresía', RoutePath.membership),*/

                BlocConsumer<AuthBloc, AuthState>(
                  listener: _authListener,
                  listenWhen: (previous, current) =>
                      (previous is AuthenticatedState &&
                          current is AuthenticatedState &&
                          previous.user == current.user) ||
                      (previous is SuccessAuthState &&
                          current is AuthenticatedState) ||
                      (previous is AuthenticatedState &&
                          current is SuccessAuthState),
                  builder: (context, state) {
                    if (state is AuthenticatedState) {
                      if (currentRoute.value == RoutePath.users ||
                          currentRoute.value == RoutePath.profile ||
                          currentRoute.value == RoutePath.appointments) {
                        return ValueListenableBuilder<String>(
                          valueListenable: currentRoute,
                          builder: (context, value, child) {
                            if (!mounted) return const SizedBox.shrink();
                            return Column(children: [
                         
                          buildDrawerButton('Inicio', () {
                            html.window.location.href = "/";
                          }),
                          buildDrawerButton('Servicios', () {
                            html.window.location.href = "/#/servicios";
                          }),
                          buildDrawerButton('Prestadores', () {
                            html.window.location.href = "/#/prestadores";
                          }),
                          buildDrawerButton('Quieres ser Prestador', () {
                            html.window.location.href = "/#/providers";
                          }),
                          buildDrawerButton('Contáctanos', () {
                            html.window.location.href = "/#/contact";
                          }),
                          SizedBox(
                            height: 30,
                          ),
                            ]);
                          },
                        );
                      } else {
                        return Column(
                          children: [
                            buildDrawerButton('Inicio', () {
                              html.window.location.href = "/";
                            }),
                            buildDrawerButton('Servicios', () {
                              html.window.location.href = "/#/servicios";
                            }),
                            buildDrawerButton('Prestadores', () {
                              html.window.location.href = "/#/prestadores";
                            }),
                            buildDrawerButton('Quieres ser Prestador', () {
                              html.window.location.href = "/#/providers";
                            }),
                            buildDrawerButton('Contáctanos', () {
                              html.window.location.href = "/#/contact";
                            }),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        );
                      }
                    } else {
                      return Column(
                        children: [
                          buildDrawerButton('Inicio', () {
                            html.window.location.href = "/";
                          }),
                          buildDrawerButton('Servicios', () {
                            html.window.location.href = "/#/servicios";
                          }),
                          buildDrawerButton('Prestadores', () {
                            html.window.location.href = "/#/prestadores";
                          }),
                          buildDrawerButton('Quieres ser Prestador', () {
                            html.window.location.href = "/#/providers";
                          }),
                          buildDrawerButton('Contáctanos', () {
                            html.window.location.href = "/#/contact";
                          }),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      );
                    }
                  },
                ),
                BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                  if (state is AuthenticatedState) {
                    if (currentRoute.value == RoutePath.users ||
                        currentRoute.value == RoutePath.profile ||
                        currentRoute.value == RoutePath.appointments) {
                      return Column(
                        children: [
                          buildDrawerButton2('Cerrar Sesión', () {
                            scaffoldKey.currentState?.closeDrawer();
                            context
                                .read<AuthBloc>()
                                .add(LogOut(auth: state.user));
                            deleteCollection().then((_) {
                              html.window.location.href = "/";
                            });
                          },
                              textColor: AppColors.whiteBackground,
                              buttonColor: AppColors.greenBackground),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          buildDrawerButton2('Mi Perfil', () {
                            scaffoldKey.currentState?.closeDrawer();
                            html.window.location.href = "/#/system/profile";
                          },
                              textColor: AppColors.whiteBackground,
                              buttonColor: AppColors.greenBackground),
                        ],
                      );
                    }
                  } else {
                    return Column(
                      children: [
                        buildDrawerButton('Registrarse', () {
                          html.window.location.href = "/#/sign-up";
                        },
                            textColor: AppColors.whiteBackground,
                            buttonColor: AppColors.greenBackground),
                        buildDrawerButton('Iniciar sesión', () {
                          html.window.location.href = "/#/login";
                        }),
                      ],
                    );
                  }
                })
              ],
            ),
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

  Widget buildDrawerButton2(String text, Function onPressed,
      {Color? textColor, Color? buttonColor}) {
    return CustomFlatButton(
      text: text,
      onPressed: () {
        scaffoldKey.currentState?.closeDrawer();
        onPressed();
      },
      textColor: textColor ?? Colors.white,
      buttonColor: buttonColor ?? Colors.transparent,
      horizontalPadding: 36,
      verticalPadding: 7,
    );
  }

  Widget buildDrawerButton(String text, Function send,
      {Color? textColor, Color? buttonColor}) {
    return CustomFlatButton(
      text: text,
      onPressed: () {
        scaffoldKey.currentState?.closeDrawer();
        send();
      },
      textColor: textColor ?? Colors.white,
      buttonColor: buttonColor ?? Colors.transparent,
      horizontalPadding: 36,
      verticalPadding: 7,
    );
  }
}
