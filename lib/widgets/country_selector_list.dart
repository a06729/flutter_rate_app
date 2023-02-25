import 'package:exchange_rate_app/controller/keybord_amonut_controller.dart';
import 'package:exchange_rate_app/controller/theam_controller.dart';
import 'package:exchange_rate_app/model/rateInfo/rateInfo.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class CountrySelector extends StatefulWidget {
  const CountrySelector({super.key});

  @override
  State<CountrySelector> createState() => _CountrySelectorState();
}

class _CountrySelectorState extends State<CountrySelector> {
  late String chooseValue;
  late KeybordAmountController? keybordAmountController;
  late TheamController _theamController;
  late List listItem;
  var logger = Logger(
    printer: PrettyPrinter(),
  );

  @override
  void initState() {
    listItem = RateInfo().rateCardInfo;
    keybordAmountController =
        Provider.of<KeybordAmountController>(context, listen: false);
    _theamController = Provider.of<TheamController>(context, listen: false);
    chooseValue = keybordAmountController!.countryCode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TheamController>(
      builder: (context, value, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
            child: Consumer<KeybordAmountController>(
              builder: (context, value, child) {
                return DropdownButton(
                    isExpanded: true,
                    hint: Text(
                      '화폐를 선택해주세요',
                      style: TextStyle(
                          color: _theamController.darkMod
                              ? Colors.black
                              : Colors.white),
                    ),
                    dropdownColor:
                        _theamController.darkMod ? Colors.white : Colors.black,
                    value: chooseValue,
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 20,
                    items: listItem.map((valueItem) {
                      return DropdownMenuItem(
                          value: valueItem['code'],
                          child: Center(
                            child: Text(
                                '${valueItem['code']} : ${valueItem['currencyName']}',
                                style: const TextStyle(color: Colors.white)),
                          ));
                    }).toList(),
                    onChanged: (newValue) {
                      chooseValue = newValue.toString();
                      keybordAmountController!.countryCodeUpdate(chooseValue);
                      logger.d("chooseValue:$chooseValue");
                    });
              },
            ),
          ),
        );
      },
    );
  }
}
