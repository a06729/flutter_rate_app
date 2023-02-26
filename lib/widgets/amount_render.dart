import 'package:exchange_rate_app/controller/keybord_amonut_controller.dart';
import 'package:exchange_rate_app/controller/rate_card_controller.dart';
import 'package:exchange_rate_app/controller/theam_controller.dart';
import 'package:exchange_rate_app/model/rateInfo/rateInfo.dart';
import 'package:exchange_rate_app/widgets/country_selector_list.dart';
import 'package:exchange_rate_app/widgets/keybord/customkeybord.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AmountRender extends StatefulWidget {
  const AmountRender({super.key});

  @override
  State<AmountRender> createState() => _AmountRenderState();
}

class _AmountRenderState extends State<AmountRender> {
  late KeybordAmountController? keybordAmountController;
  late RateCardController? rateCardController;
  late TextEditingController _textController;
  late TheamController theamController;
  late RateInfo? rateInfo;

  @override
  void initState() {
    super.initState();
    keybordAmountController =
        Provider.of<KeybordAmountController>(context, listen: false);
    rateCardController =
        Provider.of<RateCardController>(context, listen: false);
    theamController = Provider.of<TheamController>(context, listen: false);
    _textController = TextEditingController();
    rateInfo = RateInfo();
  }

  @override
  void dispose() {
    super.dispose();
    keybordAmountController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return renderAmount();
  }

  Widget renderAmount() {
    TextStyle style = const TextStyle(
      fontSize: 30.0,
      fontWeight: FontWeight.bold,
      color: Colors.grey,
    );

    return Consumer<TheamController>(
      builder: (context, value, child) {
        return Center(
          child: Consumer<KeybordAmountController>(
            builder: (context, value, child) {
              _textController.text = keybordAmountController!.diplayValue;
              return Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      showCursor: false,
                      autofocus: false,
                      readOnly: true,
                      style: style,
                      maxLength: 13,
                      onTap: () {
                        showModalBottomSheet(
                          backgroundColor: theamController.darkMod
                              ? const Color(0xff181818)
                              : const Color.fromARGB(255, 250, 222, 203),
                          context: context,
                          barrierColor: Colors.transparent,
                          builder: (context) {
                            return MultiProvider(
                              providers: [
                                ChangeNotifierProvider.value(
                                  value: keybordAmountController,
                                ),
                                ChangeNotifierProvider.value(
                                  value: rateCardController,
                                ),
                                ChangeNotifierProvider.value(
                                  value: theamController,
                                ),
                              ],
                              child: Column(
                                children: const [
                                  CountrySelector(),
                                  CustomKeyboard()
                                ],
                              ),
                            );
                          },
                        );
                      },
                      decoration: InputDecoration(
                        hintText: '환전금액',
                        hintStyle: TextStyle(
                          fontSize: 29.0,
                          color: theamController.darkMod
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: theamController.darkMod
                                  ? Colors.white
                                  : Colors.black,
                              width: 1.0),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                  ),
                  Consumer<KeybordAmountController>(
                    builder: (context, value, child) {
                      IconData iconDate =
                          rateInfo!.currencyIcon(value.countryCode);
                      return Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: SizedBox(
                          child: Icon(
                            iconDate,
                            size: 28,
                            weight: 30,
                            color: theamController.darkMod
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      );
                    },
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }
}
