import 'package:bloomy/models/song_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/lyric_service.dart';

class SongState {
  var song = Rxn<SongModel>();
  var isPlay = false.obs;
  var isShow = false.obs;
  var totalDuration = Duration.zero.obs; // tổng thời lượng bài (milliseconds)
  var lyrics = <LyricLine>[].obs;
  RxInt currentLyricIndex = 0.obs;

}
