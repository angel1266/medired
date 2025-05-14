import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medired/core/router/router.dart';
import 'package:medired/core/utils/responsive.dart';
import 'package:medired/features/authentication/authentication_export.dart';
import 'package:medired/ui/molecules/icon_tab.dart';
import 'package:medired/ui/template/system_template.dart';
import 'package:medired/ui/views/payment_subscription_page.dart';
import 'package:universal_html/html.dart' as html;

class SystemPage extends StatefulWidget {
  const SystemPage({super.key, required this.child});

  final Widget child;

  @override
  State<SystemPage> createState() => _SystemPageState();
}

class _SystemPageState extends State<SystemPage> {
  int _currentTab = 0;

  sendPyme() async {
    var patient =
        (context.read<AuthBloc>().state as AuthenticatedState<Patient>).user;
    var result = await showAdaptiveSheet(
        context: context,
        body: PaymentSubscriptionPage(auth: patient),
        bottomSheetHeight: 0.8);
    if (result) {
      // Reload the flutter web page
      await Future.delayed(const Duration(seconds: 3));
      html.window.location.reload();
    }
  }

  List<_IconBuilder> list(BuildContext context, AuthState state) => [
        _IconBuilder(
          'Mi perfil',
          icon: Icons.person,
          onPressed: () => setState(() {
            _currentTab = 0;
            context.go(RoutePath.profile);
          }),
        ),
        _IconBuilder(
          'Mis servicios',
          icon: Icons.medical_services,
          onPressed: () => setState(() {
            _currentTab = 1;
            context.go(RoutePath.appointments);
          }),
        ),
        if (!(state is AuthenticatedState<Patient>))
          _IconBuilder(
            'Usuario',
            icon: Icons.supervised_user_circle_outlined,
            onPressed: () => setState(() {
              _currentTab = 2;
              context.go(RoutePath.users);
            }),
          ),
        if (state is AuthenticatedState<Patient>)
          _IconBuilder('Pagos', icon: Icons.payment, onPressed: () async {
            sendPyme(); 
          }),
        if (state is AuthenticatedState<ARS>)
          _IconBuilder(
            'Carga masiva',
            icon: Icons.group_add,
            onPressed: () => setState(() {
              _currentTab = 2;
            }),
          ),
      ];

  @override
  Widget build(BuildContext context) {
    // BlocListener<ProfileBloc, ProfileState>(
    //   listener: _profileListener,
    // ),
    // BlocListener<AuthBloc, AuthState>(
    //   listener: _authListener,
    //   listenWhen: (previous, current) =>
    //       previous is! AuthenticatedState && current is! AuthenticatedState,
    // ),
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return SystemTemplate(
          currentIndex: _currentTab,
          iconTabs: list(context, state)
              .mapIndexed((i, e) => IconTab(
                    e.title,
                    icon: e.icon,
                    isCurrent: i == _currentTab,
                    onTap: e.onPressed,
                  ))
              .toList(),
          items: list(context, state)
              .mapIndexed((i, e) => BottomNavigationBarItem(
                    backgroundColor: Colors.grey,
                    icon: Icon(e.icon),
                    label: e.title,
                  ))
              .toList(),
          body: widget.child,
          onTabTapped: (index) => setState(() {
            _currentTab = index;
            switch (_currentTab) {
              case 0:
                context.go(RoutePath.profile);
                break;
              case 1:
                context.go(RoutePath.appointments);
                break;
              case 2:
               (state is AuthenticatedState<Patient>) ? sendPyme() :  context.go(RoutePath.users);
                break;
              default:
                context.go(RoutePath.profile);
                break;
            }
          }),
        );
      },
    );
  }
}

class _IconBuilder {
  final String title;
  final IconData icon;
  final void Function()? onPressed;

  _IconBuilder(
    this.title, {
    required this.icon,
    required this.onPressed,
  });
}
