import 'package:calculator_frontend/CapitalGainsTax.dart';
import 'package:calculator_frontend/New_HoldingTax.dart';
import 'package:calculator_frontend/widgets/HomePage/Desktop_HomePage.dart';
import 'package:calculator_frontend/widgets/HomePage/Mobile_HomePage.dart';
import 'package:flutter/material.dart';

//2022월 08월 16일 22시 22분
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  final Color mainColor = const Color(0xff80cfd5);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TAXAI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: mainColor,
        fontFamily: 'One_Mobile',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // 다양한 UI 구성 요소에 관한 밀도 지정 (android, ios, web, linux, macOS, windows 등 플랫폼에 맞게 시각적으로 보기 좋게

      ),
      home: MyHomePage(
          MobileHomepage: const MobileHomepage(), DesktopHomepage: const DesktopHomepage()),
      routes: {
        '/capgain': (context) => CapitalGainsTaxPage(),
        '/holding': (context) => Resume_HoldingTaxPage()
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  final Widget MobileHomepage;
  final Widget DesktopHomepage;

  const MyHomePage(
      {Key? key, required this.MobileHomepage, required this.DesktopHomepage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 1200) {
        return MobileHomepage;
      } else {
        return DesktopHomepage;
      }
    });
  }
}
