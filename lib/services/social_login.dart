import 'package:exchange_rate_app/services/firebase_auth_remote.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_user.dart' as kakao;
import 'package:logger/logger.dart';
import 'package:get/get.dart';

//소셜로그인 함수 모은 클래스
class SocialLogin {
  //소셜로그인에 필요한 파이어베이스 커스텀 토큰을 만들어주는 함수가 있는 클래스
  final firebaseAuthDataSource = FireBaseAuthRemote();
  //로그
  var logger = Logger(
    printer: PrettyPrinter(),
  );
  //카카오톡 로그인 정보를 객체화 한 변수
  kakao.User? kakaoUser;
  Future<void> kakaoLogin() async {
    try {
      //카카오톡 설치 여부 확인 코드
      bool isInstalled = await kakao.isKakaoTalkInstalled();
      if (isInstalled) {
        //카카오톡 설치시 실행되는 코드
        try {
          await kakao.UserApi.instance.loginWithKakaoTalk();
          kakaoUser = await kakao.UserApi.instance.me();
          final token = await firebaseAuthDataSource.createCustomToken({
            'uid': kakaoUser!.id.toString(),
            'displayName': kakaoUser!.kakaoAccount!.profile!.nickname,
            'email': kakaoUser!.kakaoAccount!.email!,
            'photoURL': kakaoUser!.kakaoAccount!.profile!.profileImageUrl
          });
          await FirebaseAuth.instance.signInWithCustomToken(token);
          Get.offAllNamed('/');
        } catch (e) {
          logger.d("카카오톡 설치 구간 코드 에러");
          logger.d("로그인에러:$e");
          await kakao.UserApi.instance.unlink();
          await FirebaseAuth.instance.signOut();
        }
      } else {
        try {
          //카카오톡 미설치시 실행되는 코드
          await kakao.UserApi.instance.loginWithKakaoAccount();
          kakaoUser = await kakao.UserApi.instance.me();
          logger.d("kakaoUser:$kakaoUser");
          final token = await firebaseAuthDataSource.createCustomToken({
            "uid": kakaoUser!.id.toString(),
            "displayName": kakaoUser!.kakaoAccount!.profile!.nickname,
            "email": kakaoUser!.kakaoAccount!.email!,
            "photoURL": kakaoUser!.kakaoAccount!.profile!.profileImageUrl
          });
          await FirebaseAuth.instance.signInWithCustomToken(token);
          Get.offAllNamed('/');
        } on PlatformException catch (e) {
          logger.d("카카오톡 미설치 구간 코드 에러");
          var code = await kakao.KakaoSdk.origin;
          logger.d("code:${code.toString()}");
          logger.d("로그인에러:$e");
          await kakao.UserApi.instance.unlink();
          await FirebaseAuth.instance.signOut();
        }
      }
    } catch (e) {
      logger.d("로그인에러:$e");
      await kakao.UserApi.instance.unlink();
      await FirebaseAuth.instance.signOut();
    }
  }

  Future<void> kakaologout() async {
    try {
      await kakao.UserApi.instance.unlink();
    } catch (error) {
      logger.d("로그아웃에러:$error");
    }
  }
}
