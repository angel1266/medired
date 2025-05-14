import 'package:flutter/material.dart';
import 'package:medired/ui/shared/footer.dart';
import 'package:medired/ui/shared/main_servicios_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainServiciosPage extends StatelessWidget {
  const MainServiciosPage({super.key, this.id = ""});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TheFooter(
        child: Container(
          padding: const EdgeInsets.only(top: 0),
          child: MainServiciosView(id: id),
        ),
      ),
    );
  }
}
