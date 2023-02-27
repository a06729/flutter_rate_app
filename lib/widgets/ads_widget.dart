import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsWidget extends StatefulWidget {
  const AdsWidget({super.key});

  @override
  State<AdsWidget> createState() => _AdsWidgetState();
}

class _AdsWidgetState extends State<AdsWidget> {
  //ios테스트 유닛
  final String iOSTestUnitId = 'ca-app-pub-3940256099942544/2934735716';
  //안드로이드 테스트 유닛
  final String androidTestUnitId = 'ca-app-pub-3940256099942544/6300978111';

  //안드로이드 릴리즈때 쓰는 유닛 번호
  final String androidUnitId = 'ca-app-pub-5504977758442742/6261817097';

  late BannerAd bannerAd;

  @override
  void initState() {
    super.initState();

    if (kReleaseMode) {
      //실제 앱에서 사용하는 배너
      bannerAd = BannerAd(
        listener: const BannerAdListener(),
        size: AdSize.banner,
        adUnitId: Platform.isIOS ? iOSTestUnitId : androidUnitId,
        request: const AdRequest(keywords: ['여행', '여행사', '여행지', '숙박']),
      )..load();
    } else {
      //테스트 앱에서 쓰는 배너
      bannerAd = BannerAd(
          listener: const BannerAdListener(),
          size: AdSize.banner,
          adUnitId: Platform.isIOS ? iOSTestUnitId : androidTestUnitId,
          request: const AdRequest(keywords: ['여행', '여행사', '여행지', '숙박']))
        ..load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: bannerAd == null ? Container() : AdWidget(ad: bannerAd),
    );
  }
}
