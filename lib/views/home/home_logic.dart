import 'package:bloomy/views/home/home_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/album_service.dart';
import '../../services/song_service.dart';

class HomeLogic extends GetxController {
  final state = HomeState();
  final SongService songService;
  final AlbumService albumService;

  HomeLogic(this.songService, this.albumService) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await refreshAlbum();

      await refreshSongs();
    });
  }

  Future refreshAlbum() async {
    final listAlbum = await albumService.loadAlbums();
    state.recentList.clear();
    state.mixesList.clear();
    state.recentList
        .addAll(listAlbum.reversed.take(6).toList().reversed.toList());
    state.mixesList.addAll(listAlbum.reversed.take(6).toList());
  }

  Future refreshSongs() async {
    final allSongs = await songService.getSavedSongs();
    state.continueList.clear();

    final recentSongs = allSongs
        .where((song) => song.lastPlayedDate != null)
        .toList()
      ..sort((a, b) => b.lastPlayedDate!.compareTo(a.lastPlayedDate!));

    state.continueList.addAll(recentSongs.take(6));
  }
}
