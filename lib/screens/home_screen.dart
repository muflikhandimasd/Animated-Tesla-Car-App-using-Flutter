import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tesla_animated_app/constanins.dart';
import 'package:tesla_animated_app/home_controller.dart';
import 'package:tesla_animated_app/screens/components/door_lock.dart';
import 'package:tesla_animated_app/screens/components/temp_details.dart';
import 'components/battery_status.dart';
import 'components/tesla_bottom_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// ticker animation for animation controller
class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final HomeController _controller = HomeController();

  late AnimationController _batteryAnimationController;
  late Animation<double> _animationBattery;
  late Animation<double> _animationBatteryStatus;

  late AnimationController _tempAnimationController;
  late Animation<double> _animationCarShift;
  late Animation<double> _animationTempShowInfo;
  late Animation<double> _animationCoolGlow;

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

  void setupTempAnimation() {
    _tempAnimationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 1500,
      ),
    );
    // Lets define animation for car shift
    _animationCarShift = CurvedAnimation(
      parent: _tempAnimationController,
      // at first we will wait, so that battery stats animation can complete
      curve: Interval(0.2, 0.4),
    );
    _animationTempShowInfo = CurvedAnimation(
      parent: _tempAnimationController,
      // at first we will wait, so that battery stats animation can complete
      curve: Interval(0.45, 0.65),
    );
    _animationCoolGlow = CurvedAnimation(
      parent: _tempAnimationController,
      // at first we will wait, so that battery stats animation can complete
      curve: Interval(0.7, 1),
    );
  }

  @override
  void initState() {
    setupBatteryAnimation();
    setupTempAnimation();
    super.initState();
  }

  @override
  void dispose() {
    _batteryAnimationController.dispose();
    _tempAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      // it rebuilds the widget tree
      // this animation need listenable
      animation: Listenable.merge([
        _controller,
        _batteryAnimationController,
        _tempAnimationController,
      ]),
      builder: (context, _) {
        return Scaffold(
          bottomNavigationBar: TeslaBottomNavigationBar(
            onTap: (index) {
              if (index == 1)
                _batteryAnimationController.forward();
              else if (_controller.selectedBotttomTab == 1 && index != 1)
                _batteryAnimationController.reverse(from: 0.7);
              if (index == 2)
                _tempAnimationController.forward();
              else if (_controller.selectedBotttomTab == 2 && index != 2)
                _tempAnimationController.reverse(from: 0.4);
              _controller.onBottomNavigationTabChange(index);
            },
            selectedTab: _controller.selectedBotttomTab,
          ),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: constraints.maxHeight,
                      width: constraints.maxWidth,
                    ),
                    // We want to our car in right side
                    Positioned(
                      left: constraints.maxWidth / 2 * _animationCarShift.value,
                      height: constraints.maxHeight,
                      width: constraints.maxWidth,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: constraints.maxHeight * 0.1,
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/Car.svg',
                          width: double.infinity,
                        ),
                      ),
                    ),
                    // Animated process
                    // Right
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
                    // Left
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
                    // Bottom
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
                    // Top
                    AnimatedPositioned(
                      duration: defaultDuration,
                      top: _controller.selectedBotttomTab == 0
                          ? constraints.maxHeight * 0.17
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
                    // Temperature
                    Positioned(
                      top: 60 * (1 - _animationTempShowInfo.value),
                      height: constraints.maxHeight,
                      width: constraints.maxWidth,
                      child: Opacity(
                        opacity: _animationTempShowInfo.value,
                        child: TempDetails(
                          controller: _controller,
                        ),
                      ),
                    ),
                    Positioned(
                      right: -100 * (1 - _animationCoolGlow.value),
                      child: AnimatedSwitcher(
                        duration: defaultDuration,
                        child: _controller.isCoolSelected
                            ? Image.asset(
                                'assets/images/Cool_glow_2.png',
                                key: UniqueKey(),
                                width: 200,
                              )
                            : Image.asset(
                                'assets/images/Hot_glow_4.png',
                                key: UniqueKey(),
                                width: 200,
                              ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
