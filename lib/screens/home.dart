import 'package:exchange_rate_app/controller/keybord_amonut_controller.dart';
import 'package:exchange_rate_app/controller/rate_card_controller.dart';
import 'package:exchange_rate_app/controller/theam_controller.dart';
import 'package:exchange_rate_app/services/exchange_rate_api.dart';
import 'package:exchange_rate_app/widgets/ads_widget.dart';
import 'package:exchange_rate_app/widgets/amount_render.dart';
import 'package:exchange_rate_app/widgets/exchange_rate_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var logger = Logger(
    printer: PrettyPrinter(),
  );

  var loggerNoStack = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final exchangeApi = ExchangeRateApi();
  final Color bgBlack = const Color(0xff181818);
  // late ExchangeRateCardModel cardModel;
  late KeybordAmountController providerController;
  late TheamController theamController;

  late RateCardController rateCardController;
  late String amount;
  late String rateAmout;

  @override
  void initState() {
    super.initState();
    // cardModel = ExchangeRateCardModel();
    providerController =
        Provider.of<KeybordAmountController>(context, listen: false);
    rateCardController =
        Provider.of<RateCardController>(context, listen: false);
    theamController = Provider.of<TheamController>(context, listen: false);
    amount = providerController.amount;
    rateAmout = rateCardController.rateAmout;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TheamController>(
      builder: (context, value, child) {
        return Scaffold(
          key: _scaffoldKey,
          // drawer: const SideMenu(),
          backgroundColor: theamController.darkMod
              ? bgBlack
              : const Color.fromRGBO(255, 248, 243, 1),
          extendBodyBehindAppBar: false,
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
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
                              theamController.dartMode();
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
                        child: ListView.builder(
                      itemCount: value.rateCardInfo.length,
                      itemBuilder: (context, index) {
                        //화폐이름
                        String currencyName =
                            value.rateCardInfo[index]['currencyName'];
                        //화폐코드 USD,EUR,JPY etc...
                        String code = value.rateCardInfo[index]['code'];
                        //화폐 심볼
                        //카드에 출력되는 화폐 아이콘
                        IconData icons = value.rateCardInfo[index]['iconData'];
                        rateAmout = value.rateCardInfo[index]['rateAmout'];
                        return Consumer<RateCardController>(
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
                                rateDisplay = f.format(
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
              ],
            ),
          ),
        );
      },
    );
  }
}
