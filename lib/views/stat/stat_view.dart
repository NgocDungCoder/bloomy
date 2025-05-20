import 'package:bloomy/views/stat/stat_logic.dart';
import 'package:bloomy/widgets/primary_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class StatView extends StatefulWidget {
  @override
  State<StatView> createState() => _StatViewState();
}

class _StatViewState extends State<StatView> {
  int selectedIndex = 0;
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final logic = StatLogic();
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
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.grid_view),
              color: Colors.white,
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.add),
              color: Colors.white,
            ),
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
                        selectedIndex = index;
                        print("đã ấn $index");
                        print("đã ấn $selectedIndex");
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
                        border: selectedIndex == index
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
                            color: selectedIndex == index
                                ? Color(0xFF39C0D4)
                                : Colors.white,
                            shadows: selectedIndex == index
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
                child: PageView.builder(
                  controller: pageController,
                  onPageChanged: (index) {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  itemCount: logic.state.tops.length,
                  itemBuilder: (context, index) {
                    List<dynamic> currentList;
                    String itemType;
                    switch (index) {
                      case 0:
                        currentList = logic.state.tracks;
                        itemType = 'Tracks';
                        break;
                      case 1:
                        currentList = logic.state.artists;
                        itemType = 'Artists';
                        break;
                      case 2:
                        currentList = logic.state.albums;
                        itemType = 'Albums';
                        break;
                      default:
                        currentList = logic.state.tracks; // Mặc định
                        itemType = 'Tracks';
                    }
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: currentList.length,
                        itemBuilder: (context, trackIndex) {
                          final item = currentList[trackIndex];
                          return Container(
                            height: 100,
                            width: 370,
                            decoration: BoxDecoration(
                                color: Color(0xFF1E1E1E),
                                borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  child: Center(
                                    child: PrimaryText(
                                      text: "#${trackIndex + 1}",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 75,
                                  height: 75,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.asset(
                                      item.image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  padding: EdgeInsets.only(left: 15),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      PrimaryText(
                                        text: item.name,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      PrimaryText(
                                        text: itemType == "Tracks"
                                            ? "Tên nghệ sĩ"
                                            : itemType == "Artists"
                                                ? "Số lượt nghe"
                                                : itemType == "Albums"
                                                    ? "Số bài hát"
                                                    : "Không xác định",
                                        fontSize: 14,
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
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
