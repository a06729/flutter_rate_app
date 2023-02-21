import 'package:flutter/material.dart';

class KeyboardKey extends StatefulWidget {
  Widget customWidget;

  KeyboardKey({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
    this.customWidget = const Icon(Icons.abc),
  });

  final dynamic label;
  final dynamic value;
  final ValueSetter<dynamic> onTap;

  @override
  State<KeyboardKey> createState() => _KeyboardKeyState();
}

class _KeyboardKeyState extends State<KeyboardKey> {
  renderLabe() {
    if (widget.label is Widget) {
      return widget.label;
    }
    return Text(
      widget.label,
      style: const TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("widget.value:${widget.value}");
        widget.onTap(widget.value);
      },
      child: AspectRatio(
        aspectRatio: 2,
        child: Container(
            child: Center(
          child: renderLabe(),
        )),
      ),
    );
  }
}
