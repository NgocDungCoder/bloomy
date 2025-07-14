import 'package:bloomy/routes/route.dart';
import 'package:bloomy/views/album/playlist_logic.dart';
import 'package:bloomy/views/float_play/float_play_view.dart';
import 'package:bloomy/widgets/primary_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/custom_bottom_sheet.dart';
import '../../widgets/show_confirm_dialog.dart';
import '../../widgets/snackbar.dart';

class PlaylistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlaylistLogic>(() => PlaylistLogic());
  }
}

class PlaylistView extends GetView<PlaylistLogic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Obx(
          () => PrimaryText(
            text: "${controller.state.album.value.name}",
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
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
              Get.toNamed(Routes.addSong.p,
                  arguments: controller.state.album.value);
            },
            icon: Icon(
              Icons.add_circle_outline,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              CustomBottomSheet.show(context, children: [
                Center(
                  child: PrimaryText(
                    text: "Album options",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: Colors.white,
                  height: 30,
                ),
                ListTile(
                  leading:
                      const Icon(Icons.play_arrow_rounded, color: Colors.white),
                  title: const PrimaryText(
                      text: 'Phát tất cả',
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  onTap: () {
                    Navigator.of(context).pop();
                    Get.toNamed(
                      Routes.song.p,
                      arguments: {
                        'song': controller.state.album.value.songs[0],
                        'album': controller.state.album.value,
                        // chỉ thêm nếu có
                      },
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.favorite_sharp,
                    color: Colors.white,
                  ),
                  title: const PrimaryText(
                    text: 'Thêm tất cả vào yêu thích',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    controller.addAllToFavorite();
                    // Thực hiện hành động
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.edit, color: Colors.white),
                  title: const PrimaryText(
                      text: 'Chỉnh sửa album',
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  onTap: () {
                    Navigator.of(context).pop();
                    Get.toNamed(Routes.editAlbum.p,
                        arguments: {"album": controller.state.album.value});
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.library_add, color: Colors.white),
                  title: const PrimaryText(
                      text: 'Thêm bài hát',
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  onTap: () {
                    Navigator.of(context).pop();
                    Get.toNamed(Routes.addSong.p,
                        arguments: controller.state.album.value);
                    // Thực hiện hành động thêm bài hát
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  title: const PrimaryText(
                      text: 'Delete Album',
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  onTap: () {
                    showConfirmationDialog(
                      context: context,
                      title: 'Confirm',
                      message: 'Are you sure?',
                      onConfirmed: () async {
                        Navigator.of(context).pop();
                        await controller
                            .deleteAlbum(controller.state.album.value.id);
                        Get.back();
                        showCustomSnackbar(
                          message: 'Deleted Album',
                          type: SnackbarType.success,
                        );
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
                          controller.state.album.value.coverImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Obx(() => PrimaryText(
                            text: controller.state.album.value.name,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          )),
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
              Obx(() {
                final hasSongs = controller.state.album.value.songs.isNotEmpty;

                return hasSongs
                    ? ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Obx(() {
                            final song =
                                controller.state.album.value.songs[index];

                            return InkWell(
                              onTap: () => Get.toNamed(
                                Routes.song.p,
                                arguments: {
                                  'song': song,
                                  'album': controller.state.album.value,
                                  // chỉ thêm nếu có
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
                                                song.coverImage ?? "",
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
                                                  FittedBox(
                                                    child: PrimaryText(
                                                      text: song.title,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      maxLine: 2,
                                                    ),
                                                  ),
                                                  PrimaryText(
                                                    text: song.artist,
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
                                      onPressed: () {},
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
                        itemCount: controller.state.album.value.songs.length)
                    : Container(
                  height: 300,
                      child: Center(
                      child: PrimaryText(text: "Don't have any song !"),
                                            ),
                    );
              }),
            ],
          ),
          FloatPlayView(),
        ],
      ),
    );
  }
}
