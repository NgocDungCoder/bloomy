import 'package:bloomy/enum/music_type.dart';
import 'package:bloomy/models/albums.dart';
import 'package:bloomy/models/artist.dart';
import 'package:bloomy/models/folders.dart';
import 'package:bloomy/models/songs.dart';
import 'package:bloomy/services/album_service.dart';
import 'package:bloomy/services/song_service.dart';
import 'package:bloomy/views/library/library_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LibraryLogic extends GetxController {
  final state = LibraryState();
  final SongService songService;
  final AlbumService albumService;

  LibraryLogic(this.songService, this.albumService) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      loadData();
    });
  }

  void changeType(MusicType type) {
    state.musicType.value = type;
    loadData();
  }

  Future refreshLibrary() async {
    await loadData();
  }

  Future loadData() async {
    switch (state.musicType.value) {
      case MusicType.songs:
        state.songs.value = await songService.getSavedSongs();
        break;
      case MusicType.albums:
        state.albums.value = await albumService.loadAlbums();
        break;
      case MusicType.artists:
        state.artists.value =[
          Artist(name: "Made For You", image: "assets/images/img17.jpg"),
          Artist(name: "RELEASED", image: "assets/images/img18.jpg"),
          Artist(name: "Music Charts", image: "assets/images/img19.jpg"),
          Artist(name: "Podcasts", image: "assets/images/img20.jpg"),
          Artist(name: "Bollywood", image: "assets/images/img1.jpg"),
          Artist(name: "Pop Fusion", image: "assets/images/img2.jpg"),
        ];
        break;
      case MusicType.podcasts:
        state.podcasts.value = [
          Folder(name: "Made For You", image: "assets/images/img3.jpg"),
          Folder(name: "RELEASED", image: "assets/images/img4.jpg"),
          Folder(name: "Music Charts", image: "assets/images/img5.jpg"),
          Folder(name: "Podcasts", image: "assets/images/img6.jpg"),
          Folder(name: "Bollywood", image: "assets/images/img7.jpg"),
          Folder(name: "Pop Fusion", image: "assets/images/img8.jpg"),
        ];
        break;
    }
  }

  void enterSelectMode(String id) {
    state.isSelecting.value = true;
    state.selectedIds.add(id);
    state.selectedIds.refresh();
  }

  void toggleSelection(String id) {
    final current = Set<String>.from(state.selectedIds); // clone
    if (current.contains(id)) {
      current.remove(id);
    } else {
      current.add(id);
    }
    state.selectedIds.value = current; // Gán lại để trigger Obx rebuild
  }

  void clearSelection() {
    state.isSelecting.value = false;
    state.selectedIds.clear();
  }
}
