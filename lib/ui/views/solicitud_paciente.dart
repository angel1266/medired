import 'package:flutter/material.dart';
import 'package:medired/ui/shared/footer.dart';
import 'package:medired/ui/shared/solicitud_paciente_widget.dart';

class Solicitudpage extends StatelessWidget {
  const Solicitudpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TheFooter(
        child: Container(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.07),
          child: const Solicitudpaciente(),
        ),
      ),
    );
  }
}
