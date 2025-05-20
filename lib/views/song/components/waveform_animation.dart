import 'package:bloomy/views/song/components/wave_forms_painter.dart';
import 'package:flutter/material.dart';

class AnimatedWaveform extends StatefulWidget {
  final List<double> samples;
  final double progress;
  final Color liveColor;
  final Color fixedColor;
  final Function(double) onTap;

  const AnimatedWaveform({
    super.key,
    required this.samples,
    required this.progress,
    required this.liveColor,
    required this.fixedColor,
    required this.onTap,
  });

  @override
  State<AnimatedWaveform> createState() => _AnimatedWaveformState();
}

class _AnimatedWaveformState extends State<AnimatedWaveform> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Tạo animation controller để cập nhật liên tục
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    // Thêm listener để rebuild widget
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        final tapPosition = details.localPosition.dx / 340;
        widget.onTap(tapPosition);
      },
      child: SizedBox(
        width: 340,
        height: 50,
        child:CustomPaint(
          painter: WaveformPainter(
            samples: widget.samples,
            progress: widget.progress,
            liveWaveColor: const Color(0xFF39C0D4),
            fixedWaveColor: Colors.grey.withOpacity(0.5),
            heightFactor: 10,
            showTop: true,
            showBottom: false,
          ),
          size: const Size(340, 50),
        ),

      ),
    );
  }
}
