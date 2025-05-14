import 'package:flutter/material.dart';
import 'package:medired/ui/shared/footer.dart';
import 'package:medired/ui/shared/forgot_page.dart';

class Forgot extends StatelessWidget {
  const Forgot({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TheFooter(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
            child:
                ForgotPage(sizewidth: (MediaQuery.of(context).size.width) - 6),
          ),
        ),
      ),
    );
  }
}
