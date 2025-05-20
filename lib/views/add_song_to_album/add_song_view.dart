import 'package:bloomy/routes/route.dart';
import 'package:bloomy/views/add_song_to_album/add_song_logic.dart';
import 'package:bloomy/widgets/primary_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddSongBinding extends Bindings {
  @override
  void dependencies() {
    return Get.lazyPut<AddSongLogic>(() => AddSongLogic());
  }
}

class AddSongView extends GetView<AddSongLogic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: PrimaryText(
          text: "Thêm bài hát",
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(children: [
          TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              prefixIconColor: Color(0xFF8A9A9D),
              filled: true,
              // Kích hoạt nền
              fillColor: Colors.white,
              hintText: "Song, Artist, PodCast & More",
              hintStyle: GoogleFonts.aBeeZee(
                color: Color(0xFF8A9A9D),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18), // Bo góc khi focus
                borderSide: BorderSide(
                    color: const Color(0xFF8A9A9D)), // Viền khi focus
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                // Bo góc khi không focus
                borderSide: BorderSide.none, // Không viền khi không focus
              ),
            ),
            cursorColor: Colors.black,
            style: GoogleFonts.aBeeZee(
              color: const Color(0xFF333333),
              fontSize: 16,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Obx(() => Expanded(
                child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final item = controller.state.songs[index];
                      final isAdded = controller.state.addedSongIds.contains(item.id);

                      return Container(
                        width: double.infinity,
                        height: 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.asset(
                                      item.coverImage,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                PrimaryText(
                                  text: item.title,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: isAdded
                                  ? null
                                  : () => controller.addToAlbum(item),
                              icon: Icon(
                                isAdded ? Icons.check : Icons.add_circle_outline,
                                color: isAdded ? Colors.grey : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => SizedBox(
                          height: 15,
                        ),
                    itemCount: controller.state.songs.length),
              ),),
        ]),
      ),
    );
  }
}
