import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    const Color bgBlack = Color(0xff181818);
    return const Drawer(
      backgroundColor: bgBlack,
    );
  }
}
