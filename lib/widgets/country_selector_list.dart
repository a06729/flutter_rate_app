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
  late TheamController _theamController;
  late List listItem;
  var logger = Logger(
    printer: PrettyPrinter(),
  );

  @override
  void initState() {
    listItem = RateInfo().rateCardInfo;
    _theamController = Provider.of<TheamController>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TheamController>(
      builder: (context, value, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<KeybordAmountController>(
            builder: (context, keybordControllerValue, child) {
              return DropdownButton(
                  isExpanded: true,
                  borderRadius: BorderRadius.circular(35),
                  hint: Text(
                    '화폐를 선택해주세요',
                    style: TextStyle(
                        color: _theamController.darkMod
                            ? Colors.black
                            : Colors.white),
                  ),
                  dropdownColor: _theamController.darkMod
                      ? Colors.black
                      : const Color.fromRGBO(223, 255, 216, 1),
                  value: keybordControllerValue.countryCode,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 20,
                  items: listItem.map((valueItem) {
                    return DropdownMenuItem(
                        value: valueItem['code'],
                        child: Center(
                          child: Text(
                            '${valueItem['code']} : ${valueItem['currencyName']}',
                            style: TextStyle(
                                color: _theamController.darkMod
                                    ? Colors.white
                                    : const Color.fromRGBO(149, 189, 255, 1)),
                          ),
                        ));
                  }).toList(),
                  onChanged: (newValue) {
                    chooseValue = newValue.toString();

                    keybordControllerValue.countryCodeUpdate(chooseValue);

                    logger.d("chooseValue:$chooseValue");
                  });
            },
          ),
        );
      },
    );
  }
}
