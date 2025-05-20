import 'dart:convert';
import 'dart:io';
import 'package:bloomy/controllers/song_controller.dart';
import 'package:bloomy/models/albums.dart';
import 'package:bloomy/models/song_model.dart';
import 'package:bloomy/services/song_service.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class AlbumService {
  final _uuid = Uuid();


  Future<String> get _albumFilePath async {
    final dir = await getApplicationDocumentsDirectory();
    return "${dir.path}/albums.json";
  }

  Future<List<AlbumModel>> loadAlbums() async {
    final path = await _albumFilePath;
    final file = File(path);
    if (!file.existsSync()) return [];
    final content = await file.readAsString();
    final List decoded = json.decode(content);
    return decoded.map((e) => AlbumModel.fromJson(e)).toList();
  }

  Future<void> saveAlbums(List<AlbumModel> albums) async {
    final path = await _albumFilePath;
    final file = File(path);
    final content = json.encode(albums.map((e) => e.toJson()).toList());
    await file.writeAsString(content);
  }

  Future<void> addAlbum(String name, String coverImage, List<SongModel> songs,) async {
    final albums = await loadAlbums();
    final album = AlbumModel(
      id: _uuid.v4(),
      name: name,
      coverImage: coverImage,
      songs: songs,
    );
    albums.insert(0, album);
    await saveAlbums(albums);
  }

  Future<void> deleteAlbum(String albumId) async {
    final albums = await loadAlbums();
    albums.removeWhere((album) => album.id == albumId);
    await saveAlbums(albums);
  }

  Future<void> deleteSongInAlbum(String albumId, String songId) async {
    final albums = await loadAlbums();

    final index = albums.indexWhere((album) => album.id == albumId);
    if (index == -1) {
      print("Không tìm thấy album");
      return;
    }

    // Lấy album ra và xoá bài hát khỏi danh sách
    final album = albums[index];
    album.songs.removeWhere((song) => song.id == songId);

    // Gán lại album đã thay đổi vào danh sách
    albums[index] = album;

    // Lưu lại danh sách
    await saveAlbums(albums);

    print("Đã xoá bài hát $songId khỏi album $albumId");
  }

  Future<void> addSongToAlbum(String albumId, SongModel song) async {
    final albums = await loadAlbums();

    final index = albums.indexWhere((album) => album.id == albumId);
    if (index == -1) {
      print("Không tìm thấy album");
      return;
    }

    // Lấy album ra và xoá bài hát khỏi danh sách
    final album = albums[index];
    album.songs.insert(0, song);

    // Gán lại album đã thay đổi vào danh sách
    albums[index] = album;

    // Lưu lại danh sách
    await saveAlbums(albums);

    print("Đã thêm bài hát ${song.title} vào album $albumId");
  }

  Future<void> deleteAllAlbums() async {
    final filePath = await _albumFilePath;
    final file = File(filePath);

    if (await file.exists()) {
      await file.writeAsString('[]'); // Ghi mảng rỗng để xóa tất cả album
      print("✅ Đã xóa tất cả album.");
    } else {
      print("⚠️ File albums.json không tồn tại.");
    }
  }

}