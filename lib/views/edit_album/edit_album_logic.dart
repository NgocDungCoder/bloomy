import 'package:bloomy/services/album_service.dart';
import 'package:bloomy/services/liked_service.dart';
import 'package:bloomy/views/home/home_logic.dart';
import 'package:bloomy/views/library/library_logic.dart';
import 'package:bloomy/views/liked_song/liked_logic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/albums.dart';
import '../album/playlist_logic.dart';

class EditAlbumLogic extends GetxController {
  Rx<AlbumModel> album =
      AlbumModel(id: 'temp', name: 'temp', coverImage: 'temp', songs: []).obs;
  final refreshTrigger = 0.obs;
  final LikedSongService likedSongService;
  final AlbumService albumService;
  final isEditing = false.obs;
  final nameController = TextEditingController();


  EditAlbumLogic(this.likedSongService, this.albumService) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final args = Get.arguments as Map;
      album.value = args['album'];
    });
  }

  Future<void> updateAlbum() async {
    if (album.value.id == "favorite") {
      final songIds = album.value.songs.map((s) => s.id).toList();
      await likedSongService.saveLikedSongIds(songIds);
      await Get.find<LikedLogic>().refreshFavorite();
    } else {
      await albumService.updateAlbum(album.value);
      await Get.find<PlaylistLogic>().refreshAlbum();
    }
  }
  Future<void> refreshLibrary() async {
    Get.find<LibraryLogic>().refreshLibrary();
    Get.find<HomeLogic>().refreshAlbum();
  }
}
