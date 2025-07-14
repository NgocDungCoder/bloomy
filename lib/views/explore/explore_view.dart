import 'package:bloomy/views/explore/explore_logic.dart';
import 'package:bloomy/widgets/primary_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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

            //Your Top Genres
            const Padding(
              padding: EdgeInsets.only(bottom: 10.0, top: 20),
              child: PrimaryText(
                text: "Your Top Genres",
                fontSize: 18,
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),

              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 20,
                  childAspectRatio: 1.6),
              itemBuilder: (context, index) {
                final genres = logic.state.genresList[index];
                return Stack(children: [
                  Container(
                    decoration: BoxDecoration(
                      color: logic.state.colors[index],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),

                  Positioned(
                    right: -10,
                    bottom: -15,
                    child: Transform.rotate(
                      angle: 0.4,
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.asset(genres.coverImage, fit: BoxFit.cover,),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 15,
                    child: PrimaryText(text: genres.name),
                  ),
                ]);
              },
              itemCount: logic.state.genresList.length,
            ),

            //Browse All
            const Padding(
              padding: EdgeInsets.only(bottom: 10.0, top: 20),
              child: PrimaryText(
                text: "Browse All",
                fontSize: 18,
              ),
            ),
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 20,
                  childAspectRatio: 1.6),
              itemBuilder: (context, index) {
                final browse = logic.state.browseList[index];
                return Stack(children: [
                  Container(
                    decoration: BoxDecoration(
                      color: logic.state.colors2[index],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),

                  Positioned(
                    right: -10,
                    bottom: -15,
                    child: Transform.rotate(
                      angle: 0.4,
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.asset(browse.coverImage, fit: BoxFit.cover,),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 15,
                    child: PrimaryText(text: browse.name),
                  ),
                ]);
              },
              itemCount: logic.state.browseList.length,
            ),
          ],
        ),
      ),
    );
  }
}
