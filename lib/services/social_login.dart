import 'dart:convert';
import 'package:exchange_rate_app/common/social_type.dart';
import 'package:exchange_rate_app/screens/email_form_page.dart';
import 'package:exchange_rate_app/services/firebase_auth_remote.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_user.dart' as kakao;
import 'package:logger/logger.dart';
import 'package:get/get.dart';

//json 값 직렬화 하기 위해서 만든 클래스
class SocialDataModel {
  final String token; //서버에서 받은 커스텀 토큰값
  final bool status; //에러 있고 없을을 알리는 변수
  final String? errorMessage; //서버에서 받은 에러 메세지
  final bool existUser; //이미 존재하는 유저인지 아닌지 구별하는 변수
  SocialDataModel(this.token, this.status, this.errorMessage, this.existUser);

  SocialDataModel.formJson(Map<String, dynamic> json)
      : token = json['token'],
        status = json['status'],
        errorMessage = json['errorMessage'],
        existUser = json['existUser'];
}

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
          final tokenJsonString =
              await firebaseAuthDataSource.createCustomToken({
            'uid': kakaoUser!.id.toString(),
            'displayName': kakaoUser!.kakaoAccount!.profile!.nickname,
            'email': kakaoUser!.kakaoAccount!.email!,
            'photoURL': kakaoUser!.kakaoAccount!.profile!.profileImageUrl
          });

          Map<String, dynamic> tokenJson = jsonDecode(tokenJsonString);

          SocialDataModel jsonData = SocialDataModel.formJson(tokenJson);

          //성공적으로 로그인 토큰을 받아왔을때
          if (jsonData.status == true) {
            await FirebaseAuth.instance.signInWithCustomToken(jsonData.token);
            Get.offAllNamed('/');
          } else {
            Get.snackbar(
              "로그인 에러",
              jsonData.errorMessage!,
              snackPosition: SnackPosition.BOTTOM,
              forwardAnimationCurve: Curves.elasticInOut,
              reverseAnimationCurve: Curves.easeOut,
            );
          }
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
          final tokenJsonString =
              await firebaseAuthDataSource.createCustomToken({
            "uid": kakaoUser!.id.toString(),
            "displayName": kakaoUser!.kakaoAccount!.profile!.nickname,
            "email": kakaoUser!.kakaoAccount!.email!,
            "photoURL": kakaoUser!.kakaoAccount!.profile!.profileImageUrl,
            "platform": SocialType.kakao.text
          });

          Map<String, dynamic> tokenJson = jsonDecode(tokenJsonString);

          SocialDataModel jsonData = SocialDataModel.formJson(tokenJson);
          //성공적으로 로그인 토큰을 받아왔을때
          if (jsonData.status == true) {
            await FirebaseAuth.instance.signInWithCustomToken(jsonData.token);
            Get.offAllNamed('/');
          } else {
            Get.snackbar(
              "로그인 에러",
              jsonData.errorMessage!,
              snackPosition: SnackPosition.BOTTOM,
              forwardAnimationCurve: Curves.elasticInOut,
              reverseAnimationCurve: Curves.easeOut,
            );
          }
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

  Future<void> lineLogin() async {
    try {
      final result = await LineSDK.instance.login();
      logger.d("라인 아이디:${result.userProfile?.userId}");
      logger.d("라인 닉네임:${result.userProfile?.displayName}");
      logger.d("라인 사진:${result.userProfile?.pictureUrl}");

      Map<String, dynamic> existUserCheckJson = jsonDecode(
        await firebaseAuthDataSource
            .checkExistUserLine(result.userProfile!.userId),
      );

      SocialDataModel existUserCheckData =
          SocialDataModel.formJson(existUserCheckJson);
      //기존 유저가 있으면 바로 CustomToken 생성해서 바로 로그인 처리
      if (existUserCheckData.existUser == true) {
        await FirebaseAuth.instance
            .signInWithCustomToken(existUserCheckData.token);
        Get.offAllNamed('/');
      } else {
        // 기존유저가 아닌경우는 이메일 정보를 받은후 커스텀 토큰을 요청해서 로그인 실행
        String emailResult = await Get.to(const EmailFormPage());

        logger.d("라인 이메일:${result.userProfile?.pictureUrl}");

        final tokenJsonString = await firebaseAuthDataSource.createCustomToken({
          "uid": result.userProfile?.userId.toString(),
          "displayName": result.userProfile?.displayName.toString(),
          "email": emailResult,
          "photoURL": result.userProfile?.pictureUrl.toString(),
          "platform": SocialType.line.text
        });

        Map<String, dynamic> tokenJson = jsonDecode(tokenJsonString);

        SocialDataModel jsonData = SocialDataModel.formJson(tokenJson);

        //성공적으로 로그인 토큰을 받아왔을때
        if (jsonData.status == true) {
          await FirebaseAuth.instance.signInWithCustomToken(jsonData.token);
          Get.offAllNamed('/');
        } else {
          logger.d(jsonData.errorMessage);
          Get.snackbar(
            "로그인 에러",
            jsonData.errorMessage!,
            snackPosition: SnackPosition.BOTTOM,
            forwardAnimationCurve: Curves.elasticInOut,
            reverseAnimationCurve: Curves.easeOut,
          );
        }
      }
    } on PlatformException catch (e) {
      logger.d("line 로그인 에러:${e.toString()}");
    }
  }
}
