import 'package:bloomy/routes/route.dart';
import 'package:bloomy/views/signIn/signIn_logic.dart';
import 'package:bloomy/widgets/primary_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignInLogic(Get.find()));
  }

}

class SignInView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final logic = Get.find<SignInLogic>();
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
      ),
      body: Column(
        children: [
          SizedBox(
            width: 320,
            height: 320,
            child: Image.asset(
              "assets/logo/logo_bloomy.png",
              fit: BoxFit.cover,
            ),
          ),
          PrimaryText(
            text: "Let's get you in",
            fontWeight: FontWeight.bold,
            fontSize: 40,
          ),
          InkWell(
            onTap: () {
              logic.loginWithGG();
            },
            child: Container(
              height: 60,
              width: 320,
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.white),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 35,
                    height: 35,
                    child: Image.asset(
                      "assets/logo/google.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  PrimaryText(
                    text: "Continue with Google",
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 60,
            width: 320,
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.white),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 35,
                  height: 35,
                  child: Image.asset(
                    "assets/logo/facebook.png",
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                PrimaryText(
                  text: "Continue with Facebook",
                  fontWeight: FontWeight.bold, fontSize: 14,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Divider(
                    color: Colors.white,
                    thickness: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'or',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.white,
                    thickness: 1,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Color(0xFF06A0B5), blurRadius: 10, spreadRadius: 5),
            ], borderRadius: BorderRadius.circular(40)),
            child: SizedBox(
              width: 330,
              height: 65,
              child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed(Routes.login.p);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    backgroundColor: Color(0xFF06A0B5),
                  ),
                  child: PrimaryText(
                    text: "Log in with a password",
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PrimaryText(
                  text: "Don't have an account ? ",
                  fontWeight: FontWeight.bold,
                ),
                InkWell(
                  onTap: () => Get.toNamed(Routes.signUp.p),
                  child: PrimaryText(
                    text: "Sign up",
                    color: Color(0xFF06A0B5),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
