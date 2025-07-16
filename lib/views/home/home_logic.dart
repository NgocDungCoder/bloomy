import 'package:bloomy/services/auth_service.dart';
import 'package:bloomy/views/home/home_state.dart';
import 'package:bloomy/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/route.dart';
import '../../services/album_service.dart';
import '../../services/song_service.dart';

class HomeLogic extends GetxController {
  final state = HomeState();
  final SongService songService;
  final AlbumService albumService;
  final AuthService authService;
  final Rx<User?> user = Rx<User?>(null);


  HomeLogic(this.songService, this.albumService, this.authService) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await refreshAlbum();
      await refreshSongs();
      if (authService.isAuth.value) {
        user.value = authService.getCurrentUser();
      }
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

  Future logout() async{
    try {
      await authService.logout();
      Get.offNamed(Routes.login.p);
    } catch (e){
      print("lỗi logout: $e");
    }
  }
}
