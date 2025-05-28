import 'package:bloomy/routes/route.dart';
import 'package:bloomy/views/menu/menu_logic.dart';
import 'package:bloomy/widgets/primary_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MenuLogic>(() => MenuLogic());
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
                  onPressed: () {},
                  icon: Icon(
                    Icons.favorite_border_outlined,
                    color: Color(0xFF7CEEFF),
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.asset(
                      controller.state.song.value.coverImage,
                      fit: BoxFit.cover,
                    ),
                  ),
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
              Get.toNamed(Routes.addPlaylist.p, arguments: controller.state.song.value);
            }),
            buildMenuItem(Icons.queue_music_outlined, "Add to queue", () {}),
            Obx(
              () => controller.state.inAlbum.value
                  ? buildMenuItem(Icons.playlist_remove, "Remove from playlist",
                      () {
                      controller.removeFormPlaylist();
                    })
                  : buildHideMenuItem(
                      Icons.playlist_remove,
                      "Remove from playlist",
                    ),
            ),
            buildMenuItem(Icons.local_offer_outlined, "Modify tags", () {
              controller.songService.addLyricPathToSong(controller.state.song.value.id, controller.state.song.value.getLyricAssetPath);
              print("đã thêm lyric");
            }),
            buildMenuItem(Icons.person_outline, "View Artist", () {}),
            buildMenuItem(Icons.album_outlined, "View Album", () {}),
            buildMenuItem(Icons.info_outline, "Show Credits", () {}),
            buildMenuItem(Icons.share_outlined, "Share", () {}),
            buildMenuItem(Icons.remove_circle_outline, "Delete Song", () {
              controller.deleteSong();
              Get.back();
            }),
          ],
        ),
      ),
    );
  }
}

// Hàm dựng từng item
Widget buildMenuItem(IconData icon, String text, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
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
