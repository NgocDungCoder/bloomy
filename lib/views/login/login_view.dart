import 'package:bloomy/routes/route.dart';
import 'package:bloomy/widgets/primary_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginView extends StatelessWidget {
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
              child: TextField(
                style: GoogleFonts.aBeeZee(
                  color: Colors.white,
                ),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: GoogleFonts.aBeeZee(
                      color: Color(0xFF8A9A9D),
                    ),
                    suffixIcon: Icon(Icons.visibility_off),
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
              ),
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
                  Get.offNamed(Routes.main.p);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  backgroundColor: Color(0xFF06A0B5),
                ),
                child: PrimaryText(
                  text: "Log in",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          PrimaryText(
            text: "Forget the password",
            color: Color(0xFF06A0B5),
            fontWeight: FontWeight.bold,
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
              Container(
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
              Container(
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
            ],
          ),
        ],
      ),
    );
  }
}
