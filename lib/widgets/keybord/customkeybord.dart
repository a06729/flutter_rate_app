import 'package:exchange_rate_app/controller/keybord_amonut_controller.dart';
import 'package:exchange_rate_app/controller/rate_card_controller.dart';
import 'package:exchange_rate_app/widgets/keybord/keybord_key_render.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class CustomKeyboard extends StatefulWidget {
  const CustomKeyboard({super.key});

  @override
  State<CustomKeyboard> createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  late List<List<dynamic>> keys;

  late String amount;

  late KeybordAmountController? controller;

  late RateCardController? rateController;

  late TextEditingController _textController;
  var logger = Logger(
    printer: PrettyPrinter(),
  );

  @override
  initState() {
    super.initState();
    controller = Provider.of<KeybordAmountController>(context, listen: false);
    rateController = Provider.of<RateCardController>(context, listen: false);
    _textController = TextEditingController();
    amount = controller!.amount.toString();
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  Widget renderAmount() {
    TextStyle style = const TextStyle(
      fontSize: 30.0,
      fontWeight: FontWeight.bold,
      color: Colors.grey,
    );

    if (controller!.amount.isNotEmpty) {
      try {
        // NumberFormat f = NumberFormat('#,###');
        style = style.copyWith(color: Colors.black);
      } on FormatException {
        controller!.onKeyTap('');
      }
    }

    return Center(
      child: Consumer<KeybordAmountController>(
        builder: (context, value, child) {
          _textController.text = controller!.diplayValue;
          // amount = controller!.amount;
          return TextField(
            controller: _textController,
            showCursor: false,
            readOnly: true,
            style: style,
            maxLength: 13,
            decoration: const InputDecoration(
              hintText: '환전금액',
              hintStyle: TextStyle(fontSize: 20.0, color: Colors.white),
              counterText: '',
            ),
          );
        },
      ),
    );
  }

  renderConfirmButton() {
    return Consumer<KeybordAmountController>(
      builder: (context, value, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    disabledBackgroundColor: Colors.grey[200],
                    backgroundColor: Colors.orange,
                  ),
                  onPressed: value.amount.isNotEmpty
                      ? () async {
                          logger.d("amount:${value.amount}");
                          Navigator.pop(context);
                          await rateController!.rateApi(
                              rateController!.rateCardInfo,
                              value.amount,
                              value.countryCode);
                        }
                      : null,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      "확인",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const KeybordKeyRender(),
        renderConfirmButton(),
      ],
    );
  }
}
