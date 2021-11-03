import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tesla_animated_app/constanins.dart';

class DoorLock extends StatelessWidget {
  const DoorLock({
    Key? key,
    required this.press,
    required this.isLock,
  }) : super(key: key);

  final VoidCallback press;
  final bool isLock;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: AnimatedSwitcher(
        duration: defaultDuration,
        switchInCurve: Curves.easeInOutBack,
        transitionBuilder: (child, animation) => ScaleTransition(
          scale: animation,
          child: child,
        ),
        // why still same?
        // flutter think they are same widget, jadi tambahin key nya
        // dikasi key biar flutter tau bahwa itu beda
        // we need to add jumping effect
        child: isLock
            ? SvgPicture.asset(
                'assets/icons/door_lock.svg',
                key: ValueKey("lock"),
              )
            : SvgPicture.asset(
                'assets/icons/door_unlock.svg',
                key: ValueKey("unlock"),
              ),
      ),
    );
  }
}
