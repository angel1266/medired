import 'package:flutter/material.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/template/base_desktop_template.dart';
import 'package:medired/ui/template/base_mobile_template.dart';

class ProfileTemplate extends StatelessWidget {
  const ProfileTemplate({
    required this.profilePicture,
    required this.personalInfoForm,
    required this.editableInfoForm,
    required this.tarjeta,
    this.backgroundColor,
    this.floatingActionButton,
    super.key,
  });

  final Widget tarjeta;
  final Widget profilePicture;
  final Widget personalInfoForm;
  final Widget editableInfoForm;
  final Color? backgroundColor;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          backgroundColor: backgroundColor,
          floatingActionButton: floatingActionButton,
          body: constraints.maxWidth > 768
              ? BaseDesktopTemplate(left: left(), right: right())
              : BaseMobileTemplate(
                  left: left(),
                  right: Center(child: right()),
                  tabs: const [
                    Tab(
                      child: Text(
                        'Mi perfil',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Más información',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget left() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 8),
          profilePicture,
          const SizedBox(height: 8),
          tarjeta,
          const SizedBox(height: 8),
          personalInfoForm,
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget right() {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.lightBorder.withOpacity(0.6),
        ),
        padding: const EdgeInsets.all(24),
        child: editableInfoForm,
      ),
    );
  }
}
