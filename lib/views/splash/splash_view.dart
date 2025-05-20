import 'dart:async';
import 'dart:math';

import 'package:bloomy/views/home/home_view.dart';
import 'package:bloomy/views/main/main_view.dart';
import 'package:bloomy/views/splash/splash_logic.dart';
import 'package:bloomy/views/test.dart';
import 'package:bloomy/views/welcome/welcome_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashLogic>(() => SplashLogic());
  }
}

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _controller2;
  late AnimationController _controller3;
  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;
  late Animation<double> _animation4;
  late Animation<double> _animation5;
  late Animation<double> _animation6;
  late Animation<double> _animation7;
  Color _circleColor1 = Colors.blue; // Màu khởi tạo
  Color _circleColor2 = Color(0xFF81E7AF); // Màu khởi tạo
  Color _circleColor3 = Color(0xFF8F87F1); // Màu khởi tạo

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _controller2 = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..forward();
    _controller3 = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    // Tạo animation cho các đường chéo di chuyển từ ngoài vào
    _animation1 = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _animation2 = Tween<double>(begin: -1, end: 0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _animation3 = Tween<double>(begin: 4, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));
    _animation4 = Tween<double>(begin: 1.1, end: 1.0).animate(
      CurvedAnimation(parent: _controller2, curve: Curves.easeOut),
    );

    _animation5 = Tween<double>(begin: 1, end: 5.0).animate(
      CurvedAnimation(parent: _controller3, curve: Curves.easeOut),
    );

    _animation6 = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _controller3, curve: Curves.easeOut),
    );

    _animation7 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller3, curve: Curves.easeOut),
    );
    // Bắt đầu hiệu ứng
    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Khi scale xong => chuyển sang đập (pulse)
        _controller2.forward();
      }
    });
    _controller2.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Khi animation hoàn thành (pulse hoàn tất)
        setState(() {
          // Đổi màu sau mỗi lần pulse
          _circleColor1 =
              _circleColor1 == Colors.blue ? Color(0xFF66D2CE) : Colors.blue;
          _circleColor2 = _circleColor2 == Color(0xFF81E7AF)
              ? Colors.blue
              : Color(0xFF81E7AF);
          _circleColor3 = _circleColor3 == Color(0xFF8F87F1)
              ? Color(0xFFF75A5A)
              : Color(0xFF8F87F1);
        });

        _controller2.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller2.forward();
      }
    });

    _controller3.addListener(() {
      if (_controller3.isCompleted) {
        Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
          return WelcomeView();
        }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        }));
      }
      Timer(const Duration(milliseconds: 2500), () {

        _controller.forward();
        _controller2.reset();
        _controller3.reset();

      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.black, // nền tối cho nổi bật
        body: Stack(children: [
          ScaleTransition(
            scale: _animation3,
            child: ScaleTransition(
              scale: _animation5,
              child: ScaleTransition(
                scale: _animation4,
                child: CustomPaint(
                  size: Size(
                      MediaQuery.of(context).size.width,
                      MediaQuery.of(context)
                          .size
                          .height), // Kích thước của vùng vẽ
                  painter: CirclePainter(
                      _circleColor1, _circleColor2, _circleColor3),
                ),
              ),
            ),
          ),
          FadeTransition(
            opacity: _animation6,
            child: AnimatedBuilder(
              builder: (context, child) {
                return CustomPaint(
                    size: MediaQuery.of(context)
                        .size, // Kích thước toàn bộ màn hình
                    painter: DiagonalLinesPainter(
                      animation1: _animation1.value,
                      animation2: _animation2.value,
                    ));
              },
              animation: _controller,
            ),
          ),
          Positioned(
              top: 280,
              left: 0,
              right: 0,
              child: InkWell(
                onTap: () {
                  _controller2.stop();
                  _controller3.forward();
                },
                splashColor: Colors.transparent,
                // Tắt màu ripple khi nhấn
                highlightColor: Colors.transparent,
                // Tắt hiệu ứng highlight khi nhấn
                child: FadeTransition(
                  opacity: _animation6,
                  child: Image.asset(
                    "assets/logo/logo_bloomy.png",
                    width: 300,
                    height: 300,
                  ),
                ),
              )),
        ]));
  }
}

class DiagonalLinesPainter extends CustomPainter {
  final double animation1;
  final double animation2;

  DiagonalLinesPainter({
    required this.animation1,
    required this.animation2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint1 = Paint()
      ..color = Color(0xFFFFA955) // Màu cho đường chéo thứ nhất
      ..strokeWidth = 15
      ..style = PaintingStyle.stroke;

    final Paint paint2 = Paint()
      ..color = Color(0xFFF75A5A) // Màu cho đường chéo thứ hai
      ..strokeWidth = 15
      ..style = PaintingStyle.stroke;

    final Paint paint3 = Paint()
      ..color = Color(0xFFFFD63A) // Màu cho đường chéo thứ hai
      ..strokeWidth = 15
      ..style = PaintingStyle.stroke;

    final Paint paint4 = Paint()
      ..color = Color(0xFF6DE1D2) // Màu cho đường chéo thứ hai
      ..strokeWidth = 15
      ..style = PaintingStyle.stroke;

    final Path path1 = Path();
    final Path path2 = Path();
    final Path path3 = Path();
    final Path path4 = Path();

    // Đường chéo thứ nhất
    path1.moveTo(0, size.height / 2 * animation1); // Bắt đầu từ góc dưới trái
    path1.lineTo(size.width / 2 + size.width / 2 * animation2,
        0); // Vẽ đến góc trên phải

    // Đường chéo thứ hai (ngược lại)
    path2.moveTo(size.width * animation1,
        size.height - size.height / 2 * animation1); // Bắt đầu từ góc dưới phải
    path2.lineTo(0 + size.width / 2 * animation1,
        size.height - size.height * animation1); // Vẽ đến góc trên trái

    // Đường chéo thứ hai (ngược lại)
    path3.moveTo(
        size.width,
        size.height / 2 -
            size.height / 2 * animation2); // Bắt đầu từ góc dưới phải
    path3.lineTo(size.width / 2 - size.width / 2 * animation2,
        size.height); // Vẽ đến góc trên trái

    path4.moveTo(size.width - size.width * animation1,
        size.height / 2 * animation1); // Bắt đầu từ góc dưới phải
    path4.lineTo(size.width / 2 - size.width / 2 * animation2,
        size.height * animation1); // Vẽ đến góc trên trái

    // Vẽ hai đường
    canvas.drawPath(path1, paint1);
    canvas.drawPath(path2, paint2);
    canvas.drawPath(path3, paint3);
    canvas.drawPath(path4, paint4);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CirclePainter extends CustomPainter {
  final Color color;
  final Color color2;
  final Color color3;

  CirclePainter(this.color, this.color2, this.color3); // Màu khởi tạo

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color // Màu của đường tròn
      ..strokeWidth = 8 // Độ dày đường viền
      ..style = PaintingStyle.stroke; // Chỉ vẽ viền, không tô màu bên trong
    final Paint paint2 = Paint()
      ..color = color2 // Màu của đường tròn
      ..strokeWidth = 8 // Độ dày đường viền
      ..style = PaintingStyle.stroke; // Chỉ vẽ viền, không tô màu bên trong
    final Paint paint3 = Paint()
      ..color = color3 // Màu của đường tròn
      ..strokeWidth = 8 // Độ dày đường viền
      ..style = PaintingStyle.stroke; // Chỉ vẽ viền, không tô màu bên trong

    // Vẽ đường tròn
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2), // Tâm đường tròn
      120, // Bán kính
      paint,
    );

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2), // Tâm đường tròn
      120 + 15, // Bán kính
      paint2,
    );

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2), // Tâm đường tròn
      120 + 30, // Bán kính
      paint3,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Không cần vẽ lại nếu không thay đổi gì
  }
}
