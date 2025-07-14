import 'package:bloomy/views/add_to_playlist/add_playlist_logic.dart';
import 'package:bloomy/widgets/primary_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddPlaylistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddPlaylistLogic>(() => AddPlaylistLogic());
  }

}

class AddPlaylistView extends GetView<AddPlaylistLogic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: PrimaryText(
          text: "Add to Playlist",
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        centerTitle: true,
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                height: 65,
                width: 204,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF06A0B5), // Màu phát sáng
                      blurRadius: 15, // Độ mờ của hào quang
                      spreadRadius: 5, // Độ lan của hào quang
                    ),
                  ],
                ),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF06A0B5), // Màu nền của nút
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50), // Bo góc
                      ),
                    ),
                    onPressed: () {},
                    child: PrimaryText(
                      text: "New Playlist",
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ))),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 354,
              margin: EdgeInsets.only(top: 20, bottom: 40),
              child: TextField(
                style: GoogleFonts.aBeeZee(color: Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.search_outlined),
                  prefixIconColor: Color(0xFF8A9A9D),
                  hintText: "Find Playlist",
                  hintStyle: GoogleFonts.aBeeZee(
                    color: Color(0xFF8A9A9D),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(18),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(18),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Obx(() => ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final item = controller.state.albums[index];
                  return InkWell(
                    onTap: () {
                      controller.addSongToPlaylist(item.id);
                      Get.back();
                    },
                    child: Row(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PrimaryText(
                                text: item.name,
                                maxLine: 2,
                                fontWeight: FontWeight.bold,
                              ),
                              PrimaryText(
                                text: "${item.songs.length} songs",
                                color: Color(0xFF8A9A9D),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (_, __) => SizedBox(
                  height: 15,
                ),
                itemCount: controller.state.albums.length),),
          )
        ],
      ),
    );
  }
}
