import 'package:flutter/cupertino.dart';

class CustomFlex extends StatelessWidget {
  const CustomFlex({
    super.key,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline, // NO DEFAULT: we don't know what the text's baseline should be
    this.children = const <Widget>[],
    this.separation = 0,
    required this.direction,
    this.clipBehavior = Clip.none
  });

  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final TextBaseline? textBaseline;
  final List<Widget> children;
  final double separation;
  final Axis direction;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    List<Widget> childrenWithSeparation = children;

    if(separation > 0){
      switch(direction){
        case Axis.horizontal:
          childrenWithSeparation = children.expand((child) => [child, SizedBox(width: separation)]).toList();
        case Axis.vertical:
          childrenWithSeparation = children.expand((child) => [child, SizedBox(height: separation)]).toList();
      }
      if(childrenWithSeparation.isNotEmpty){
        childrenWithSeparation.removeLast();
      }
    }

    return Flex(
      clipBehavior: clipBehavior,
      direction: direction,
      crossAxisAlignment: crossAxisAlignment,
      key: key,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection, 
      children: childrenWithSeparation,     
    );
  }
}