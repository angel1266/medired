import 'package:flutter/material.dart';
import 'package:medired/ui/shared/footer.dart';
import 'package:medired/ui/shared/home_view.dart';

class Home extends StatelessWidget {
  const Home({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TheFooter(
        child: Container(
          padding: const EdgeInsets.only(top: 0),
          child: const Homeview(),
        ),
      ),
    );
  }
}
