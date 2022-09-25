import 'package:flutter/material.dart';


class LandingPage extends StatelessWidget {
  final Widget TabletLandingpage;
  final Widget DesktopLandingpage;
  final Widget MobileLandingpage;

  const LandingPage(
      {Key? key,
        required this.TabletLandingpage,
        required this.DesktopLandingpage,
        required this.MobileLandingpage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 1200) {
        return DesktopLandingpage;
      } else if (constraints.maxWidth > 600) {
        return TabletLandingpage;
      } else {
        return MobileLandingpage; // Mobile 가로 길이 대부분 350 ~ 420
      }
    });
  }
}
