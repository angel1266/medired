import 'package:flutter/material.dart';
import 'package:medired/ui/constants/app_colors.dart';

class PointsTemplate extends StatelessWidget {
  const PointsTemplate({super.key, required this.body});
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueBackground,
      appBar: AppBar(
        title: const Text('Puntos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: body,
      ),
    );
  }
}
