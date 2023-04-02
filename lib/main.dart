import 'package:exchange_rate_app/controller/chat_page_controller.dart';
import 'package:exchange_rate_app/controller/keybord_amonut_controller.dart';
import 'package:exchange_rate_app/controller/rate_card_controller.dart';
import 'package:exchange_rate_app/controller/theam_controller.dart';
import 'package:exchange_rate_app/hive/rate_model.dart';
import 'package:exchange_rate_app/screens/chat_page.dart';
import 'package:exchange_rate_app/screens/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:exchange_rate_app/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

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
  await TheamController().initMode();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(
        value: KeybordAmountController(),
      ),
      ChangeNotifierProvider.value(
        value: TheamController(),
      ),
      ChangeNotifierProvider.value(
        value: RateCardController(),
      ),
      ChangeNotifierProvider.value(
        value: ChatPageController(),
      )
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
  late Future<bool> themInitFuture;
  @override
  void initState() {
    super.initState();
    theamController = Provider.of<TheamController>(context, listen: false);
    //설정값을 저정한것을 실행 시키기 위해 함수를 불러온다.
    //휴대폰이 켜지면 유저가 설정한 테마모드를 불러오기위한 것
    // themInitFuture = theamController.initMode();
    initialization();
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
            GetPage(name: "/", page: () => const Home()),
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
            brightness: value.darkMod ? Brightness.dark : Brightness.light,
          ),
          home: const Home(),
        );
      },
    );
  }
}
