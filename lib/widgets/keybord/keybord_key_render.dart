import 'package:exchange_rate_app/controller/keybord_amonut_controller.dart';
import 'package:exchange_rate_app/widgets/keybord/keybord_key.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//키보드 자판 렌더링하는 클래스
class KeybordKeyRender extends StatefulWidget {
  const KeybordKeyRender({super.key});

  @override
  State<KeybordKeyRender> createState() => _KeybordKeyRenderState();
}

class _KeybordKeyRenderState extends State<KeybordKeyRender> {
  late List<List<dynamic>> keys;
  late KeybordAmountController? providerAmountController;
  //키보드로 누른 금액을 저장하는 변수
  late String amount;

  @override
  void initState() {
    super.initState();
    providerAmountController =
        Provider.of<KeybordAmountController>(context, listen: false);

    //키배열
    keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['.', '0', const Icon(Icons.keyboard_backspace, color: Colors.white)],
    ];
    amount = providerAmountController!.amount.toString();
  }

  @override
  Widget build(BuildContext context) {
    return renderKeyboard();
  }

  onKeyTap(val) {
    amount = providerAmountController!.amount + val;
    providerAmountController!.onKeyTap(amount);
  }

  onBackspacePress() {
    if (providerAmountController!.amount.isEmpty &&
        providerAmountController!.diplayValue.isEmpty) {
      return;
    } else {
      amount = providerAmountController!.amount
          .substring(0, providerAmountController!.amount.length - 1);
      providerAmountController!.onKeyTap(amount);
    }
  }

  Widget renderKeyboard() {
    return Column(
      children: keys
          .map((keysList) => Row(
                children: keysList.map((key) {
                  return Expanded(
                    child: KeyboardKey(
                      label: key,
                      value: key,
                      onTap: (val) {
                        if (val is Widget) {
                          onBackspacePress();
                        } else {
                          onKeyTap(val);
                        }
                        // print('val:${val}');
                      },
                    ),
                  );
                }).toList(),
              ))
          .toList(),
    );
  }
}
