import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FansAnimation extends StatefulWidget {
  const FansAnimation({Key? key}) : super(key: key);

  @override
  State<FansAnimation> createState() => _FansAnimationState();
}

class _FansAnimationState extends State<FansAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fansController;

  @override
  void initState() {
    _fansController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat();
    super.initState();
  }
  @override
  void dispose() {
    _fansController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _fansController,
        builder: (context, child) {
          return Transform.rotate(angle: _fansController.value * 2 * math.pi, child: child,);
        },
        child: const FaIcon(FontAwesomeIcons.fan, color: Color.fromARGB(255, 0, 238, 255),size: 200),
      ),
    );
  }
}
