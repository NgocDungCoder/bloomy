import 'package:bloomy/routes/route.dart';
import 'package:bloomy/views/queue/queue_logic.dart';
import 'package:bloomy/widgets/primary_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QueueBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QueueLogic>(() => QueueLogic());
  }
}

class QueueView extends GetView<QueueLogic> {
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PrimaryText(
                        text: "Playing from playlist:".toUpperCase(),
                        fontSize: 12,
                      ),
                      Obx(() => PrimaryText(
                            text: controller.state.albumName.value,
                            maxLine: 2,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7CEEFF),
                          ))
                    ],
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
            SizedBox(
              height: 15,
            ),
            Obx(
              () => InkWell(
                child: Container(
                  height: 70,
                  margin: EdgeInsets.symmetric(
                    vertical: 15,
                  ),
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
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.asset(
                                  (controller.state.song.value.coverImage
                                              ?.isNotEmpty ??
                                          false)
                                      ? controller.state.song.value.coverImage!
                                      : "assets/images/img999.jpg",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: PrimaryText(
                                        text: controller.state.song.value.title,
                                        maxLine: 2,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    PrimaryText(
                                      text: controller.state.song.value.artist,
                                      fontSize: 13,
                                      color: Color(0xFF8A9A9D),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          controller.printSong();
                        },
                        icon: Icon(
                          Icons.more_vert_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: PrimaryText(
                text: "next in queue:",
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 600,
              child: Obx(
                () => ReorderableListView.builder(
                  key:
                      ValueKey(controller.albumController.refreshTrigger.value),
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
                  itemCount: controller.albumController.waitingSongs.length,
                  itemBuilder: (context, index) {
                    final song = controller.albumController.waitingSongs[index];
                    return InkWell(
                      key: Key(song.filePath),
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
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
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
                  onReorder: (oldIndex, newIndex) {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final item = controller.albumController.waitingSongs
                        .removeAt(oldIndex);
                    controller.albumController.waitingSongs
                        .insert(newIndex, item);
                    controller.albumController.waitingSongs.refresh();
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
