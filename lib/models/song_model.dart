class SongModel {
  final String filePath;
  final String artist;
  final String id;
  final String title;
  final String coverImage;
  final Duration duration;

  SongModel({ required this.filePath, required this.artist, required this.id, required this.title, required this.coverImage, required this.duration});

  String get fileName => filePath.split('/').last;
  String get getTitle => title;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'filePath': filePath,
    'artist': artist,
    'coverImage': coverImage,
    'duration': duration.inMilliseconds,
  };

  factory SongModel.fromJson(Map<String, dynamic> json) => SongModel(
    id: json['id'],
    coverImage: json['coverImage'],
    duration: Duration(milliseconds: json['duration']),
    title: json['title'],
    filePath: json['filePath'],
    artist: json['artist'],
  );

  get value => null;


}