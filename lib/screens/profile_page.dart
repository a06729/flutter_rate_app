import 'package:exchange_rate_app/controller/theam_controller.dart';
import 'package:exchange_rate_app/services/social_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
      SocialLogin().kakaologout();
    }
    await FirebaseAuth.instance.signOut();
    Get.toNamed("/");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  String photoURL = snapshot.data!.photoURL.toString();
                  Color textColor = theamController.darkMod
                      ? Colors.white
                      : const Color(0xff181818);
                  // Color iconColor = theamController.darkMod
                  //     ? Colors.white
                  //     : const Color(0xff181818);
                  // Color profileBgColor = theamController.darkMod
                  //     ? const Color.fromRGBO(24, 24, 35, 1)
                  //     : const Color.fromRGBO(216, 216, 216, 1);
                  return ProfileImageWidget(
                    context,
                    photoURL,
                    snapshot,
                    textColor,
                  );
                } else {
                  return Text("");
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Container ProfileImageWidget(BuildContext context, String photoURL,
      AsyncSnapshot<User?> snapshot, Color textColor) {
    return Container(
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
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(
                    color: theamController.darkMod
                        ? const Color.fromRGBO(216, 216, 216, 1)
                        : const Color.fromRGBO(24, 24, 35, 1),
                  ),
                ),
              ),
            ),
            child: Text(
              "로그아웃",
              style: TextStyle(fontSize: 16, color: textColor),
            ),
          )
        ],
      ),
    );
  }
}
