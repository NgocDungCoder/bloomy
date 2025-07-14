import '../../services/song_service.dart';
import '../../views/stat/stat_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/album_service.dart';

class StatLogic extends GetxController {
  final state = StatState();
  final SongService songService;
  final AlbumService albumService;
  final selectedIndex = 0.obs;



  StatLogic(this.songService, this.albumService) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final listAlbum = await albumService.loadAlbums();
      listAlbum.sort((a, b) => (b.songs.length).compareTo(a.songs.length));
      state.albums.addAll(listAlbum);

      final listSong = await songService.getSavedSongs();
      listSong.sort((a, b) => (b.playCount ?? 0).compareTo(a.playCount ?? 0));
      state.tracks.addAll(listSong);
    });
  }


}