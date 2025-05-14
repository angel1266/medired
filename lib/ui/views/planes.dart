import 'package:flutter/material.dart';
import 'package:medired/ui/shared/footer.dart';
import 'package:medired/ui/shared/planes.dart';

class Planes extends StatelessWidget {
  const Planes({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: TheFooter(child: PlanesView()),
    );
  }
}
