import 'package:exchange_rate_app/controller/theam_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  @override
  void initState() {
    theamController = Provider.of<TheamController>(context, listen: false);
    super.initState();
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    Color textColor =
        theamController.darkMod ? Colors.white : const Color(0xff181818);
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            const Icon(
              Icons.lock,
              size: 100,
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton.icon(
              icon: Image.asset('assets/icons/google-icon.jpg', width: 50),
              onPressed: () async {
                await signInWithGoogle();
                Get.toNamed("/");
              },
              label: Text(
                "구글 로그인",
                style: TextStyle(fontSize: 20, color: textColor),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
