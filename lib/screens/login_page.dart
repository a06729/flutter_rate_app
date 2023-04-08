import 'package:exchange_rate_app/controller/theam_controller.dart';
import 'package:exchange_rate_app/services/social_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TheamController theamController;
  late SocialLogin socialLogin;
  @override
  void initState() {
    theamController = Provider.of<TheamController>(context, listen: false);
    socialLogin = SocialLogin();
    super.initState();
  }

  Future<void> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth?.accessToken != null || googleAuth?.idToken != null) {
        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
        Get.offAllNamed('/');
      }
    } on FirebaseAuthException catch (error) {
      throw FirebaseAuthException(code: error.code);
    } on PlatformException catch (error) {
      throw PlatformException(code: error.code);
    }

    // Once signed in, return the UserCredential
  }

  Future<void> signInWithKakao() async {
    await socialLogin.kakaoLogin();
  }

  @override
  Widget build(BuildContext context) {
    //텍스트 컬러
    Color textColor =
        theamController.darkMod ? Colors.white : const Color(0xff181818);
    //배경화면 컬러
    Color bgColor =
        theamController.darkMod ? const Color(0xff181818) : Colors.white;
    //앱바 배경화면 컬러
    Color appBarBgColor = theamController.darkMod
        ? const Color.fromARGB(255, 40, 40, 40)
        : Colors.white;
    //아이콘 컬러
    Color iconColor =
        theamController.darkMod ? Colors.white : const Color(0xff181818);
    return Scaffold(
      appBar: AppBar(backgroundColor: appBarBgColor),
      backgroundColor: bgColor,
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Icon(
              Icons.lock,
              size: 100,
              color: iconColor,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'SNS 로그인',
              style: TextStyle(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            //구글 로그인 버튼
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: theamController.darkMod
                      ? const Color.fromRGBO(1, 22, 56, 1)
                      : Colors.white),
              icon: Image.asset('assets/icons/google-icon.jpg', width: 50),
              onPressed: () async {
                await signInWithGoogle();
              },
              label: Text(
                "구글 로그인",
                style: TextStyle(fontSize: 20, color: textColor),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: theamController.darkMod
                      ? const Color(0xffffff00)
                      : Colors.white),
              icon: Image.asset('assets/icons/google-icon.jpg', width: 50),
              onPressed: () async {
                await signInWithKakao();
              },
              label: Text(
                "카카오톡 로그인",
                style: TextStyle(fontSize: 20, color: textColor),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
