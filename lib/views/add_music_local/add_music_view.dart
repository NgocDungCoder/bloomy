import 'package:bloomy/configs/colors.dart';
import 'package:bloomy/controllers/song_controller.dart';
import 'package:bloomy/models/song_model.dart';
import 'package:bloomy/services/music_player_service.dart';
import 'package:bloomy/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/confirmable_button.dart';
import '../../widgets/primary_text.dart';

class AddMusicLocal extends StatefulWidget {
  const AddMusicLocal({super.key});

  @override
  State<AddMusicLocal> createState() => _OfflineMusicPlayerState();
}

class _OfflineMusicPlayerState extends State<AddMusicLocal> {
  final SongController _controller = SongController();
  final MusicPlayerService _player = MusicPlayerService();

  List<SongModel> songs = [];

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _loadSongs() async {
    List<SongModel> loaded = await _controller.loadSongs();
    setState(() => songs = loaded);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
        ),
        title: PrimaryText(
          text: "Add new song",
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          PrimaryButton(
            text: "Add MP3",
            onPressed: () => _controller.addSong(context, _loadSongs),
          ),
          SizedBox(
            height: 15,
          ),
          ConfirmableButton(
            text: "Delete all MP3",
            backgroundColor: AppColors.buttonRed,
            confirmTitle: "Confirm",
            confirmMessage: "Do you want to delete all songs?",
            confirmText: "Delete",
            cancelText: "Cancel",
            onConfirmed: () => _controller.removeAllSongs(),
          ),
          Divider(
            color: Colors.white,
            thickness: 1,
            indent: 15,
            endIndent: 15,
            height: 30,
          ),
          Expanded(
              child: songs.isEmpty
                  ? const Center(
                      child: PrimaryText(
                      text: 'Don\'t have anysong',
                      color: AppColors.textWhite,
                    ))
                  : Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
                      child: ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final song = songs[index];
                            return AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              width: double.infinity,
                              height: 100,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Colors.transparent,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: Image.asset(
                                              song.coverImage ?? "",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
                                          child: PrimaryText(
                                            text: song.title,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => SizedBox(
                                height: 15,
                              ),
                          itemCount: songs.length),
                    )),
        ],
      ),
    );
  }
}
