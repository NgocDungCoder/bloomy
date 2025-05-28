import 'package:bloomy/enum/music_type.dart';
import 'package:bloomy/routes/route.dart';
import 'package:bloomy/views/library/library_logic.dart';
import 'package:bloomy/widgets/primary_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({super.key});

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween<double>(begin: 1, end: 0).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    final logic = Get.put(LibraryLogic());
    return Scaffold(
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
        child: Obx(() {
          final selecting = logic.state.isSelecting.value;
          return ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 90,
                    padding: EdgeInsets.only(left: 10),
                    alignment: Alignment.centerLeft,
                    child: PrimaryText(
                      text: "Your Library",
                      fontSize: 23,
                      color: Color(0xFF00C2CB),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.0, -0.1),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: selecting
                        ? Row(
                      key: ValueKey('selecting'),
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        PrimaryText(
                          text: "Đã chọn (${logic.state.selectedIds.length})",
                          fontSize: 12,
                        ),
                        IconButton(
                          onPressed: () {
                            Get.toNamed(Routes.create.p,
                                arguments: logic.state.selectedIds);
                          },
                          icon: Icon(
                            Icons.add_photo_alternate_outlined,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            logic.clearSelection();
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(width: 122, height: 15,),
                            IconButton(
                                                  key: ValueKey('not_selecting'),
                                                  onPressed: () {},
                                                  icon: Icon(
                            Icons.search,
                            color: Color(0xFF00C2CB),
                            size: 35,
                                                  ),
                                                ),
                          ],
                        ),
                  ),
                ],
              ),

              SizedBox(
                height: 35,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: logic.state.tags.length,
                  separatorBuilder: (_, __) => SizedBox(width: 15),
                  itemBuilder: (context, index) {
                    final tag = logic.state.tags[index];
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _animationController.forward(from: 0).then((_) {
                            logic.changeType(tag);
                            _animationController.reverse();
                          });
                        });
                      },
                      child: Obx(
                        () => Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(width: 1, color: Colors.white),
                              gradient: tag == logic.state.musicType.value
                                  ? LinearGradient(
                                      colors: [
                                          Color(0xFF15686B),
                                          Color(0xFF06A0B5)
                                        ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter)
                                  : null),
                          child: Center(
                            child: PrimaryText(
                              text: tag.name,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              InkWell(
                onTap: () => Get.toNamed(
                  Routes.create.p,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Row(
                    children: [
                      Container(
                        height: 56,
                        width: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                              colors: [Color(0xFFA6F3FF), Color(0xFF00C2CB)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter),
                        ),
                        child: Icon(Icons.add),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      PrimaryText(
                        text: "Add New Playlist",
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 20),
                child: Row(
                  children: [
                    Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                            colors: [Color(0xFFA6F3FF), Color(0xFF00C2CB)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                      ),
                      child: Icon(Icons.favorite_border_outlined),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    PrimaryText(
                      text: "Your Liked Songs",
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
              //Your Top Genres
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0, top: 20),
                child: Row(
                  children: [
                    Icon(
                      Icons.swap_vert,
                      color: Color(0xFF00C2CB),
                    ),
                    PrimaryText(
                      text: "  Rencent Played",
                      fontSize: 18,
                      color: Color(0xFF00C2CB),
                    ),
                  ],
                ),
              ),
              FadeTransition(
                opacity: _animation,
                child: Obx(() {
                  switch (logic.state.musicType.value) {
                    case MusicType.songs:
                      return ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final item = logic.state.songs[index];
                            print(item);
                            return Obx(() {
                              final isSelected =
                                  logic.state.selectedIds.contains(item.id);
                              return InkWell(
                                onTap: () {
                                  if (selecting) {
                                    logic.toggleSelection(item.id);
                                  } else {
                                    Get.toNamed(Routes.song.p, arguments: {
                                      'song': item, // chỉ thêm nếu có
                                    });
                                  }
                                },
                                onLongPress: () {
                                  logic.enterSelectMode(item.id);
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  width: double.infinity,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    gradient: isSelected
                                        ? LinearGradient(
                                            colors: [
                                                Color(0xFFA6F3FF),
                                                Color(0xFF00C2CB),
                                              ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight)
                                        : LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          Colors.transparent,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
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
                                                  item.coverImage,
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
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (selecting)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10.0),
                                          child: Icon(
                                            isSelected
                                                ? Icons.check_circle
                                                : Icons.radio_button_unchecked,
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.grey,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            });
                          },
                          separatorBuilder: (context, index) => SizedBox(
                                height: 15,
                              ),
                          itemCount: logic.state.songs.length);
                    case MusicType.albums:
                      return ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final item = logic.state.albums[index];
                            return InkWell(
                              onTap: () {
                                print("albummm: ${item.toString()}");
                                Get.toNamed(Routes.playlist.p, arguments: item);
                              },
                              child: Container(
                                width: double.infinity,
                                height: 100,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5)),
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
                                      text: item.name,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => SizedBox(
                                height: 15,
                              ),
                          itemCount: logic.state.albums.length);
                    case MusicType.artists:
                      return ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final item = logic.state.artists[index];
                            return Container(
                              width: double.infinity,
                              height: 100,
                              child: Row(
                                children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.asset(
                                        item.image,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  PrimaryText(
                                    text: item.name,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => SizedBox(
                                height: 15,
                              ),
                          itemCount: logic.state.artists.length);
                    case MusicType.folders:
                      return ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final item = logic.state.folders[index];
                            return InkWell(
                              onTap: () {
                                Get.toNamed(Routes.folder.p);
                              },
                              child: Container(
                                width: double.infinity,
                                height: 100,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Image.asset(
                                          "assets/logo/folder.jpg",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    PrimaryText(
                                      text: item.name,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => SizedBox(
                                height: 15,
                              ),
                          itemCount: logic.state.folders.length);
                  }
                }),
              ),
            ],
          );
        }),
      ),
    );
  }
}
