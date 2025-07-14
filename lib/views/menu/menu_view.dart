import 'package:bloomy/configs/theme.dart';
import 'package:bloomy/routes/route.dart';
import 'package:bloomy/views/home/home_logic.dart';
import 'package:bloomy/views/library/library_logic.dart';
import 'package:bloomy/views/menu/menu_logic.dart';
import 'package:bloomy/widgets/primary_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../configs/colors.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/snackbar.dart';

class MenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MenuLogic>(
        () => MenuLogic(Get.find(), Get.find(), Get.find(), Get.find()));
  }
}

class MenuView extends GetView<MenuLogic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    controller.addToFavorite();
                  },
                  icon: Obx(
                    () =>
                        (controller.songController.state.song.value?.isLiked ??
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
            Column(
              children: [
                Container(
                  width: 230,
                  height: 230,
                  margin: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Obx(() => ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.asset(
                          (controller.state.song.value.coverImage != "")
                              ? controller.state.song.value.coverImage!
                              : "assets/images/img999.jpg",
                          fit: BoxFit.cover,
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: PrimaryText(
                    text: controller.state.song.value.title,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                PrimaryText(
                  text: controller.state.song.value.artist,
                  color: Color(0xFF8A9A9D),
                  fontSize: 13,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            buildMenuItem(Icons.music_note_outlined, "Add to playlist", () {
              Get.toNamed(Routes.addPlaylist.p,
                  arguments: controller.state.song.value);
            }, context),
            buildMenuItem(
                Icons.queue_music_outlined, "Add to queue", () {}, context),
            Obx(
              () => controller.state.inAlbum.value
                  ? buildMenuItem(Icons.playlist_remove, "Remove from playlist",
                      () {
                      controller.removeFormPlaylist();
                    }, context)
                  : buildHideMenuItem(
                      Icons.playlist_remove,
                      "Remove from playlist",
                    ),
            ),
            buildMenuItem(Icons.local_offer_outlined, "Modify tags", () {
              showCustomSnackbar(
                message: 'Đã thay đổi',
              );
            }, context),
            buildMenuItem(Icons.person_outline, "View Artist", () {}, context),
            buildMenuItem(Icons.album_outlined, "View Album", () {}, context),
            buildMenuItem(Icons.info_outline, "Edit song",
                () => showEditSongDialog(context, controller), context),
            buildMenuItem(Icons.share_outlined, "Share", () {}, context),
            buildMenuItem(Icons.remove_circle_outline, "Delete Song", () async {
              await controller.deleteSong();
              await Get.find<LibraryLogic>().refreshLibrary();
              await Get.find<HomeLogic>().refreshSongs();
              Get.back();
              Get.back();
              showCustomSnackbar(
                message: 'Deleted Song',
              );
            }, context, needConfirm: true),
          ],
        ),
      ),
    );
  }
}

// Hàm dựng từng item
Widget buildMenuItem(IconData icon, String text, VoidCallback onTap, context,
    {bool needConfirm = false}) {
  return InkWell(
    onTap: () async {
      if (needConfirm) {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (_) => Dialog(
            backgroundColor: Colors.transparent, // Để gradient hiển thị
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: AppColors.tealGradient, // tím → xanh
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PrimaryText(
                    text: "Confirm",
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  PrimaryText(
                    text: "Are you sure?",
                    color: Colors.white70,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: PrimaryText(text: "Cancel", color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      PrimaryButton(
                        text: "Delete",
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        backgroundColor: AppColors.buttonRed,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
        if (confirmed == true) {
          onTap();
        }
      } else {
        onTap();
      }
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 20),
          Expanded(
            child: PrimaryText(
              text: text,
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildHideMenuItem(IconData icon, String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    child: Row(
      children: [
        Icon(
          icon,
          color: Color(0xFF8A9A9D),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF8A9A9D),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}

void showEditSongDialog(BuildContext context, controller) {
  final song = controller.state.song.value;
  final titleController = TextEditingController(text: song?.title ?? '');
  final artistController = TextEditingController(text: song?.artist ?? '');

  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: AppColors.greyBackground,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PrimaryText(
              text: "Chỉnh sửa bài hát",
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
            const SizedBox(height: 20),
            CustomUnderlineTextField(
              controller: titleController,
              hintText: 'Title',
            ),
            const SizedBox(height: 15),
            CustomUnderlineTextField(
              controller: artistController,
              hintText: 'Artist',
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancel",
                      style: TextStyle(color: Colors.white70)),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    final newTitle = titleController.text.trim();
                    final newArtist = artistController.text.trim();

                    if (newTitle != "" && newArtist != "") {
                      controller.updateSongInfo(newTitle, newArtist);
                      Navigator.of(context).pop();
                      Get.back();
                      showCustomSnackbar(
                        message: 'Changed Information',
                        type: SnackbarType.success,
                      );
                    } else {
                      showCustomSnackbar(
                        message: 'Please fill all',
                        type: SnackbarType.error,
                      );
                    }
                  },
                  child: const Text("Save"),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
