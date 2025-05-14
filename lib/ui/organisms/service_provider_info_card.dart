import 'package:flutter/material.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/shared/custom_time.dart';
import 'package:medired/ui/template/base_desktop_template.dart';

class ServiceProviderInfoCard extends StatelessWidget {
  const ServiceProviderInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.lightBorder.withOpacity(0.6),
      ),
      padding: const EdgeInsets.all(24),
      child: BaseDesktopTemplate(
        left: const SizedBox.shrink(),
        // left: const ServiceProviderCard(
        //   medicalSpecialization: 'Medico',
        //   name: 'Juan Perez',
        // ),
        right: Container(
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(15),
            //   color: AppColors.lightBackground,
            // ),
            // padding: const EdgeInsets.all(24),
            // child: const CustomScheduleWidget(),
            ),
        leftFlex: 3,
        rightFlex: 7,
      ),
    );
  }
}
