import 'package:flutter/widgets.dart';

class BaseDesktopTemplate extends StatelessWidget {
  const BaseDesktopTemplate({
    required this.left,
    required this.right,
    this.leftFlex = 4,
    this.rightFlex = 4,
    super.key,
  });

  final int leftFlex;
  final Widget left;
  final int rightFlex;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(flex: 1, child: SizedBox.shrink()),
        Expanded(flex: leftFlex, child: left),
        const Expanded(flex: 1, child: SizedBox.shrink()),
        Expanded(flex: rightFlex, child: right),
        const Expanded(flex: 1, child: SizedBox.shrink()),
      ],
    );
  }
}
