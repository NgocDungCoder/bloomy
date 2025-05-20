import 'package:bloomy/routes/route.dart';
import 'package:bloomy/widgets/primary_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 150 / 100,
            child: Image.asset(
              "assets/logo/logo_bloomy.png",
              fit: BoxFit.cover,
            ),
          ),
          const PrimaryText(
            text: "Log in to your account",
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 10),
            child: SizedBox(
              width: 350,
              child: TextField(
                style: GoogleFonts.aBeeZee(
                  color: Colors.white,
                ),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: GoogleFonts.aBeeZee(
                      color: const Color(0xFF8A9A9D),
                    ),
                    prefixIcon: const Icon(Icons.email_outlined),
                    prefixIconColor: const Color(0xFF8A9A9D),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.white),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 2, color: Colors.white),
                      borderRadius: BorderRadius.circular(15),
                    )),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 15),
            child: SizedBox(
              width: 350,
              child: TextField(
                style: GoogleFonts.aBeeZee(
                  color: Colors.white,
                ),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: GoogleFonts.aBeeZee(
                      color: const Color(0xFF8A9A9D),
                    ),
                    suffixIcon: const Icon(Icons.visibility_off),
                    suffixIconColor: const Color(0xFF8A9A9D),
                    prefixIcon: const Icon(Icons.password),
                    prefixIconColor: const Color(0xFF8A9A9D),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.white),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 2, color: Colors.white),
                      borderRadius: BorderRadius.circular(15),
                    )),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(boxShadow: const [
              BoxShadow(
                  color: Color(0xFF06A0B5), blurRadius: 10, spreadRadius: 5),
            ], borderRadius: BorderRadius.circular(40)),
            child: SizedBox(
              width: 330,
              height: 65,
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed(Routes.main.p);
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  backgroundColor: const Color(0xFF06A0B5),
                ),
                child: const PrimaryText(
                  text: "Log in",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const PrimaryText(
            text: "Forget the password",
            color: Color(0xFF06A0B5),
            fontWeight: FontWeight.bold,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Divider(
                    color: Colors.white,
                    thickness: 1,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
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
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 1, color: Colors.white),
                  ),
                  child: Align(
                    child: Image.asset(
                      "assets/logo/google.png",
                      fit: BoxFit.cover,
                      width: 30,
                      height: 30,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 1, color: Colors.white),
                  ),
                  child: Align(
                    child: Image.asset(
                      "assets/logo/facebook.png",
                      fit: BoxFit.cover,
                      width: 30,
                      height: 30,
                    ),
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
