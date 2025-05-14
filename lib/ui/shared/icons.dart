import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medired/ui/constants/ui_helper.dart';

class SocialMediaIcons {
  static const IconData facebook = Icons.facebook;
  // static const IconData twitter = FontAwesomeIcons.twitter;
  static const IconData instagram = FontAwesomeIcons.instagram;
  // static const IconData youtube = FontAwesomeIcons.youtube;
  static const IconData linkedin = FontAwesomeIcons.linkedin;

  static const List<dynamic> all = [
    [facebook,"https://www.facebook.com/profile.php?id=61571564860800"],
    // twitter,
    [instagram,"https://www.instagram.com/mediredrd/"],
    // youtube,
    [linkedin,"https://www.linkedin.com/company/mediredrd/about/"]
  ];

  static Color getColor(IconData icon) {
    if (icon == facebook) return const Color(0xFF94a10c);
    // if (icon == twitter) return const Color(0xFF94a10c);
    if (icon == instagram) return const Color(0xFF94a10c);
    // if (icon == youtube) return const Color(0xFF94a10c);
    if (icon == linkedin) return const Color(0xFF94a10c);
    return Colors.black; // Default color if not specified
  }
}

class SocialMediaIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double iconSize; // Nuevo parámetro para el tamaño del icono

  const SocialMediaIconButton({
    required this.icon,
    required this.onPressed,
    this.iconSize = 24.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool device = context.screenType() == ScreenType.desktop;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: device ? 8 : 4),
      child: IconButton(
        icon: Icon(
          icon,
          color: SocialMediaIcons.getColor(icon),
          size: iconSize, // Asigna el tamaño del icono
        ),
        onPressed: onPressed,
      ),
    );
  }
}
