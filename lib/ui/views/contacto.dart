import 'package:flutter/material.dart';
import 'package:medired/ui/shared/contacto_view.dart';
import 'package:medired/ui/shared/footer.dart';

class Contacto extends StatelessWidget {
  const Contacto({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: TheFooter(child: ContacView()),
    );
  }
}
