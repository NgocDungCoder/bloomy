import 'package:bloomy/views/stat/stat_logic.dart';
import 'package:bloomy/widgets/primary_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class StatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StatLogic(Get.find(), Get.find()));
  }
}

class StatView extends StatefulWidget {
  @override
  State<StatView> createState() => _StatViewState();
}

class _StatViewState extends State<StatView> {
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<StatLogic>();
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PrimaryText(
                text: "Top",
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              PrimaryText(
                text: "Past 30 days",
                fontSize: 13,
                color: Color(0xFF8A9A9D),
              ),
            ],
          ),
          centerTitle: true,
          actions: [
            Obx(
              () => IconButton(
                onPressed: () {
                  logic.state.isGridView.toggle();
                },
                icon: logic.state.isGridView.value
                    ? Icon(Icons.list_alt) : Icon(Icons.grid_view),
                color: Colors.white,
              ),
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(logic.state.tops.length, (index) {
                  final top = logic.state.tops[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        logic.selectedIndex.value = index;
                      });
                      pageController.animateToPage(
                        index,
                        duration: Duration(milliseconds: 800),
                        curve: Curves.ease,
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      width: MediaQuery.of(context).size.width * 0.3,
                      decoration: BoxDecoration(
                        border: logic.selectedIndex.value == index
                            ? Border(
                                bottom: BorderSide(
                                    color: Color(0xFF39C0D4), width: 3),
                              )
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          top,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: logic.selectedIndex.value == index
                                ? Color(0xFF39C0D4)
                                : Colors.white,
                            shadows: logic.selectedIndex.value == index
                                ? [
                                    Shadow(
                                      blurRadius: 10, // Độ mờ
                                      color: Color(0xFF39C0D4).withOpacity(0.8),
                                      offset: Offset(0, 0),
                                    ),
                                  ]
                                : [],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(
                height: 740,
                child: PageView(
                  controller: pageController,
                  onPageChanged: (index) {
                    setState(() {
                      logic.selectedIndex.value = index;
                    });
                  },
                  children: const [
                    TopTracksPage(),
                    TopAlbumsPage(),
                    TopArtistsPage(),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class TopTracksPage extends StatelessWidget {
  const TopTracksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<StatLogic>();

    return Obx(() {
      final tracks = logic.state.tracks;
      final isGrid = logic.state.isGridView.value;

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: isGrid
            ? GridView.builder(
          key: const ValueKey("grid"), // key để phân biệt chế độ
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.86,
          ),
          itemCount: tracks.length,
          itemBuilder: (context, index) {
            final track = tracks[index];
            return TopGridItemCard(
              index: index,
              image: track.coverImage ?? "assets/images/img999.jpg",
              title: track.title ?? "",
              subtitle: track.artist,
            );
          },
        )
            : ListView.separated(
          key: const ValueKey("list"),
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemCount: tracks.length,
          separatorBuilder: (_, __) => const SizedBox(height: 15),
          itemBuilder: (context, index) {
            final track = tracks[index];
            return TopListItemCard(
              index: index,
              image: track.coverImage ?? "assets/images/img999.jpg",
              title: track.title ?? "",
              subtitle: track.artist,
            );
          },
        ),
      );
    });
  }
}

class TopAlbumsPage extends StatelessWidget {
  const TopAlbumsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<StatLogic>();

    return Obx(() {
      final albums = Get.find<StatLogic>().state.albums;
      final isGrid = logic.state.isGridView.value;

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: isGrid
          ? GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.86, // Tuỳ chỉnh theo layout
        ),
        itemCount: albums.length,
        itemBuilder: (context, index) {
          final album = albums[index];
          return TopGridItemCard(
            index: index,
            image: album.coverImage ?? "assets/images/img999.jpg",
            title: album.name ?? "",
            subtitle: "${album.songs.length} songs",
          );
        },
      ) : ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: albums.length,
        separatorBuilder: (_, __) => const SizedBox(height: 15),
        itemBuilder: (context, index) {
          final album = albums[index];
          return TopListItemCard(
            index: index,
            image: album.coverImage,
            title: album.name,
            subtitle: "${album.songs.length} songs",
          );
        },
      ), );
    });
  }
}


class TopArtistsPage extends StatelessWidget {
  const TopArtistsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final artists = Get.find<StatLogic>().state.artists;
      return ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: artists.length,
        separatorBuilder: (_, __) => const SizedBox(height: 15),
        itemBuilder: (context, index) {
          final artist = artists[index];
          return TopListItemCard(
            index: index,
            image: artist.image,
            title: artist.name,
            subtitle: "Lượt nghe: 0",
          );
        },
      );
    });
  }
}



class TopListItemCard extends StatelessWidget {
  final int index;
  final String image;
  final String title;
  final String subtitle;

  const TopListItemCard({
    super.key,
    required this.index,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 370,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: Center(
              child: PrimaryText(
                text: "#${index + 1}",
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset(
              image,
              width: 75,
              height: 75,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.5,
            padding: const EdgeInsets.only(left: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrimaryText(
                  text: title,
                  fontWeight: FontWeight.bold,
                ),
                PrimaryText(
                  text: subtitle,
                  fontSize: 14,
                  color: const Color(0xFF8A9A9D),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TopGridItemCard extends StatelessWidget {
  final int index;
  final String image;
  final String title;
  final String subtitle;

  const TopGridItemCard({
    super.key,
    required this.index,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.asset(
                image,
                height: 100,
                width: 155,
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black,
                      Colors.transparent,
                      Colors.transparent,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),


            Positioned(
              left: 5,
              top: 2,
              child: PrimaryText(
                text: "#${index + 1}",
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrimaryText(
                    text: title,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    maxLine: 2,
                  ),
                  PrimaryText(
                    text: subtitle,
                    fontSize: 12,
                    color: const Color(0xFF8A9A9D),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
