import 'package:flutter/material.dart';
import 'package:medired/ui/shared/footer.dart';
import 'package:medired/ui/shared/solicitudes_view.dart';

class Solicitudes extends StatelessWidget {
  const Solicitudes({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
                Radius.circular(MediaQuery.of(context).size.width * 0.01))),
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.07),
        child: const TheFooter(child: Solicitudesview()),
      ),
    );
  }
}
