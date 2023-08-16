import 'package:exchange_rate_app/controller/theam_controller.dart';
import 'package:exchange_rate_app/services/social_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  late TheamController theamController;
  @override
  void initState() {
    theamController = Provider.of<TheamController>(context, listen: false);
    super.initState();
  }

  Future<void> signOut() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    final uid = user.uid;
    if (uid.contains("kakao")) {
      await SocialLogin().kakaologout();
    } else if (uid.contains("line")) {
      await SocialLogin().lineLogout();
    } else {
      await SocialLogin().googleLogout();
    }
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor =
        theamController.darkMod ? const Color(0xff181818) : Colors.white;
    // Firebase.initializeApp();
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center();
        }
        return Drawer(
          backgroundColor: bgColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              drawerHeader(context),
              drawerMenuItems(context),
            ],
          ),
        );
      },
    );
  }

  Widget drawerHeader(BuildContext context) {
    Color textColor =
        theamController.darkMod ? Colors.white : const Color(0xff181818);
    // Color iconColor =
    //     theamController.darkMod ? Colors.white : const Color(0xff181818);
    Color profileBgColor = theamController.darkMod
        ? const Color.fromRGBO(24, 24, 35, 1)
        : const Color.fromRGBO(216, 216, 216, 1);
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            color: profileBgColor,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundImage: null,
                ),
                const SizedBox(
                  height: 12,
                ),
                SizedBox(
                  child: TextButton(
                    child: Text(
                      "로그인",
                      style: TextStyle(color: textColor, fontSize: 25),
                    ),
                    onPressed: () {
                      Get.back();
                      Get.toNamed("/loginPage");
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          String photoURL = snapshot.data!.photoURL.toString();
          return Container(
            color: profileBgColor,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(photoURL),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  "${snapshot.data!.displayName}",
                  style: TextStyle(fontSize: 28, color: textColor),
                ),
                Text(
                  '${snapshot.data!.email}',
                  style: TextStyle(fontSize: 16, color: textColor),
                ),
                TextButton(
                  onPressed: signOut,
                  child: Text(
                    "로그아웃",
                    style: TextStyle(fontSize: 16, color: textColor),
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }

  Widget drawerMenuItems(BuildContext context) {
    Color textColor =
        theamController.darkMod ? Colors.white : const Color(0xff181818);
    Color iconColor =
        theamController.darkMod ? Colors.white : const Color(0xff181818);
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.home_outlined, size: 30, color: iconColor),
            title: Text(
              "홈",
              style: TextStyle(fontSize: 20, color: textColor),
            ),
            onTap: () {
              Get.back();
              Get.toNamed("/");
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.chat, size: 30, color: iconColor),
          //   title: Text(
          //     "Ai 챗봇",
          //     style: TextStyle(fontSize: 20, color: textColor),
          //   ),
          //   onTap: () {
          //     Get.back();
          //     Get.toNamed("/chatPage");
          //   },
          // ),
        ],
      ),
    );
  }
}
