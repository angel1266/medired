import 'package:flutter/material.dart';
import 'package:medired/ui/shared/footer.dart';
import 'package:medired/ui/shared/provedores_view.dart';

class Provedores extends StatelessWidget {
  const Provedores({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TheFooter(
        child: Container(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.07),
          child: const ProvedoresView(),
        ),
      ),
    );
  }
}
