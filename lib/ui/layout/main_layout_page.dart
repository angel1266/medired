import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medired/core/bloc/message/message_bloc.dart';
import 'package:medired/ui/shared/custom_app_menu.dart';
import 'package:medired/ui/shared/drawer.dart';

class MainLayoutPage extends StatelessWidget {
  final Widget child;
  const MainLayoutPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      extendBodyBehindAppBar: false,
      key: scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppMenu(scaffoldKey: scaffoldKey),
      ),
      drawer: Drawer(
        child: DrawerContent(scaffoldKey: scaffoldKey),
      ),
      body: BlocListener<MessageBloc, MessageState>(
        listener: _messageListener,
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xffe7f0f4),
            /*image: DecorationImage(
              image: AssetImage('assets/images/fondo.png'),
              fit: BoxFit.cover,
            ),*/
          ),
          child: child,
        ),
      ),
    );
  }

  void _messageListener(BuildContext context, MessageState state) {
    if (state is DisplayedMessageState) {
      var displayWidth = MediaQuery.of(context).size.width;
      if (displayWidth >= 910) {
        var margin = displayWidth - 500;
        SnackBar snackBar = SnackBar(
            content: Text(state.message),
            backgroundColor: state.color,
            dismissDirection: DismissDirection.startToEnd,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height - 150,
                left: margin,
                right: 10),
            action: state.action != null
                ? SnackBarAction(
                    textColor: Colors.yellow,
                    label: state.action!.key,
                    onPressed: state.action!.value)
                : null,
            duration: const Duration(seconds: 5));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(state.message, overflow: TextOverflow.ellipsis),
          backgroundColor: state.color,
          action: state.action != null
              ? SnackBarAction(
                  label: state.action!.key,
                  onPressed: state.action!.value,
                  textColor: Colors.yellow)
              : null,
        ));
      }
    }
  }
}
