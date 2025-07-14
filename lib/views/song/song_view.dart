import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:bloomy/routes/route.dart';
import 'package:bloomy/views/song/song_logic.dart';
import 'package:bloomy/widgets/primary_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SongBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SongLogic>(() => SongLogic());
  }
}

class SongView extends GetView<SongLogic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(
        () {
          final gradientColors = controller
              .getGradientColors(controller.progress.value.clamp(0.0, 1.0));

          return AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            // Thời gian chuyển màu mượt mà
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => Get.back(),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Icon(
                                Icons.arrow_back_ios_outlined,
                                color: Colors.white,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PrimaryText(
                                  text: "Playing from playlist:".toUpperCase(),
                                  fontSize: 12,
                                ),
                                Obx(() {
                                  if (controller.album.value != null) {
                                    return PrimaryText(
                                      text: controller.album.value?.name ?? "",
                                      fontWeight: FontWeight.bold,
                                      maxLine: 2,
                                      color: Color(0xFF7CEEFF),
                                    );
                                  } else {
                                    return PrimaryText(
                                      text: "Danh sách chung",
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF7CEEFF),
                                    );
                                  }
                                })
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Get.toNamed(Routes.menu.p, arguments: {
                          "song": controller.songController.state.song.value,
                          "albumId": controller.album.value?.id,
                        }),
                        icon: const Icon(
                          Icons.more_vert_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Obx(
                    () => Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 340,
                            height: 340,
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.asset(
                                controller.songController.state.song.value
                                            ?.coverImage?.isNotEmpty ??
                                        false
                                    ? controller.songController.state.song
                                        .value!.coverImage!
                                    : 'assets/images/img999.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 15,
                          left: 11,
                          right: 11,
                          child: Container(
                            height: 35,
                            decoration: BoxDecoration(
                              // color: Colors.red,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black,
                                  Colors.transparent,
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                        ),
                        controller.isReady.value
                            ? Positioned(
                                bottom: -15,
                                left: 11,
                                right: 11,
                                child: AudioFileWaveforms(
                                  playerController: controller.playerController,
                                  size: Size(
                                      MediaQuery.of(context).size.width - 52,
                                      60),
                                  waveformType: WaveformType.long,
                                  // enableSeekGesture: false,
                                  playerWaveStyle: PlayerWaveStyle(
                                    fixedWaveColor: Colors.grey,
                                    liveWaveColor: Color(0xFF39C0D4),
                                    // backgroundColor: Colors.red,
                                    spacing: 2,
                                    waveThickness: 1,
                                    waveCap: StrokeCap.square,
                                    showBottom: false,
                                    scaleFactor: 300,
                                    showSeekLine: false,
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
                  Obx(
                        () => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: SizedBox(
                        width: double.infinity, // đảm bảo có ràng buộc chiều rộng
                        child: PrimaryText(
                          text: controller.songController.state.song.value?.title ?? 'No name',
                          fontSize: 20,
                          maxLine: 2,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),

                  Obx(
                    () => Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PrimaryText(
                            text: (controller.songController.state.song.value!
                                    .artist.isNotEmpty)
                                ? controller
                                    .songController.state.song.value!.artist
                                : 'Unknown Artist',
                            color: Colors.white,
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  print(controller.songController.state.lyrics);
                                },
                                icon: const Icon(
                                  Icons.share_outlined,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  controller.addToFavorite();
                                },
                                icon: Obx(
                                  () => (controller.songController.state.song
                                              .value?.isLiked ??
                                          false)
                                      ? Icon(
                                          Icons.favorite_sharp,
                                          color: Color(0xFF39C0D4),
                                        )
                                      : Icon(
                                          Icons.favorite_border_outlined,
                                          color: Color(0xFF39C0D4),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Obx(() {
                    final max =
                        controller.duration.value.inMilliseconds.toDouble();
                    double value = controller.sliderValue.value.clamp(0, max);

                    return Slider(
                      activeColor: Color(0xFF7CEEFF),
                      min: 0,
                      max: max > 0 ? max : 1,
                      value: value,
                      onChanged: (val) {
                        controller.isDragging.value = true;
                        controller.sliderValue.value = val;
                        controller.playerController.seekTo(value.toInt());
                      },
                      onChangeEnd: (val) {
                        controller.isDragging.value = false;
                        controller.seekTo(val);
                      },
                    );
                  }),
                  Obx(
                    () => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PrimaryText(
                              text: controller
                                  .formatDuration(controller.position.value)),
                          PrimaryText(
                            text: controller
                                .formatDuration(controller.duration.value),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Obx(
                          () => IconButton(
                            onPressed: () {
                              print("==================>");
                              controller.isShuffle.toggle();
                              controller.shuffleSongs();
                            },
                            icon: Icon(
                              Icons.shuffle,
                              color: controller.isShuffle.value
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            controller.playPreviousSong();
                          },
                          icon: const Icon(
                            Icons.skip_previous,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        Obx(
                          () => GestureDetector(
                            onTap: () {
                              controller.playPauseMusic();
                            },
                            child: Container(
                              width: 65,
                              height: 65,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFA6F3FF),
                                      Color(0xFF00C2CB)
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter),
                              ),
                              child: Icon(
                                controller.songController.state.isPlay.value
                                    ? Icons.pause_outlined
                                    : Icons.play_arrow_rounded,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            controller.playNextSong();
                          },
                          icon: const Icon(
                            Icons.skip_next,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Get.toNamed(
                              Routes.queue.p,
                            );
                          },
                          icon: const Icon(
                            Icons.queue_music_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PrimaryText(
                    text: "Lyrics".toUpperCase(),
                    color: const Color(0xFF8A9A9D),
                  ),
                  Obx(() => controller.songController.state.lyrics.isEmpty
                      ? Transform.scale(
                          scale: 2,
                          child: Lottie.asset(
                            'assets/lottie/empty_lyrics.json',
                            width: 200,
                            height: 120,
                            fit: BoxFit.contain,
                            repeat: true,
                          ),
                        )
                      : Container(
                          height: 105,
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF39C0D4), Color(0xFF7CEEFF)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: controller.lyricScrollController,
                            shrinkWrap: true,
                            itemCount:
                                controller.songController.state.lyrics.length,
                            itemBuilder: (context, index) {
                              final isCurrent = index ==
                                  controller.songController.state
                                      .currentLyricIndex.value;
                              return Container(
                                alignment: Alignment.topCenter,
                                padding: EdgeInsets.only(top: 5, bottom: 5),
                                child: PrimaryText(
                                  text: controller
                                      .songController.state.lyrics[index].text,
                                  color: isCurrent
                                      ? Color(0xFFFFFA8D)
                                      : Colors.white,
                                  fontWeight: isCurrent
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              );
                            },
                          ),
                        )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
