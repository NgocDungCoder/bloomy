import 'package:bloomy/routes/route.dart';
import 'package:bloomy/widgets/primary_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            color: Colors.yellow,
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              "assets/logo/welcome.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                  color: Colors.black,
                ),
                height: 400,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        width: 300,
                        alignment: Alignment.center,
                        child: Center(
                          child: PrimaryText(
                            text:
                                "Lorem Ipsum is simply dummy text of the printing and type setting industry. Lorem Ipsum has been the ",
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    SizedBox(
                      width: 100,
                      height: 15,
                      child: Row(
                        children: [
                          Container(
                            height: 5,
                            width: 50,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.black),
                              color: Color(0xFF06A0B5),
                            ),
                          ),
                          Container(
                            height: 5,
                            width: 50,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.black),
                              color: Color(0xFFDBE7E8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: Color(0xFF06A0B5),
                            blurRadius: 10,
                            spreadRadius: 5),
                      ], borderRadius: BorderRadius.circular(40)),
                      child: SizedBox(
                        width: 330,
                        height: 65,
                        child: ElevatedButton(
                            onPressed: () {Get.toNamed(Routes.signIn.p);},
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              backgroundColor: Color(0xFF06A0B5),
                            ),
                            child: PrimaryText(
                              text: "Get Started",
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
