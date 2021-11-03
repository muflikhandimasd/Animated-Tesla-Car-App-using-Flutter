import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tesla_animated_app/constanins.dart';
import 'package:tesla_animated_app/home_controller.dart';
import 'package:tesla_animated_app/screens/components/door_lock.dart';

import 'components/battery_status.dart';
import 'components/tesla_bottom_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final HomeController _controller = HomeController();

  late AnimationController _batteryAnimationController;
  late Animation<double> _animationBattery;
  late Animation<double> _animationBatteryStatus;

  void setupBatteryAnimation() {
    _batteryAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    _animationBattery = CurvedAnimation(
      parent: _batteryAnimationController,
      // means 0.5 * 600 = 300
      curve: Interval(0.0, 0.5),
    );

    _animationBatteryStatus = CurvedAnimation(
      parent: _batteryAnimationController,
      // after a delay we start that
      curve: Interval(0.6, 1),
    );
  }

  @override
  void initState() {
    setupBatteryAnimation();
    super.initState();
  }

  @override
  void dispose() {
    _batteryAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        // it rebuilds the widget tree
        // this animation need listenable
        animation: Listenable.merge([_controller, _batteryAnimationController]),
        builder: (context, _) {
          return Scaffold(
            bottomNavigationBar: TeslaBottomNavigationBar(
              onTap: (index) {
                if (index == 1)
                  _batteryAnimationController.forward();
                else if (_controller.selectedBotttomTab == 1 && index != 1)
                  _batteryAnimationController.reverse(from: 0.7);
                _controller.onBottomNavigationTabChange(index);
              },
              selectedTab: _controller.selectedBotttomTab,
            ),
            body: SafeArea(
              child: LayoutBuilder(builder: (context, constraints) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: constraints.maxHeight * 0.1,
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/Car.svg',
                        width: double.infinity,
                      ),
                    ),
                    // Animated process
                    AnimatedPositioned(
                      duration: defaultDuration,
                      right: _controller.selectedBotttomTab == 0
                          ? constraints.maxWidth * 0.05
                          : constraints.maxWidth / 2,
                      // animated the lock
                      child: AnimatedOpacity(
                        duration: defaultDuration,
                        opacity: _controller.selectedBotttomTab == 0 ? 1 : 0,
                        child: DoorLock(
                            isLock: _controller.isRightDoorLock,
                            press: _controller.updateRightDoorLock),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: defaultDuration,
                      left: _controller.selectedBotttomTab == 0
                          ? constraints.maxWidth * 0.05
                          : constraints.maxWidth / 2,
                      // animated the lock
                      child: AnimatedOpacity(
                        duration: defaultDuration,
                        opacity: _controller.selectedBotttomTab == 0 ? 1 : 0,
                        child: DoorLock(
                            isLock: _controller.isLeftDoorLock,
                            press: _controller.updateLeftDoorLock),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: defaultDuration,
                      top: _controller.selectedBotttomTab == 0
                          ? constraints.maxHeight * 0.13
                          : constraints.maxHeight / 2,
                      // animated the lock
                      child: AnimatedOpacity(
                        duration: defaultDuration,
                        opacity: _controller.selectedBotttomTab == 0 ? 1 : 0,
                        child: DoorLock(
                            isLock: _controller.isBonnetDoorLock,
                            press: _controller.updateBonnetDoorLock),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: defaultDuration,
                      bottom: _controller.selectedBotttomTab == 0
                          ? constraints.maxHeight * 0.17
                          : constraints.maxHeight / 2,
                      // animated the lock
                      child: AnimatedOpacity(
                        duration: defaultDuration,
                        opacity: _controller.selectedBotttomTab == 0 ? 1 : 0,
                        child: DoorLock(
                            isLock: _controller.isTrunkDoorLock,
                            press: _controller.updateTrunkDoorLock),
                      ),
                    ),

                    // Battery
                    Opacity(
                      opacity: _animationBattery.value,
                      child: SvgPicture.asset(
                        'assets/icons/Battery.svg',
                        width: constraints.maxWidth * 0.45,
                      ),
                    ),
                    Positioned(
                      top: 50 * (1 - _animationBatteryStatus.value),
                      height: constraints.maxHeight,
                      width: constraints.maxWidth,
                      child: Opacity(
                        opacity: _animationBatteryStatus.value,
                        child: BatteryStatus(
                          constraints: constraints,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          );
        });
  }
}
