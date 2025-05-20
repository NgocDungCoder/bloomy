// import 'package:bloomy/routes/route.dart';
// import 'package:bloomy/views/float_play/float_play_view.dart';
// import 'package:bloomy/views/folder/folder_logic.dart';
// import 'package:bloomy/widgets/primary_text.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class FolderBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut<FolderLogic>(() => FolderLogic());
//   }
//
// }
// class FolderView extends GetView<FolderLogic> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.black,
//         appBar: AppBar(
//           backgroundColor: Colors.black,
//           leading: IconButton(
//             onPressed: () {
//               Get.back();
//             },
//             icon: Icon(Icons.arrow_back),
//             color: Colors.white,
//           ),
//           title: PrimaryText(
//             text: "Folder name",
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         body: Stack(children: [
//           Padding(
//             padding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
//             child: ListView(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     PrimaryText(
//                       text: "Sort by",
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14,
//                     ),
//                     Row(
//                       children: [
//                         PrimaryText(
//                           text: "Recently played",
//                           color: Color(0xFF00C2CB),
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14,
//                         ),
//                         Icon(
//                           Icons.swap_vert,
//                           color: Color(0xFF00C2CB),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//                 InkWell(
//                   onTap: () => Get.toNamed(
//                     Routes.create.p,
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
//                     child: Row(
//                       children: [
//                         Container(
//                           width: 60,
//                           height: 60,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(40),
//                             gradient: LinearGradient(
//                                 colors: [Color(0xFFA6F3FF), Color(0xFF00C2CB)],
//                                 begin: Alignment.topCenter,
//                                 end: Alignment.bottomCenter),
//                           ),
//                           child: Icon(
//                             Icons.add,
//                             size: 40,
//                           ),
//                         ),
//                         SizedBox(
//                           width: 20,
//                         ),
//                         PrimaryText(
//                           text: "Add New Playlist",
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Obx(() => Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 10),
//                   child: ListView.separated(
//                       shrinkWrap: true,
//                       physics: NeverScrollableScrollPhysics(),
//                       itemBuilder: (context, index) {
//                         final album = controller.state.albumList[index];
//                         return InkWell(
//                           onTap: () {
//                             Get.toNamed(Routes.playlist.p, arguments: album);
//                           },
//                           child: Container(
//                             width: double.infinity,
//                             height: 100,
//                             child: Row(
//                               children: [
//                                 Container(
//                                   height: 100,
//                                   width: 100,
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(5)),
//                                   child: ClipRRect(
//                                     borderRadius: BorderRadius.circular(5),
//                                     child: Image.asset(
//                                       album.coverImage,
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 15,
//                                 ),
//                                 Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     PrimaryText(
//                                       text: album.name,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                     PrimaryText(
//                                       text: "18 songs",
//                                       color: Color(0xFF8A9A9D),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                       separatorBuilder: (_, __) => SizedBox(
//                         height: 15,
//                       ),
//                       itemCount: controller.state.albumList.length),
//                 ),),
//               ],
//             ),
//           ),
//           FloatPlayView(),
//         ]));
//   }
// }
