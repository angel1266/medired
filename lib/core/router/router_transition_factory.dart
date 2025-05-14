import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'transition_type.dart';

class RouterTransitionFactory {
  static CustomTransitionPage getTransitionPage(
      {required BuildContext context,
      required GoRouterState state,
      required Widget child,
      required TransitionType type}) {
    return CustomTransitionPage(
        key: state.pageKey,
        child: child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          switch (type) {
            case TransitionType.fade:
              return FadeTransition(opacity: animation, child: child);
            // case TransitionType.rotation:
            //   return RotationTransition(turns: animation, child: child);
            // case 'size':
            //   return SizeTransition(sizeFactor: animation, child: child);
            // case 'scale':
            //   return ScaleTransition(scale: animation, child: child);
            default:
              return FadeTransition(opacity: animation, child: child);
          }
        });
  }
}
