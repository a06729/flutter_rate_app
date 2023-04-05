import 'package:exchange_rate_app/controller/keybord_amonut_controller.dart';
import 'package:exchange_rate_app/controller/rate_card_controller.dart';
import 'package:exchange_rate_app/controller/theam_controller.dart';
import 'package:exchange_rate_app/model/rateInfo/rateInfo.dart';
import 'package:exchange_rate_app/screens/chat_page.dart';
import 'package:exchange_rate_app/screens/login_page.dart';
import 'package:exchange_rate_app/services/exchange_rate_api.dart';
import 'package:exchange_rate_app/widgets/ads_widget.dart';
import 'package:exchange_rate_app/widgets/amount_render.dart';
import 'package:exchange_rate_app/widgets/exchange_rate_card.dart';
import 'package:exchange_rate_app/widgets/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class HomeGetxController extends GetxController {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void closeDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  var logger = Logger(
    printer: PrettyPrinter(),
  );

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final exchangeApi = ExchangeRateApi();
  final Color bgBlack = const Color(0xff181818);
  // late ExchangeRateCardModel cardModel;
  late KeybordAmountController providerController;
  late TheamController theamController;

  late RateCardController rateCardController;
  //환전했을때 얼마를 환전되는지 표시하는 변수
  late String rateAmout;
  //환율카드에 들어가는 국가코드,화폐아이콘,화폐심볼,환율계산 결과값을
  //저장하기 위한 변수와 함수가 담긴 클래스
  late RateInfo rateInfo;

  @override
  void initState() {
    super.initState();
    // cardModel = ExchangeRateCardModel();

    rateInfo = RateInfo();
    providerController =
        Provider.of<KeybordAmountController>(context, listen: false);
    rateCardController =
        Provider.of<RateCardController>(context, listen: false);
    theamController = Provider.of<TheamController>(context, listen: false);
    //환전값을 기본값으로 저장
    rateAmout = rateCardController.rateAmout;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      //앱 종로시
      case AppLifecycleState.detached: // (5)
        logger.d("## detached");
        await rateCardController.initRateCardData();
        break;
      case AppLifecycleState.inactive: // (6)
        logger.d("## inactive");
        break;
      case AppLifecycleState.paused: // (7)
        logger.d("## paused");
        break;
      case AppLifecycleState.resumed: // (8)
        logger.d("## resumed");
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TheamController>(
      builder: (context, value, child) {
        return Scaffold(
          key: _scaffoldKey,
          drawer: const SideMenu(),
          backgroundColor:
              value.darkMod ? bgBlack : const Color.fromRGBO(255, 248, 243, 1),
          extendBodyBehindAppBar: false,
          bottomNavigationBar: BottomNavigationBar(
              unselectedLabelStyle: TextStyle(
                color: value.darkMod ? Colors.white : Colors.black,
                fontSize: 15,
              ),
              backgroundColor: value.darkMod
                  ? bgBlack
                  : const Color.fromRGBO(255, 248, 243, 1),
              onTap: (index) {
                logger.d("페이지 인덱스:$index");
                if (index == 0) {
                  Get.toNamed("/");
                } else if (index == 1) {
                  if (FirebaseAuth.instance.currentUser != null) {
                    logger.d("로그인 됨");
                    Get.toNamed('/chatPage');
                  } else {
                    logger.d("로그인 되지 않음");
                    Get.toNamed('/loginPage');
                  }
                  // FirebaseAuth.instance.authStateChanges().listen((User? user) {
                  //   if (user == null) {
                  //     logger.d("로그인 되지 않음");
                  //     Get.toNamed('/loginPage');
                  //   } else {
                  //     logger.d("로그인 됨");
                  //     Get.toNamed('/chatPage');
                  //   }
                  // });
                }
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    color: value.darkMod ? Colors.white : Colors.black,
                  ),
                  label: '홈',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.chat,
                    color: value.darkMod ? Colors.white : Colors.black,
                  ),
                  label: 'AI 채팅',
                ),
              ]),
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            systemOverlayStyle: theamController.darkMod
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark,
            leading: IconButton(
              icon: const Icon(Icons.menu_rounded),
              color: theamController.darkMod ? Colors.white : Colors.black,
              onPressed: () {
                if (_scaffoldKey.currentState!.isDrawerOpen) {
                  _scaffoldKey.currentState!.closeDrawer();
                  //close drawer, if drawer is open
                } else {
                  _scaffoldKey.currentState!.openDrawer();
                  //open drawer, if drawer is closed
                }
              },
            ),
            actions: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Consumer<TheamController>(
                      builder: (context, value, child) {
                        return IconButton(
                            onPressed: () async {
                              // final SharedPreferences prefs = await _prefs;
                              // var darkModeValue = prefs.get('darkMode');
                              // logger.d("$darkModeValue");
                              await theamController.dartMode();
                            },
                            icon: theamController.darkMod
                                ? const Icon(
                                    Icons.light_mode,
                                    color: Colors.white,
                                    size: 40,
                                  )
                                : const Icon(
                                    Icons.dark_mode_sharp,
                                    color: Colors.black,
                                    size: 40,
                                  ));
                      },
                    )
                  ],
                ),
              )
            ],
            backgroundColor: Colors.transparent,
          ),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(
                        height: 10,
                      ),
                      //금액을 입력한것을 출력하는 클래스
                      //TextField 위젯으로 되어 있다.
                      AmountRender(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const AdsWidget(),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '환율 정보',
                        style: TextStyle(
                            color: theamController.darkMod
                                ? Colors.white
                                : Colors.black,
                            fontSize: 26,
                            fontWeight: FontWeight.w600),
                      ),
                      // Text(
                      //   "더보기",
                      //   style: TextStyle(
                      //       fontSize: 14,
                      //       color: Colors.white,
                      //       fontWeight: FontWeight.w600),
                      // )
                    ],
                  ),
                ),
                //환율 카드
                Consumer<RateCardController>(
                  builder: (context, value, child) {
                    if (value.lodding) {
                      return const CircularProgressIndicator();
                    }
                    var f = NumberFormat('###,###,###,###');
                    return Expanded(
                        child: ReorderableListView.builder(
                      onReorder: (oldIndex, newIndex) async {
                        if (newIndex > oldIndex) newIndex--;
                        final item = value.rateCardInfo.removeAt(oldIndex);
                        await rateCardController.reorderRateCard(
                            newIndex, item);
                      },
                      itemCount: value.rateCardInfo.length,
                      itemBuilder: (context, index) {
                        //화폐이름
                        String currencyName =
                            value.rateCardInfo[index]['currencyName'];
                        //화폐코드 USD,EUR,JPY etc...
                        String code = value.rateCardInfo[index]['code'];
                        //화폐 심볼
                        //카드에 출력되는 화폐 아이콘
                        // IconData icons = value.rateCardInfo[index]['iconData'];
                        IconData icons = rateInfo.currencyIcon(code);
                        rateAmout = value.rateCardInfo[index]['rateAmout'];
                        return Consumer<RateCardController>(
                          key: ValueKey(value.rateCardInfo[index]),
                          builder: (context, value, child) {
                            String rateDisplay = "";
                            if (rateAmout.isNotEmpty) {
                              List rateAmoutList = value.rateCardInfo[index]
                                      ['rateAmout']
                                  .toString()
                                  .split('.');
                              if (rateAmoutList.length > 1) {
                                rateDisplay =
                                    '${f.format(int.parse(rateAmoutList[0].toString()))}.${rateAmoutList[1]}';
                              } else {
                                // logger.d(
                                //     'rateDisplay:${rateAmoutList[0].toString()}');
                                rateDisplay = rateAmoutList[0]
                                        .toString()
                                        .isEmpty
                                    ? rateDisplay = '0'
                                    : f.format(
                                        int.parse(rateAmoutList[0].toString()));
                              }
                            }

                            rateAmout = value.rateCardInfo[index]['rateAmout']
                                    .toString()
                                    .isEmpty
                                ? '0'
                                : rateDisplay;
                            return ExchangeRateCard(
                              currencyName: currencyName,
                              code: code,
                              amount: rateAmout.toString(),
                              icon: icons,
                              isInverted: false,
                            );
                          },
                        );
                      },
                    ));
                  },
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
