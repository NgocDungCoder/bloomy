class SongModel {
  final String id;
  final String title;
  final String artist;
  final String filePath;
  final Duration duration;
  final bool isLiked;


  final String? genre;
  final String? coverImage;
  final String? lyricPath;
  final int? playCount;
  final DateTime? addedDate;
  final DateTime? lastPlayedDate;

  SongModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.filePath,
    required this.duration,
    this.isLiked = false,
    this.genre,
    this.coverImage,
    String? lyricPath,
    this.playCount,
    this.addedDate,
    this.lastPlayedDate,
  }) : lyricPath = lyricPath ?? 'assets/lyrics/$id.lrc';

  String get fileName => filePath.split('/').last;

  String get getLyricAssetPath => 'assets/lyrics/$id.lrc';

  factory SongModel.empty() => SongModel(id: 'temp', title: 'temp', artist: 'temp', filePath: 'temp', duration: Duration(seconds: 0));

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'artist': artist,
    'filePath': filePath,
    'duration': duration.inMilliseconds,
    'isLiked': isLiked,
    'genre': genre,
    'coverImage': coverImage,
    'lyricPath': lyricPath,
    'playCount': playCount,
    'addedDate': addedDate?.toIso8601String(),
    'lastPlayedDate': lastPlayedDate?.toIso8601String(),
  };

  factory SongModel.fromJson(Map<String, dynamic> json) => SongModel(
    id: json['id'],
    title: json['title'],
    artist: json['artist'],
    filePath: json['filePath'],
    duration: Duration(milliseconds: json['duration']),
    isLiked: json['isLiked'] ?? false,
    genre: json['genre'],
    coverImage: json['coverImage'],
    lyricPath: json['lyricPath'],
    playCount: json['playCount'],
    addedDate: json['addedDate'] != null
        ? DateTime.parse(json['addedDate'])
        : null,
    lastPlayedDate: json['lastPlayedDate'] != null
        ? DateTime.parse(json['lastPlayedDate'])
        : null,
  );

  SongModel copyWith({
    String? id,
    String? title,
    String? artist,
    String? filePath,
    Duration? duration,
    String? album,
    String? genre,
    String? coverImage,
    String? lyricPath,
    int? playCount,
    DateTime? addedDate,
    DateTime? lastPlayedDate,
    bool? isLiked,

  }) {
    return SongModel(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      filePath: filePath ?? this.filePath,
      duration: duration ?? this.duration,
      genre: genre ?? this.genre,
      coverImage: coverImage ?? this.coverImage,
      lyricPath: lyricPath ?? this.lyricPath,
      playCount: playCount ?? this.playCount,
      addedDate: addedDate ?? this.addedDate,
      lastPlayedDate: lastPlayedDate ?? this.lastPlayedDate,
      isLiked: isLiked ?? this.isLiked,

    );
  }

  @override
  String toString() {
    return 'SongModel(id: $id, title: $title, artist: $artist, genre: $genre, playCount: $playCount, lastPlayedDate: $lastPlayedDate, isLiked: $isLiked, addDate: $addedDate, lyricPath: $lyricPath';
  }
}