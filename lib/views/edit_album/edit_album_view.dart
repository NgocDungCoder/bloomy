import 'package:bloomy/configs/colors.dart';
import 'package:bloomy/routes/route.dart';

import 'package:bloomy/widgets/primary_text.dart';
import 'package:bloomy/widgets/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'edit_album_logic.dart';

class EditAlbumBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditAlbumLogic>(() => EditAlbumLogic(Get.find(), Get.find()));
  }
}

class EditAlbumView extends GetView<EditAlbumLogic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  // onTap: () => Get.toNamed(Routes.playlist.p),
                  child: PrimaryText(
                    text: "Edit Album:",
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Obx(() {
              if (controller.isEditing.value) {
                return Container(
                  height: 27,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller.nameController,
                          maxLines: 1,
                          cursorColor: Colors.white,
                          style: GoogleFonts.aBeeZee(
                            fontWeight: FontWeight.bold,
                            color: AppColors.mint,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),

                        ),
                      ),
                      // Bạn có thể thêm nút xác nhận bên phải ở đây nếu cần
                      IconButton(
                          icon: Icon(Icons.check, color: AppColors.mint),
                          padding: EdgeInsets.only(bottom: 5),
                          onPressed: () async {
                            final trimmedName = controller.nameController.text
                                .trim();

                            if (trimmedName.isEmpty) {
                              showCustomSnackbar(message: "Don\'t leave blank",
                                  type: SnackbarType.warning);
                              controller.isEditing.value = false;
                              controller.nameController.text =
                                  controller.album.value.name;
                              return;
                            }

                            controller.album.value =
                                controller.album.value.copyWith(
                                    name: trimmedName);
                            controller.isEditing.value = false;
                            await controller.updateAlbum();
                            await controller.refreshLibrary();
                          }

                      ),
                    ],
                  ),
                );
              } else {
                return GestureDetector(
                  onTap: () {
                    controller.nameController.text =
                        controller.album.value.name;
                    controller.isEditing.value = true;
                  },
                  child: PrimaryText(
                    text: controller.album.value.name,
                    maxLine: 2,
                    fontWeight: FontWeight.bold,
                    color: AppColors.mint,
                  ),
                );
              }
            }),
            Divider(
              thickness: 1,
              color: Colors.white,
              height: 20,
            ),
            SizedBox(
              height: 700,
              child: Obx(
                    () =>
                    ReorderableListView.builder(
                      key: ValueKey(controller.refreshTrigger.value),
                      shrinkWrap: true,
                      proxyDecorator: (child, index, animation) {
                        return Material(
                          elevation: 4,
                          // Thêm bóng khi kéo
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[900]!.withOpacity(0.9),
                          // Màu nền tối khi kéo
                          child: child,
                        );
                      },
                      itemCount: controller.album.value.songs.length,
                      itemBuilder: (context, index) {
                        final song = controller.album.value.songs[index];
                        return InkWell(
                          key: Key(song.id),
                          onTap: () => Get.toNamed(Routes.song.p),
                          child: Container(
                            height: 70,
                            margin: EdgeInsets.only(bottom: 8, top: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 70,
                                        width: 70,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              5),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              5),
                                          child: Image.asset(
                                            song.coverImage ??
                                                "assets/images/img999.jpg",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.only(left: 10.0),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 255,
                                                child: PrimaryText(
                                                  text: song.title,
                                                  maxLine: 2,
                                                  fontWeight: FontWeight.bold,
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
                                Icon(
                                  Icons.swap_vert,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      onReorder: (oldIndex, newIndex) async {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        final item =
                        controller.album.value.songs.removeAt(oldIndex);
                        controller.album.value.songs.insert(newIndex, item);
                        await controller.updateAlbum();
                      },
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
