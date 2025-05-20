import 'package:bloomy/routes/route.dart';
import 'package:bloomy/views/float_play/float_play_view.dart';
import 'package:bloomy/views/playlist/playlist_logic.dart';
import 'package:bloomy/widgets/primary_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlaylistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlaylistLogic>(() => PlaylistLogic());
  }
}

class PlaylistView extends GetView<PlaylistLogic> {
  @override
  Widget build(BuildContext context) {
    var album = controller.state.album.value;
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: PrimaryText(
            text: "${album.name}",
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
                Get.toNamed(Routes.addSong.p, arguments: controller.state.album.value);
              },
              icon: Icon(
                Icons.add_circle_outline,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                controller.deleteAlbum(controller.state.album.value.id);
                Get.back();
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
                            album.coverImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: PrimaryText(
                          text: album.name,
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
                        final song = controller.state.album.value.songs[index];
                        return InkWell(
                          onTap: () => Get.toNamed(Routes.song.p,arguments: {
                            'song': song,
                            'album': controller.state.album.value, // chỉ thêm nếu có
                          },),
                          child: Container(
                            height: 70,
                            margin: EdgeInsets.only(top: 10, bottom: 10, left: 20),
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
                                            song.coverImage,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 10.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: PrimaryText(
                                                    text: song.title,
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
                      },
                      separatorBuilder: (_, __) => SizedBox(
                            height: 15,
                          ),
                      itemCount:  controller.state.album.value.songs.length),
                ),
              ],
            ),
            // FloatPlayView(),
          ],
        ));
  }
}
