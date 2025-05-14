import 'package:flutter/material.dart';
import 'package:medired/core/router/router.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/shared/custom_flat_button.dart';
import 'package:medired/ui/shared/footer.dart';

class View404 extends StatelessWidget {
  const View404({super.key});

  @override
  Widget build(BuildContext context) {
    return TheFooter(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage('assets/images/logo.png'),
                // width: 300,
                //height: 69,
              ),
              CustomFlatButton(
                  buttonColor: AppColors.blueBackground,
                  text: 'Regresar',
                  onPressed: () => router.push(RoutePath.home)),
            ],
          ),
        ),
      ),
    );
  }
}
