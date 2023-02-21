import 'package:exchange_rate_app/controller/keybord_amonut_controller.dart';
import 'package:exchange_rate_app/controller/rate_card_controller.dart';
import 'package:exchange_rate_app/services/exchange_rate_api.dart';
import 'package:exchange_rate_app/widgets/ads_widget.dart';
import 'package:exchange_rate_app/widgets/amount_render.dart';
import 'package:exchange_rate_app/widgets/exchange_rate_card.dart';
import 'package:exchange_rate_app/widgets/model/exchange_rate_card_model.dart';
import 'package:exchange_rate_app/widgets/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final exchangeApi = ExchangeRateApi();
  final Color bgBlack = const Color(0xff181818);
  late ExchangeRateCardModel cardModel;
  late KeybordAmountController providerController;
  late RateCardController rateCardController;
  late String amount;
  late String rateAmout;

  @override
  void initState() {
    super.initState();
    cardModel = ExchangeRateCardModel();
    providerController =
        Provider.of<KeybordAmountController>(context, listen: false);
    rateCardController =
        Provider.of<RateCardController>(context, listen: false);
    amount = providerController.amount;
    rateAmout = rateCardController.rateAmout;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // drawer: const SideMenu(),
      backgroundColor: bgBlack,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        actions: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // IconButton(
                //   onPressed: () => {
                //     _scaffoldKey.currentState?.openDrawer(),
                //   },
                //   icon: const Icon(Icons.menu),
                // )
              ],
            ),
          )
        ],
        systemOverlayStyle: SystemUiOverlayStyle.light,
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
                children: const [
                  Text(
                    '환율 정보',
                    style: TextStyle(
                        color: Colors.white,
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
                            rateDisplay = f
                                .format(int.parse(rateAmoutList[0].toString()));
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
  }
}
