import 'package:flutter/material.dart';

class WaveformPainter extends CustomPainter {
  final List<double> samples;
  final double progress;
  final Color liveWaveColor;
  final Color fixedWaveColor;
  final double barWidth;
  final double spacing;
  final double heightFactor;
  final bool showTop;    // Hiển thị nửa trên của waveform
  final bool showBottom; // Hiển thị nửa dưới của waveform

  WaveformPainter({
    required this.samples,
    required this.progress,
    this.liveWaveColor = const Color(0xFF39C0D4),
    this.fixedWaveColor = Colors.grey,
    this.barWidth = 3.0,
    this.spacing = 2.0,
    this.heightFactor = 1.2,
    this.showTop = true,
    this.showBottom = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (samples.isEmpty) return;

    // Tính toán số lượng thanh có thể hiển thị
    final availableWidth = size.width;
    final totalBarWidth = barWidth + spacing;
    final visibleBars = (availableWidth / totalBarWidth).floor();

    // Lấy mẫu từ dữ liệu để hiển thị đủ số thanh
    final step = samples.length / visibleBars;
    final displaySamples = <double>[];

    for (int i = 0; i < visibleBars; i++) {
      final sampleIndex = (i * step).floor();
      if (sampleIndex < samples.length) {
        displaySamples.add(samples[sampleIndex]);
      }
    }

    // Tính toán vị trí progress
    final progressPosition = size.width * progress;

    // Tính toán vị trí trung tâm theo chiều dọc
    final centerY = size.height / 2;

    // Vẽ các thanh waveform
    double xPosition = 0;
    for (int i = 0; i < displaySamples.length; i++) {
      final amplitude = displaySamples[i];

      // Điều chỉnh chiều cao để waveform cao hơn
      final fullBarHeight = size.height * amplitude * heightFactor;
      final halfBarHeight = fullBarHeight / 2;

      // Xác định màu dựa trên tiến trình phát
      final paint = Paint()
        ..color = xPosition <= progressPosition ? liveWaveColor : fixedWaveColor
        ..style = PaintingStyle.fill;

      // Vẽ nửa trên nếu showTop = true
      if (showTop) {
        final topBarHeight = halfBarHeight.clamp(0.0, centerY);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(xPosition, centerY - topBarHeight, barWidth, topBarHeight),
            Radius.circular(barWidth / 2),
          ),
          paint,
        );
      }

      // Vẽ nửa dưới nếu showBottom = true
      if (showBottom) {
        final bottomBarHeight = halfBarHeight.clamp(0.0, centerY);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(xPosition, centerY, barWidth, bottomBarHeight),
            Radius.circular(barWidth / 2),
          ),
          paint,
        );
      }

      // Cập nhật vị trí x cho thanh tiếp theo
      xPosition += totalBarWidth;
    }
  }

  @override
  bool shouldRepaint(covariant WaveformPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.heightFactor != heightFactor ||
        oldDelegate.showTop != showTop ||
        oldDelegate.showBottom != showBottom;
  }
}
