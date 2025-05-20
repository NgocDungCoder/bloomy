import 'dart:async';
import 'dart:math';

import 'package:bloomy/views/float_play/float_play_logic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FloatPlayView extends StatefulWidget {
  @override
  State<FloatPlayView> createState() => _FloatPlayViewState();
}

class _FloatPlayViewState extends State<FloatPlayView>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _filingController;
  double screenHeight = 687;
  final logic = Get.put(FloatPlayLogic());

  double _containerWidth = 170;
  bool _isExpanded = true;
  Timer? _hideTimer;

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(Duration(seconds: 5), () {
      setState(() {
        _containerWidth = 0;
        _isExpanded = false;
      });
    });
  }

  void _toggleExpand() {
    setState(() {
      _containerWidth = _isExpanded ? 0 : 170;
      _isExpanded = !_isExpanded;
    });
    if (_isExpanded) _startHideTimer();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    )..repeat();

    _filingController = AnimationController.unbounded(vsync: this);

    _startHideTimer();
    logic.bindAnimation(_animationController);
  }



  void _startFling(double velocity) {
    final simulation = ClampingScrollSimulation(
      position: logic.state.posY.value,
      velocity: -velocity,
      tolerance: Tolerance(distance: 1.0, velocity: 1.0),
    );

    _filingController.stop(); // dừng bất kỳ animation cũ
    _filingController.addListener(_onTick);
    _filingController.animateWith(simulation).whenComplete(() {
      _filingController.removeListener(_onTick);
    });
  }

  void _onTick() {
    setState(() {
      logic.state.posY.value = _filingController.value.clamp(70.0, screenHeight);
    });
  }


  @override
  void dispose() {
    _animationController.dispose();
    _hideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Stack(
      children: [
        if (logic.songController.state.isShow.value)
          Positioned(
            right: 30,
            bottom: logic.state.posY.value + 8,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              height: 65,
              width: _containerWidth,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0E0E0E),
                    Color(0xFF0E0E0E),
                    Color(0xFF102B2D),
                    Color(0xFF06A0B5),
                  ],
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(100),
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                ),
              ),
              child: _isExpanded
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Obx(
                        () => IconButton(
                      onPressed: () {
                        logic.playPauseMusic();
                        _startHideTimer(); // reset timer khi người dùng tương tác
                      },
                      icon: Icon(
                        logic.songController.state.isPlay.value
                            ? Icons.pause_outlined
                            : Icons.play_arrow_rounded,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _startHideTimer();
                    },
                    icon: Icon(
                      Icons.skip_next_rounded,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                  Container(
                    width: 65,
                  ),
                ],
              )
                  : SizedBox.shrink(),
            ),
          ),
        if (logic.songController.state.isShow.value)
          Positioned(
            bottom: logic.state.posY.value + 5,
            right: 5,
            child: GestureDetector(
              onTap: _toggleExpand,
              onVerticalDragUpdate: (details) {
                setState(() {
                  logic.state.posY.value -= details.delta.dy;
                  logic.state.posY.value = logic.state.posY.value.clamp(70.0, screenHeight);
                });
              },
              onVerticalDragEnd: (details) {
                _startFling(details.primaryVelocity ?? 0);
              },
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _animationController.value * 2 * pi,
                    child: child,
                  );
                },
                child: Container(
                  height: 90,
                  width: 90,
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        colors: [Color(0xFF158085), Color(0xFF00DBFC)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.asset(
                      logic.songController.state.song.value!.coverImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        if (logic.songController.state.isShow.value)
          Positioned(
            bottom: logic.state.posY.value + 42,
            right: 42,
            child: IgnorePointer(
              ignoring: true,
              child: Container(
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      colors: [Color(0xFF158085), Color(0xFF00DBFC)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                ),
              ),
            ),
          ),
      ],
    ),);
  }
}
