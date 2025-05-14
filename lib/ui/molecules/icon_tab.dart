import 'package:flutter/material.dart';
import 'package:medired/ui/constants/app_colors.dart';

class IconTab extends StatelessWidget {
  const IconTab(
    this.title, {
    required this.icon,
    required this.isCurrent,
    this.onTap,
    super.key,
  });
  final String title;
  final IconData icon;
  final bool isCurrent;
  final void Function()? onTap;

  IconTab copyWith({
    IconData? icon,
    bool? isCurrent,
    void Function()? onTap,
  }) {
    return IconTab(
      title,
      icon: icon ?? this.icon,
      isCurrent: isCurrent ?? this.isCurrent,
      onTap: onTap ?? this.onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: isCurrent ? AppColors.greenBackground : Colors.grey,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 4), // Adjust padding as needed
              decoration: BoxDecoration(
                color: isCurrent
                    ? AppColors.greenBackground
                    : Colors.grey, // Background color for the label
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
              child: Text(
                title,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
