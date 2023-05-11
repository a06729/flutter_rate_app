import 'package:exchange_rate_app/controller/chat_page_controller.dart';
import 'package:exchange_rate_app/controller/keybord_amonut_controller.dart';
import 'package:exchange_rate_app/controller/rate_card_controller.dart';
import 'package:exchange_rate_app/controller/theam_controller.dart';
import 'package:exchange_rate_app/db/app_db.dart';
import 'package:exchange_rate_app/hive/rate_model.dart';
import 'package:exchange_rate_app/screens/chat_page.dart';
import 'package:exchange_rate_app/screens/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:exchange_rate_app/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_template.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(
      nativeAppKey: '2e7ffbc174951dde4da1016d119d72db',
      javaScriptAppKey: '1ea9d2e339911d80ac2511ac44838d18');

  MobileAds.instance.initialize();
  await Firebase.initializeApp();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // if (kReleaseMode) {
  //   // Is Release Mode??
  //   print('릴리즈 mode');
  // } else {
  //   print('디버깅 mode');
  // }
  await Hive.initFlutter();
  Hive.registerAdapter(RateModelAdapter());

  runApp(MultiProvider(
    providers: [
      //ChangeNotifierProxyProvider에서 update 파라미터 함수에
      //두번째 파라미터 값에 AppDb()객체 인스턴스한 값을 접근가능하도록 하는것
      Provider.value(
        value: AppDb(),
      ),
      ChangeNotifierProxyProvider<AppDb, ChatPageController>(
        create: (context) => ChatPageController(),
        update: (context, db, previous) => previous!..initAppDb(db),
      ),
      ChangeNotifierProvider.value(
        value: KeybordAmountController(),
      ),
      ChangeNotifierProvider.value(
        value: TheamController(),
      ),
      ChangeNotifierProvider.value(
        value: RateCardController(),
      ),
      // ChangeNotifierProvider.value(
      //   value: ChatPageController(),
      // )
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late TheamController theamController;
  @override
  void initState() {
    theamController = Provider.of<TheamController>(context, listen: false);

    //설정값을 저정한것을 실행 시키기 위해 함수를 불러온다.
    //휴대폰이 켜지면 유저가 설정한 테마모드를 불러오기위한 것
    theamController.initMode();

    //스플래쉬 이미지 실행
    initialization();

    super.initState();
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 1));
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TheamController>(
      builder: (context, value, child) {
        return GetMaterialApp(
          getPages: [
            GetPage(
              name: "/",
              page: () => const Home(),
            ),
            GetPage(
              name: "/loginPage",
              page: () => const LoginPage(),
              transition: Transition.downToUp,
            ),
            GetPage(
              name: "/chatPage",
              page: () => const ChatPage(),
              transition: Transition.downToUp,
            ),
          ],
          title: '환율나우',
          debugShowCheckedModeBanner: true,
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: 'Jua-Regular',
            shadowColor: Colors.transparent,
            brightness:
                theamController.darkMod ? Brightness.dark : Brightness.light,
          ),
          home: const Home(),
        );
      },
    );
  }
}
