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
  }}
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
                  onTap: () => Get.toNamed(Routes.playlist.p),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PrimaryText(
                        text: "Playing from playlist:".toUpperCase(),
                        fontSize: 12,
                      ),
                      PrimaryText(
                        text: controller.state.album.value != null ? controller.state.album.value!.name : "Danh sách chung",
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7CEEFF),
                      )
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
                                  controller.state.song.value.coverImage,
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
                                    Expanded(
                                      child: PrimaryText(
                                        text: controller.state.song.value.title,
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
                        onPressed: () {},
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
           Obx(() =>  SizedBox(
             height: 600,
             child: ListView.separated(
                 shrinkWrap: true,
                 itemBuilder: (context, index) {
                   final song = controller.state.waitingSongs[index];
                   return InkWell(
                     onTap: () => Get.toNamed(Routes.song.p),
                     child: Container(
                       height: 70,
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
                                         crossAxisAlignment: CrossAxisAlignment.start,
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
                               Icons.swap_vert,
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
                 itemCount: controller.state.waitingSongs.length),
           ),),
          ],
        ),
      ),
    );
  }
}
