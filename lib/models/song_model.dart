import 'dart:convert';

class SongModel {
  final String filePath;
  final String artist;
  final String id;
  final String title;
  final String coverImage;
  final Duration duration;
  final List<double>? waveformData;

  SongModel({
    required this.filePath,
    required this.artist,
    required this.id,
    required this.title,
    required this.coverImage,
    required this.duration,
    this.waveformData,
  });

  String get fileName => filePath.split('/').last;
  String get getTitle => title;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'filePath': filePath,
    'artist': artist,
    'coverImage': coverImage,
    'duration': duration.inMilliseconds,
    'waveformData': waveformData != null ? jsonEncode(waveformData) : null, // Chuyển đổi List<double> thành JSON string
  };

  factory SongModel.fromJson(Map<String, dynamic> json) {
    // Parse waveformData từ JSON string thành List<double>
    List<double>? parsedWaveformData;
    if (json['waveformData'] != null) {
      try {
        final List<dynamic> decoded = jsonDecode(json['waveformData']);
        parsedWaveformData = decoded.map((e) => (e as num).toDouble()).toList();
      } catch (e) {
        print("Lỗi khi parse waveformData: $e");
      }
    }

    return SongModel(
      id: json['id'],
      coverImage: json['coverImage'],
      duration: Duration(milliseconds: json['duration']),
      title: json['title'],
      filePath: json['filePath'],
      artist: json['artist'],
      waveformData: parsedWaveformData,
    );
  }

  get value => null;
}
