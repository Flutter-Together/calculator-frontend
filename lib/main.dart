import 'package:calculator_frontend/CapitalGainsTax.dart';
import 'package:calculator_frontend/HoldingTax.dart';
import 'package:calculator_frontend/New_HoldingTax.dart';
import 'package:calculator_frontend/widgets/HomePage/Desktop_HomePage.dart';
import 'package:calculator_frontend/widgets/HomePage/Mobile_HomePage.dart';
import 'package:calculator_frontend/widgets/HomePage/Tablet_HomePage.dart';
import 'package:calculator_frontend/widgets/Mobile_HoldingTax.dart';
import 'package:flutter/material.dart';

//2022월 08월 16일 22시 22분
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TAXAI',
      debugShowCheckedModeBanner: false,
      color: Colors.transparent,
      theme: ThemeData(
        primaryColor: Colors.transparent,
        fontFamily: 'SpoqaHanSansNeo',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(
          TabletHomepage: TabletHomepage(),
          DesktopHomepage: DesktopHomepage(),
          MobileHomepage: MobileHomepage()),
      routes: {
        '/capgain': (context) => const CapitalGainsTaxPage(),
        '/holding': (context) => const HoldingTaxPage(DesktopTaxpage: Resume_HoldingTaxPage(), MobileTaxpage: Mobile_HoldingTaxPage()),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  final Widget TabletHomepage;
  final Widget DesktopHomepage;
  final Widget MobileHomepage;

  const MyHomePage(
      {Key? key,
      required this.TabletHomepage,
      required this.DesktopHomepage,
      required this.MobileHomepage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 1200) {
        return DesktopHomepage;
      } else if (constraints.maxWidth > 600) {
        return TabletHomepage;
      } else {
        return MobileHomepage; // Mobile 가로 길이 대부분 350 ~ 420
      }
    });
  }
}
