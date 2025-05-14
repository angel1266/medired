import 'package:flutter/material.dart';
import 'package:medired/core/router/router.dart';

class HaveAnAccountButton extends StatelessWidget {
  const HaveAnAccountButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          '¿Tienes una cuenta?',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        TextButton(
          onPressed: () => router.go(RoutePath.login),
          child: const Text(
            'Ingresa aquí',
            style: TextStyle(
                color: Color.fromRGBO(95, 125, 201, 1),
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
