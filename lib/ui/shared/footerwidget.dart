import 'package:flutter/material.dart';
import 'package:medired/core/router/router.dart';
import 'package:url_launcher/url_launcher.dart';

class MySectionWidget extends StatelessWidget {
  final int index;
  final Widget child;
  final String id;

  const MySectionWidget({super.key, required this.index, required this.child, required this.id});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: () {
          router.push("/servicios/");
          
        },
        child: child,
      ),
    );
  }
}

class MySection1Widget extends StatelessWidget {
  final String page;
  final Widget child;

  const MySection1Widget({super.key, required this.page, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: () => page == '/documents/Terminos%20y%20Condiciones.pdf' || page ==  '/documents/politicasdeprivacidad.pdf' ? _launchUrl(Uri.parse(page))  : router.push(page),
        child: child,
      ),
    );
  }

  Future<void> _launchUrl(_url) async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}
}