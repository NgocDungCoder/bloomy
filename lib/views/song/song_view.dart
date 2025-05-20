import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:bloomy/routes/route.dart';
import 'package:bloomy/controllers/song_controller.dart';
import 'package:bloomy/views/song/song_logic.dart';
import 'package:bloomy/widgets/primary_text.dart';

import 'components/waveform_animation.dart';


class SongBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SongLogic>(() => SongLogic());
  }
}

class SongView extends StatefulWidget {
  const SongView({super.key});

  @override
  State<SongView> createState() => _SongViewState();
}

class _SongViewState extends State<SongView> {
  final songController = Get.find<SongController>();
  final logic = Get.find<SongLogic>();

  final keyImage = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        return Padding(
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
                        const Padding(
                          padding: EdgeInsets.only(right: 10.0),
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
                            const PrimaryText(
                              text: "Lofi lofi",
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF7CEEFF),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  // IconButton(
                  //   onPressed: () => Get.toNamed(Routes.menu.p,
                  //       arguments: songController.currentSong.value),
                  //   icon: const Icon(
                  //     Icons.more_vert_outlined,
                  //     color: Colors.white,
                  //   ),
                  // ),
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    key: keyImage,
                    width: 340,
                    height: 340,
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        image: AssetImage(
                          logic.songTemp.value?.coverImage.isEmpty ?? true
                              ? 'assets/images/img1.jpg'
                              : logic.songTemp.value!.coverImage,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 10,
                            spreadRadius: 5,
                          ),
                        ],
                        gradient: const LinearGradient(
                          colors: [
                            Colors.black,
                            Colors.transparent,
                          ],
                          stops: [0.3, 1],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: AnimatedWaveform(
                      samples: logic.waveFormData,
                      progress: logic.progress.value,
                      liveColor: const Color(0xFF39C0D4),
                      fixedColor: Colors.grey.withOpacity(0.5),
                      onTap: (position) {
                        final seekPosition = position * logic.duration.value.inMilliseconds;
                        logic.seekTo(seekPosition);
                      },
                    ),

                  ),
                ],
              ),
              // Obx(
              //       () => Padding(
              //     padding: const EdgeInsets.only(left: 10.0),
              //     child: PrimaryText(
              //       text: (songController.currentSong.value!.title.isNotEmpty)
              //           ? songController.currentSong.value!.title
              //           : 'No name ',
              //       fontSize: 20,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
              // Obx(
              //       () => Padding(
              //     padding: const EdgeInsets.only(left: 10.0),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         PrimaryText(
              //           text: (songController.currentSong.value!.artist.isNotEmpty)
              //               ? songController.currentSong.value!.artist
              //               : 'Unknown Artist',
              //           color: Colors.white,
              //         ),
              //         Row(
              //           children: [
              //             IconButton(
              //               onPressed: () {},
              //               icon: const Icon(
              //                 Icons.share_outlined,
              //                 color: Colors.white,
              //               ),
              //             ),
              //             IconButton(
              //               onPressed: () {},
              //               icon: const Icon(
              //                 Icons.favorite_border_outlined,
              //                 color: Color(0xFF39C0D4),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              Obx(() {
                final max = logic.duration.value.inMilliseconds.toDouble();
                double value = logic.position.value.inMilliseconds.toDouble().clamp(0, max > 0 ? max : 1);

                return Slider(
                  activeColor: const Color(0xFF7CEEFF),
                  min: 0,
                  max: max > 0 ? max : 1,
                  value: value,
                  onChanged: (val) {
                    logic.seekTo(val);
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
                          text: logic.formatDuration(logic.position.value)),
                      PrimaryText(
                        text: logic.formatDuration(logic.duration.value),
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
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.shuffle,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.skip_previous,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    Obx(
                          () => GestureDetector(
                        onTap: () {
                          logic.playPause();
                        },
                        child: Container(
                          width: 65,
                          height: 65,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                                colors: [Color(0xFFA6F3FF), Color(0xFF00C2CB)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter),
                          ),
                          child: Icon(
                            logic.isPlaying.value
                                ? Icons.pause_outlined
                                : Icons.play_arrow_rounded,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.skip_next,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Get.toNamed(Routes.queue.p,
                        //     arguments: songController.currentSong.value);
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
              Container(
                height: 250,
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xFF39C0D4), Color(0xFF7CEEFF)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListView(
                  children: [
                    const PrimaryText(
                      text: 'Nobody ever loved me like she does\n'
                          '    Ooh, she does\n'
                          '    Yes, she does\n\n'
                          'And if somebody loved like she do me\n'
                          '    Ooh, she do me\n'
                          '    Yes, she does\n\n'
                          'Don\'t let me down\n'
                          'Don\'t let me down\n'
                          'Don\'t let me down\n'
                          'Don\'t let me down\n\n'
                          'I\'m in love for the first time\n'
                          'Don\'t you know it\'s gonna last?\n'
                          'It\'s a love that lasts forever\n'
                          'It\'s a love that has no past\n\n'
                          'Don\'t let me down\n'
                          'Don\'t let me down (ooh)\n'
                          'Don\'t let me down\n'
                          'Don\'t let me down',
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
