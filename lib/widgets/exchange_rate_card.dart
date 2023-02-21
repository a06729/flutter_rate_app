import 'package:exchange_rate_app/services/exchange_rate_api.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';

class ExchangeRateCard extends StatelessWidget {
  final String currencyName, code, amount;
  final IconData icon;
  final bool isInverted;

  ExchangeRateCard({
    super.key,
    required this.currencyName,
    required this.code,
    required this.amount,
    required this.icon,
    required this.isInverted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: isInverted ? Colors.white : Colors.black,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currencyName,
                            style: TextStyle(
                              color: isInverted ? Colors.black : Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                amount,
                                style: TextStyle(
                                    color: isInverted
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                code,
                                style: TextStyle(
                                  color: isInverted
                                      ? Colors.black.withOpacity(0.8)
                                      : Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Transform.scale(
                        scale: 1.9,
                        child: Transform.translate(
                          offset: const Offset(5, 10),
                          child: Icon(
                            icon,
                            color: isInverted ? Colors.black : Colors.white,
                            size: 98,
                          ),
                        ),
                      )
                    ]),
              ),
            ),
          )
        ],
      ),
    );
  }
}
