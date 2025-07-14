import 'package:bloomy/controllers/song_controller.dart';
import 'package:bloomy/models/song_model.dart';
import 'package:bloomy/services/album_service.dart';
import 'package:bloomy/services/liked_service.dart';
import 'package:bloomy/services/song_service.dart';
import 'package:bloomy/views/home/home_logic.dart';
import 'package:bloomy/views/menu/menu_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuLogic extends GetxController {
  final state = MenuState();
  final SongService songService;
  final AlbumService albumService;
  final SongController songController;
  final LikedSongService likedSongService;

  MenuLogic(this.songService, this.albumService, this.songController, this.likedSongService) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final args = Get.arguments as Map;

      if ( args['albumId'] != null) {
        state.albumId.value =  args['albumId'];
        state.inAlbum.value = true;
        print("Mở từ album: ${state.albumId.value}");
      }
      state.song.value = args['song'];

    });
  }

  void removeFormPlaylist() {
    albumService.deleteSongInAlbum(state.albumId.value, state.song.value.id);
  }

  Future updateSongInfo(String title, String artist) async {
    await songController.updateSongInfo(title, artist);
    Get.find<HomeLogic>().refreshSongs();
  }

  void addToFavorite() {
    if(songController.state.song.value!.isLiked) {
      likedSongService.unlikeSong(songController.state.song.value!.id);
    } else {
      likedSongService.likeSong(songController.state.song.value!.id);
    }
    songController.likedSong();
  }

  Future deleteSong() async {
    await songService.deleteSong(state.song.value.id);
  }
}