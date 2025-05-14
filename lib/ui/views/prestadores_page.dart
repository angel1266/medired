import 'package:flutter/material.dart';
import 'package:medired/ui/shared/footer.dart';
import 'package:medired/ui/shared/prestadores_view.dart';

class PrestadoresPage extends StatelessWidget {
  const PrestadoresPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TheFooter(
        child: Container(
          padding: const EdgeInsets.only(top: 0),
          child: const PrestadoresView(),
        ),
      ),
    );
  }
}
