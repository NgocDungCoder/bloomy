import 'package:bloomy/views/create_new/create_logic.dart';
import 'package:bloomy/widgets/primary_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateLogic>(() => CreateLogic());
  }

}

class CreateView extends GetView<CreateLogic> {
  FocusNode focusNode = FocusNode();
  final TextEditingController playlistTitleController = TextEditingController();

  CreateView({super.key});


  @override
  Widget build(BuildContext context) {
    final logic = controller;
    return GestureDetector(
      onTap: () {
        focusNode.unfocus(); // Khi nhấn ra ngoài, sẽ bỏ focus của TextField
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: PrimaryText(
                  text: "New Playlist",
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  style: GoogleFonts.aBeeZee(color: Colors.white, decoration: TextDecoration.none),
                  focusNode: focusNode,
                  controller: playlistTitleController,
                  cursorColor: Color(0xFF06A0B5),
                  decoration: InputDecoration(
                    hintText: "Your playlist tiltle",
                    hintStyle: GoogleFonts.aBeeZee(
                      color: Color(0xFF8A9A9D),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF8A9A9D), width: 1.0),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF06A0B5), width: 2.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF2C2F30),
                            blurRadius: 10,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2C2F30),
                        ),
                        child: PrimaryText(text: "Cancel"),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF06A0B5), // Màu phát sáng
                            blurRadius: 10, // Độ mờ của hào quang
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF06A0B5),
                        ),
                        onPressed: () {
                          final enteredTitle = playlistTitleController.text.trim();
                          if (enteredTitle.isNotEmpty) {
                            controller.createNewAlbum(enteredTitle);
                            Get.back();
                          } else {
                            // Xử lý trường hợp chưa nhập title (nếu muốn)
                            print("Bạn cần nhập tiêu đề playlist");
                          }
                        },
                        child: PrimaryText(
                          text: "Create",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
