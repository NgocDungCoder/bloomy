import 'package:bloomy/routes/route.dart';
import 'package:bloomy/views/home/home_logic.dart';
import 'package:bloomy/widgets/primary_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = HomeLogic();
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color(0xFF0E0E0E),
          Color(0xFF0E0E0E),
          Color(0xFF102B2D),
          Color(0xFF06A0B5),
        ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
          child: ListView(
            children: [
              //Appbar
              Container(
                height: 90,
                width: double.infinity,
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          padding: const EdgeInsets.all(3),
                          // độ dày viền trắng
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Color(0xFF158085), Color(0xFF00DBFC)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                            shape: BoxShape.circle,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            // 👈 đảm bảo bo tròn
                            child: Image.asset(
                              "assets/logo/avatar.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PrimaryText(text: 'Welcome back!'),
                            PrimaryText(text: 'username'),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Get.toNamed(Routes.stat.p);
                          },
                          icon: const Icon(
                            Icons.bar_chart_outlined,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          onPressed: () {
                            Get.toNamed(Routes.musicLocal.p);
                          },
                          icon: const Icon(
                            Icons.notifications_none_outlined,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Icons.settings_outlined,
                          color: Colors.white,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              //Continue
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: PrimaryText(
                  text: "Continue Listening",
                  fontSize: 18,
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.5,
                ),
                itemCount: logic.state.albumList.length,
                itemBuilder: (context, index) {
                  final album = logic.state.albumList[index];
                  return InkWell(
                    onTap: () => Get.toNamed(Routes.musicLocal.p),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFF436369),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 75,
                              height: 75,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10)),
                                child: Image.asset(
                                  album.coverImage,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: PrimaryText(
                                      text: album.name,
                                      fontSize: 10,
                                    ))),
                          ],
                        )),
                  );
                },
              ),

              //Your top mixes
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 10),
                child: PrimaryText(
                  text: "Your Top Mixes",
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 250,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final mix = logic.state.mixesList[index];
                      return Stack(
                        children: [
                          Container(
                            height: 250,
                            width: 250,
                            child: Image.asset(
                              mix.coverImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 0,
                            child: Container(
                              height: 40,
                              width: 250,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      Colors.black,
                                      Colors.transparent,
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 15,
                            left: 30,
                            child: PrimaryText(
                              text: mix.name,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              height: 12,
                              width: 250,
                              color: Colors.yellow,
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(
                          width: 20,
                        ),
                    itemCount: logic.state.mixesList.length),
              ),

              //Base on your recent listening
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0, top: 20),
                child: PrimaryText(
                  text: "Base on your recent listening",
                  fontSize: 18,
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: logic.state.recentList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 0.8),
                itemBuilder: (context, index) {
                  final recent = logic.state.recentList[index];
                  return SizedBox(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.asset(
                              recent.coverImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            height: 40,
                            width: 177,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black,
                                  Colors.transparent,
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 30,
                          child: PrimaryText(
                            text: recent.name,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
