import 'package:bloomy/configs/colors.dart';
import 'package:bloomy/routes/route.dart';
import 'package:bloomy/views/signUp/signup_logic.dart';
import 'package:bloomy/widgets/primary_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignupLogic(Get.find()));
  }
}

class SignupView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final logic = Get.find<SignupLogic>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            width: 200,
            height: 200,
            child: Image.asset(
              "assets/logo/logo_bloomy.png",
              fit: BoxFit.cover,
            ),
          ),
          PrimaryText(
            text: "Sign up to Bloomy",
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 10),
            child: SizedBox(
              width: 350,
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                controller: logic.emailController,
                style: GoogleFonts.aBeeZee(
                  color: Colors.white,
                ),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: GoogleFonts.aBeeZee(
                      color: Color(0xFF8A9A9D),
                    ),
                    prefixIcon: Icon(Icons.email_outlined),
                    prefixIconColor: Color(0xFF8A9A9D),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.white),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.white),
                      borderRadius: BorderRadius.circular(15),
                    )),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 15),
            child: SizedBox(
              width: 350,
              child: Obx(() => TextField(
                    obscureText: logic.hiddenPass.value,
                    controller: logic.passwordController,
                    style: GoogleFonts.aBeeZee(
                      color: Colors.white,
                    ),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: GoogleFonts.aBeeZee(
                          color: Color(0xFF8A9A9D),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(logic.hiddenPass.value
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () => logic.hiddenPass.toggle(),
                        ),
                        suffixIconColor: Color(0xFF8A9A9D),
                        prefixIcon: Icon(Icons.password),
                        prefixIconColor: Color(0xFF8A9A9D),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.white),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.white),
                          borderRadius: BorderRadius.circular(15),
                        )),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 15),
            child: SizedBox(
              width: 350,
              child: Obx(() => TextField(
                onChanged: (_) => logic.validateRepeatPassword(),
                    obscureText: logic.hiddenRepeatPass.value,
                    controller: logic.repeatPasswordController,
                    style: GoogleFonts.aBeeZee(
                      color: Colors.white,
                    ),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                        hintText: "Repeat password",
                        hintStyle: GoogleFonts.aBeeZee(
                          color: Color(0xFF8A9A9D),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(logic.hiddenRepeatPass.value
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () => logic.hiddenRepeatPass.toggle(),
                        ),
                        suffixIconColor: Color(0xFF8A9A9D),
                        prefixIcon: Icon(Icons.password),
                        prefixIconColor: Color(0xFF8A9A9D),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.white),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.white),
                          borderRadius: BorderRadius.circular(15),
                        )),
                  )),
            ),
          ),
          Obx(() => logic.isPasswordMismatch.value
              ? PrimaryText(
                  text: "Repeat password not match", color: AppColors.red)
              : const SizedBox.shrink()),
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
                  logic.signUpWithEmail();
                  // Get.offNamed(Routes.main.p);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  backgroundColor: Color(0xFF06A0B5),
                ),
                child: PrimaryText(
                  text: "Sign up",
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                    'or continue with',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () async {
                  logic.signUpWithEmail();
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 2, color: Colors.white),
                  ),
                  child: Align(
                      child: SizedBox(
                          width: 30,
                          height: 30,
                          child: Image.asset(
                            "assets/logo/google.png",
                            fit: BoxFit.cover,
                          ))),
                ),
              ),
              InkWell(
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 2, color: Colors.white),
                  ),
                  child: Align(
                      child: SizedBox(
                          width: 30,
                          height: 30,
                          child: Image.asset(
                            "assets/logo/facebook.png",
                            fit: BoxFit.cover,
                          ))),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
