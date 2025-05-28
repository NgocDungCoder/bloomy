import 'package:flutter/services.dart' show rootBundle;

class LyricLine {
  final Duration start;
  final String text;

  LyricLine({required this.start, required this.text});
}

class LyricService {
  static Future<List<LyricLine>> loadFromAsset(String path) async {
    final content = await rootBundle.loadString(path);
    final lines = content.split('\n');
    final regex = RegExp(r'\[(\d+):(\d+\.\d+)\](.*)');
    final result = <LyricLine>[];

    for (var line in lines) {
      print(line);
      final match = regex.firstMatch(line);
      if (match != null) {
        final minutes = int.parse(match.group(1)!);
        final seconds = double.parse(match.group(2)!);
        final text = match.group(3)!.trim();

        final start = Duration(minutes: minutes, milliseconds: (seconds * 1000).toInt());
        result.add(LyricLine(start: start, text: text));
      }
    }

    return result..sort((a, b) => a.start.compareTo(b.start));
  }
}
