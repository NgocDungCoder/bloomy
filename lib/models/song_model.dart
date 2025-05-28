class SongModel {
  final String filePath;
  final String artist;
  final String id;
  final String title;
  final String coverImage;
  final Duration duration;
  final String? lyricPath;

  SongModel({
    required this.filePath,
    required this.artist,
    required this.id,
    required this.title,
    required this.coverImage,
    required this.duration,
    String? lyricPath,
  }) : lyricPath = lyricPath ?? 'assets/lyrics/$id.lrc';

  String get fileName => filePath.split('/').last;

  String get getTitle => title;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'filePath': filePath,
        'artist': artist,
        'coverImage': coverImage,
        'duration': duration.inMilliseconds,
        'lyricPath': lyricPath,
      };

  SongModel copyWith({
    String? filePath,
    String? artist,
    String? id,
    String? title,
    String? coverImage,
    Duration? duration,
    String? lyricPath,
  }) {
    return SongModel(
      filePath: filePath ?? this.filePath,
      artist: artist ?? this.artist,
      id: id ?? this.id,
      title: title ?? this.title,
      coverImage: coverImage ?? this.coverImage,
      duration: duration ?? this.duration,
      lyricPath: lyricPath ?? this.lyricPath,
    );
  }

  String get getLyricAssetPath => 'assets/lyrics/$id.lrc';

  factory SongModel.fromJson(Map<String, dynamic> json) => SongModel(
        id: json['id'],
        coverImage: json['coverImage'],
        duration: Duration(milliseconds: json['duration']),
        title: json['title'],
        filePath: json['filePath'],
        artist: json['artist'],
        lyricPath: json['lyricPath'],
      );

  get value => null;

  @override
  String toString() {
    return 'SongModel(id: $id, title: $title, artist: $artist, lyric: $lyricPath)';
  }
}
