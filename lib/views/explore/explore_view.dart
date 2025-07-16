import 'package:bloomy/views/explore/explore_logic.dart';
import 'package:bloomy/widgets/primary_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../routes/route.dart';

class ExploreView extends StatelessWidget {
  const ExploreView({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<ExploreLogic>();
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: Container(
        padding: EdgeInsets.only(top: 0, left: 10, right: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xFF0E0E0E),
            Color(0xFF0E0E0E),
            Color(0xFF102B2D),
            Color(0xFF06A0B5),
          ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
        ),
        child: ListView(
          children: [
            Container(
              height: 90,
              padding: EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              child: PrimaryText(
                text: "Search",
                fontSize: 25,
                color: Color(0xFF00C2CB),
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              onChanged: (value) {
                logic.onSearchChanged(value);
                logic.isSearching.value = true;
                if (value == "") {
                  logic.isSearching.value = false;
                }
                ;
              },
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
            Obx(
              () => logic.isSearching.value
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(logic.filteredSongs.length > 0)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: PrimaryText(text: "Songs", fontWeight: FontWeight.bold,),
                        ),
                        if(logic.filteredSongs.length > 0)
                          Obx(() => ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final item = logic.filteredSongs[index];

                              return InkWell(
                                onTap: () {
                                  Get.toNamed(Routes.song.p, arguments: {
                                    'song': item, // chỉ thêm nếu có
                                  });
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 100,
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
                                                  item.coverImage ?? "",
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Expanded(
                                              child: PrimaryText(
                                                text: item.title,
                                                maxLine: 2,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => SizedBox(
                              height: 15,
                            ),
                            itemCount: logic.filteredSongs.length),),
                        if(logic.filteredAlbums.length > 0)
                          Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: PrimaryText(text: "Albums", fontWeight: FontWeight.bold,),
                        ),
                        if(logic.filteredAlbums.length > 0)
                          Obx(() => ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final item = logic.filteredAlbums[index];

                              return InkWell(
                                onTap: () {
                                  Get.toNamed(Routes.playlist.p, arguments: item);
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 100,
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
                                                  item.coverImage ?? "",
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Expanded(
                                              child: PrimaryText(
                                                text: item.name,
                                                maxLine: 2,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => SizedBox(
                              height: 15,
                            ),
                            itemCount: logic.filteredAlbums.length),),
                        if(logic.filteredSongs.length < 1 && logic.filteredAlbums.length <1)
                          SizedBox(
                            height: 600,
                            child: Center(
                              child: PrimaryText(text: "Don\'t have any result"),
                            ),
                          ),
                      ],
                    )
                  : SizedBox(
                      height: 600,
                      child: Center(
                        child: PrimaryText(text: "What are you looking for ?"),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
