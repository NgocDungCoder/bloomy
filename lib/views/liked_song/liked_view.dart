import 'package:bloomy/routes/route.dart';
import 'package:bloomy/views/float_play/float_play_view.dart';
import 'package:bloomy/views/liked_song/liked_logic.dart';
import 'package:bloomy/widgets/primary_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/liked_service.dart';
import '../../services/song_service.dart';
import '../../widgets/custom_bottom_sheet.dart';
import '../../widgets/show_confirm_dialog.dart';
import '../../widgets/snackbar.dart';

class LikedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LikedLogic>(() => LikedLogic(
          Get.find(),
          Get.find(),
        ));
  }
}

class LikedView extends GetView<LikedLogic> {
  @override
  Widget build(BuildContext context) {
    // var album = controller.state.album.value;
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: PrimaryText(
            text: "Your liked songs",
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          backgroundColor: Colors.black,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                CustomBottomSheet.show(context, children: [
                  Center(
                    child: PrimaryText(
                      text: "Favorite options",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Divider(thickness: 1, color: Colors.white, height: 30,),

                  ListTile(
                    leading: const Icon(Icons.play_arrow_rounded,
                        color: Colors.white),
                    title: const PrimaryText(text: 'Phát tất cả',
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.toNamed(
                        Routes.song.p,
                        arguments: {
                          'song': controller.album.value!.songs[0],
                          'album': controller.album.value,
                          // chỉ thêm nếu có
                        },
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.edit, color: Colors.white),
                    title: const PrimaryText(text: 'Edit Favorite',
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.toNamed(Routes.editAlbum.p, arguments: {"album": controller.album.value});

                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.library_add, color: Colors.white),
                    title: const PrimaryText(text: 'Thêm bài hát',
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.toNamed(Routes.addSong.p,
                          arguments: controller.album.value);
                      // Thực hiện hành động thêm bài hát
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    title: const PrimaryText(text: 'Delete all favorite',
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                    onTap: () {
                      showConfirmationDialog(
                        context: context,
                        title: 'Confirm',
                        message: 'Are you sure?',
                        onConfirmed: () {
                          Navigator.of(context).pop();
                          controller.deleteAllLiked();

                        },
                      );
                    },
                  ),
                ]);
              },
              icon: Icon(
                Icons.more_vert_outlined,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      Container(
                        width: 254,
                        height: 254,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.asset(
                            "assets/images/favorite.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: PrimaryText(
                          text: "Your liked songs",
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: PrimaryText(
                          text: "soft, chill, dreamy",
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8A9A9D),
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Obx(() {
                          final song = controller.likedSongs[index];

                          return InkWell(
                            onTap: () => Get.toNamed(
                              Routes.song.p,
                              arguments: {
                                'song': song,
                                'album': controller.album.value, // chỉ thêm nếu có
                              },
                            ),
                            child: Container(
                              height: 70,
                              margin: EdgeInsets.only(
                                  top: 10, bottom: 10, left: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 70,
                                          width: 70,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: Image.asset(
                                              song.coverImage?.isNotEmpty == true
                                                  ? song.coverImage!
                                                  : "assets/images/img999.jpg",

                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                PrimaryText(
                                                  text: song.title ?? "Không tên",

                                                  fontWeight: FontWeight.bold,
                                                ),
                                                PrimaryText(
                                                  text: song.artist ?? "Không rõ",
                                                  fontSize: 13,
                                                  color: Color(0xFF8A9A9D),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                    },
                                    icon: Icon(
                                      Icons.more_vert_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                      },
                      separatorBuilder: (_, __) => SizedBox(
                            height: 15,
                          ),
                      itemCount: controller.likedSongs.length),
                ),
              ],
            ),
            FloatPlayView(),
          ],
        ));
  }
}
