import 'package:bloomy/models/albums.dart';
import 'package:bloomy/services/liked_service.dart';
import 'package:bloomy/services/song_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/song_model.dart';
import '../../widgets/snackbar.dart';

class LikedLogic extends GetxController {
  RxList<SongModel> likedSongs = <SongModel>[].obs;
  final LikedSongService likedSongService;
  final SongService songService;
  final Rxn<AlbumModel> album = Rxn<AlbumModel>(
    AlbumModel(
      id: 'favorite',
      name: 'Favorite',
      coverImage: 'assets/images/img999.jpg',
      songs: [],
    ),
  );

  LikedLogic(this.likedSongService, this.songService) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadSongs();
    });
  }

  Future refreshFavorite() async {
    await loadSongs();
  }

  void deleteAllLiked() async {
    try {
      await likedSongService.clearLikedSongs();
      await refreshFavorite();
      await Get.find<SongService>().resetAllLikedStatus();
      showCustomSnackbar(
        message: 'Deleted all favorite',
        type: SnackbarType.success,
      );
    } catch (e) {
      print("lỗi khi xoá: $e");
      showCustomSnackbar(
        message: 'Can\'t deleted favorite',
        type: SnackbarType.error,
      );
    }
  }

  Future<void> loadSongs() async {
    final likedIds = await likedSongService.loadLikedSongIds();

    final allSongs = await songService.getSavedSongs();

    final orderedLikedSongs = likedIds
        .map((id) => allSongs.firstWhere(
              (s) => s.id == id,
              orElse: () => SongModel.empty(),
            ))
        .whereType<SongModel>() // Nếu không tìm thấy thì bỏ qua null
        .toList();
    likedSongs.clear();
    likedSongs.assignAll(orderedLikedSongs);
    album.value!.songs
      ..clear()
      ..addAll(orderedLikedSongs);

  }
}
