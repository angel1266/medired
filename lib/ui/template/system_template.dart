import 'package:flutter/material.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/molecules/icon_tab.dart';
import 'package:medired/ui/organisms/top_navigation_bar.dart';

class SystemTemplate extends StatelessWidget {
  const SystemTemplate({
    required this.currentIndex,
    required this.iconTabs,
    required this.items,
    required this.body,
    required this.onTabTapped,
    super.key,
  });

  final int currentIndex;
  final List<IconTab> iconTabs;
  final List<BottomNavigationBarItem> items;
  final Widget body;
  final ValueChanged<int> onTabTapped;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: constraints.maxWidth > 768
              ? TopNavigationBar(
                  currentIndex: currentIndex,
                  iconTab: iconTabs,
                )
              : null,
          body: body,
          bottomNavigationBar: (constraints.maxWidth <= 768)
              ? BottomNavigationBar(
                  backgroundColor: AppColors.lightBackground,
                  currentIndex: currentIndex,
                  items: items,
                  onTap: onTabTapped,
                )
              : null,
        );
      },
    );
  }
}
