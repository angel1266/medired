import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:medired/ui/molecules/icon_tab.dart';

class TopNavigationBar extends StatelessWidget implements PreferredSizeWidget {
  const TopNavigationBar({
    required this.iconTab,
    this.currentIndex = 0,
    this.preferredSize = const Size.fromHeight(120.0),
    super.key,
  });

  @override
  final Size preferredSize;

  final int currentIndex;
  final List<IconTab> iconTab;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: SizedBox.shrink()),
        ...iconTab
            .mapIndexed((i, e) => e.copyWith(isCurrent: i == currentIndex)),
        const Expanded(child: SizedBox.shrink()),
      ],
    );
  }
}
