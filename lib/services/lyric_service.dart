import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';

class LyricLine {
  final Duration start;
  final String text;
  final int maxLine;

  LyricLine({required this.start, required this.text, this.maxLine = 1});
}

bool isMultiLine(String text) {
  final TextPainter painter = TextPainter(
    text: TextSpan(
      text: text,
      style: GoogleFonts.aBeeZee(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
    maxLines: null,
    textDirection: TextDirection.ltr,
  )..layout(maxWidth: 290);
  return painter.computeLineMetrics().length > 1;
}

class LyricService {
  static Future<List<LyricLine>> loadLyricFromAsset(String path) async {
    final content = await rootBundle.loadString(path);
    final lines = content.split('\n');
    final regex = RegExp(r'\[(\d+):(\d+\.\d+)\](.*)');
    final result = <LyricLine>[];

    for (var line in lines) {
      final match = regex.firstMatch(line);
      if (match != null) {
        final minutes = int.parse(match.group(1)!);
        final seconds = double.parse(match.group(2)!);
        final text = match.group(3)!.trim();

        final start =
            Duration(minutes: minutes, milliseconds: (seconds * 1000).toInt());
        final line = isMultiLine(text) ? 2 : 1;
        print("text: $text ===> line: $line");
        result.add(LyricLine(start: start, text: text, maxLine: line));
      }
    }

    return result..sort((a, b) => a.start.compareTo(b.start));
  }
}
