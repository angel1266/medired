import 'package:flutter/material.dart';
import 'package:medired/ui/constants/app_colors.dart';

class CreateAppointmentTemplate extends StatelessWidget {
  const CreateAppointmentTemplate({
    super.key,
    required this.left,
    required this.right,
    this.leftFlex = 1,
    this.rightFlex = 1,
  });

  final int leftFlex;
  final Widget left;
  final int rightFlex;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 768) {
          return Container(
            color: AppColors.blueBackground,
            child: Row(
              children: [
                const Expanded(flex: 1, child: SizedBox.shrink()),
                Expanded(flex: leftFlex, child: left),
                const Expanded(flex: 1, child: SizedBox.shrink()),
                Expanded(flex: rightFlex, child: right),
                const Expanded(flex: 1, child: SizedBox.shrink()),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
