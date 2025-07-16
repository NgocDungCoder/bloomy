import 'dart:async';

import 'package:bloomy/models/albums.dart';
import 'package:bloomy/models/song_model.dart';
import 'package:bloomy/services/album_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../services/song_service.dart';

class ExploreLogic extends GetxController {
  final AlbumService albumService;
  final SongService songService;
  Timer? _debounce;

  ExploreLogic(this.albumService, this.songService) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final songs = await songService.getSavedSongs(); // lấy danh sách
      allSongs.addAll(songs);
      final albums = await albumService.loadAlbums(); // lấy danh sách
      allAlbums.addAll(albums);
    });
  }

  final isSearching = false.obs;
  final searchQuery = "".obs;
  RxList<SongModel> filteredSongs = <SongModel>[].obs;
  RxList<AlbumModel> filteredAlbums = <AlbumModel>[].obs;
  RxList<SongModel> allSongs = <SongModel>[].obs;
  RxList<AlbumModel> allAlbums = <AlbumModel>[].obs;

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (query.isEmpty) {
        filteredSongs.value = allSongs;
      } else {
        filteredSongs.value = allSongs
            .where((song) =>
                song.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
        filteredAlbums.value = allAlbums
            .where((album) =>
                album.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }
}
