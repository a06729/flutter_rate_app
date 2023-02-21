import 'package:exchange_rate_app/controller/keybord_amonut_controller.dart';
import 'package:exchange_rate_app/controller/rate_card_controller.dart';
import 'package:exchange_rate_app/hive/rate_model.dart';
import 'package:exchange_rate_app/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
// import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

late Box box;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  // if (kReleaseMode) {
  //   // Is Release Mode??
  //   print('릴리즈 mode');
  // } else {
  //   print('디버깅 mode');
  // }

  // await Hive.initFlutter();
  // Hive.registerAdapter(RateModelAdapter());
  // box = await Hive.openBox('box');
  // box.put(
  //     'test', RateModel(base: 'test', date: 'test', rates: {"test": 123.4}));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Jua-Regular',
      ),
      home: MultiProvider(providers: [
        ChangeNotifierProvider.value(
          value: KeybordAmountController(),
        ),
        ChangeNotifierProvider.value(
          value: RateCardController(),
        ),
      ], child: const Home()),
    );
  }
}
