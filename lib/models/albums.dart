import 'package:bloomy/models/song_model.dart';

class AlbumModel {
  final String id;
  final String name;
  final String coverImage;
  final List<SongModel> songs;

  AlbumModel({
    required this.id,
    required this.name,
    required this.coverImage,
    required this.songs,
  });

  factory AlbumModel.fromJson(Map<String, dynamic> json) {
    return AlbumModel(
      id: json['id'],
      name: json['name'],
      coverImage: json['coverImage'],
      songs: (json['songs'] as List)
          .map((songJson) => SongModel.fromJson(songJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'coverImage': coverImage,
    'songs': songs.map((song) => song.toJson()).toList(),
  };
}