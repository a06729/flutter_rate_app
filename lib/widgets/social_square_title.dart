import 'package:exchange_rate_app/common/social_type.dart';
import 'package:exchange_rate_app/controller/login_page_controller.dart';
import 'package:exchange_rate_app/services/firebase_auth_remote.dart';
import 'package:exchange_rate_app/services/logger_fn.dart';
import 'package:exchange_rate_app/services/social_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
  late FireBaseAuthRemote _fireBaseAuthRemote;
  late LoginController _loginController;

  @override
  void initState() {
    // TODO: implement initState
    socialLogin = SocialLogin();
    _fireBaseAuthRemote = FireBaseAuthRemote();
    _loginController = LoginController();

    super.initState();
  }

  Future<void> signInWithKakao() async {
    await socialLogin.kakaoLogin();
  }

  Future<void> signInWithLine() async {
    await socialLogin.lineLogin();
  }

  //google로그인 함수
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        throw Exception("Not logged in");
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth?.accessToken != null || googleAuth?.idToken != null) {
        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        UserCredential userData =
            await FirebaseAuth.instance.signInWithCredential(credential);
        bool? newUser = userData.additionalUserInfo?.isNewUser;

        // logger.d("기존유저:$newUser}");
        // logger.d("유저 info:${userData.additionalUserInfo?.profile?['email']}");
        if (newUser == true) {
          final User? userInstance = FirebaseAuth.instance.currentUser;

          logger.d("구글 uid:${userInstance?.uid}");
          logger.d("구글 displayName:${userInstance?.displayName}");
          logger.d("구글 email:${userInstance?.email}");
          logger.d("구글 photoURL:${userInstance?.photoURL}");

          Map<String, dynamic> userJson = {
            "uid": userInstance?.uid,
            "displayName": userInstance?.displayName,
            "email": userInstance?.email,
            "photoURL": userInstance?.photoURL,
          };
          await _fireBaseAuthRemote.initUserDataNonCustomToken(userJson);
        }
        Get.offAllNamed('/');
      }
    } on PlatformException catch (e) {
      if (e.code == GoogleSignIn.kNetworkError) {
        logger.d("네트워크 에러");
        Get.snackbar(
          "네트워크 에러",
          "네트워크가 불안정 합니다.",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (e.code == GoogleSignIn.kSignInCanceledError) {
        logger.d("구글 로그인 취소");
        await socialLogin.googleLogout();
        await FirebaseAuth.instance.signOut();
        _loginController.loginLodding(false);
      } else {
        logger.d("구글 로그인 에러:${e.code}");
      }
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
          // LoginController loginController =
          //     Provider.of<LoginController>(context, listen: false);
          if (widget.socialType.text == SocialType.google.text) {
            _loginController.loginLodding(true);
            await signInWithGoogle().onError(
              (error, stackTrace) async => {
                logger.d("구글 로그인 에러:${error.toString()}"),
                if (error.toString() == "Exception: Not logged in")
                  {
                    logger.d("구글 로그인 캔슬:${error.toString()}"),
                    await socialLogin.googleLogout(),
                    await FirebaseAuth.instance.signOut(),
                    Get.snackbar(
                      "구글 로그인 취소",
                      "구글로그인 취소 하셨습니다.",
                      snackPosition: SnackPosition.BOTTOM,
                    )
                  }
              },
            );
            _loginController.loginLodding(false);
          } else if (widget.socialType.text == SocialType.kakao.text) {
            _loginController.loginLodding(true);
            await signInWithKakao()
                .then((value) => _loginController.loginLodding(false))
                .onError(
                  (error, stackTrace) => _loginController.loginLodding(false),
                );
          } else if (widget.socialType.text == SocialType.line.text) {
            _loginController.loginLodding(true);
            await signInWithLine()
                .then((value) => _loginController.loginLodding(false))
                .onError((error, stackTrace) =>
                    _loginController.loginLodding(false));
          }
          _loginController.loginLodding(false);
        },
        child: Image.asset(
          widget.imagePath,
          height: 60,
        ),
      ),
    );
  }
}
