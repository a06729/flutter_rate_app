import 'package:exchange_rate_app/common/social_type.dart';
import 'package:exchange_rate_app/controller/login_page_controller.dart';
import 'package:exchange_rate_app/services/social_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class SocialSquareTitle extends StatefulWidget {
  final String imagePath;
  final SocialType socialType;

  const SocialSquareTitle({
    super.key,
    required this.imagePath,
    required this.socialType,
  });

  @override
  State<SocialSquareTitle> createState() => _SocialSquareTitleState();
}

class _SocialSquareTitleState extends State<SocialSquareTitle> {
  late SocialLogin socialLogin;

  @override
  void initState() {
    // TODO: implement initState
    socialLogin = SocialLogin();
    super.initState();
  }

  Future<void> signInWithKakao() async {
    await socialLogin.kakaoLogin();
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[100]),
      child: InkWell(
        onTap: () async {
          LoginController loginController =
              Provider.of<LoginController>(context, listen: false);
          if (widget.socialType.text == SocialType.google.text) {
            loginController.loginLodding(true);
            await signInWithGoogle()
                .then(
                  (value) => loginController.loginLodding(false),
                )
                .onError(
                  (error, stackTrace) => loginController.loginLodding(false),
                );
          } else if (widget.socialType.text == SocialType.kakao.text) {
            loginController.loginLodding(true);
            await signInWithKakao()
                .then((value) => loginController.loginLodding(false))
                .onError(
                  (error, stackTrace) => loginController.loginLodding(false),
                );
          }
          loginController.loginLodding(false);
        },
        child: Image.asset(
          widget.imagePath,
          height: 60,
        ),
      ),
    );
  }
}
