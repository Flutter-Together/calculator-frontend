import 'package:calculator_frontend/CapgainResult.dart';
import 'package:calculator_frontend/CapitalGainsTax.dart';
import 'package:calculator_frontend/New_HoldingTax.dart';
import 'package:calculator_frontend/widgets/HomePage/Desktop_HomePage.dart';
import 'package:calculator_frontend/widgets/HomePage/Mobile_HomePage.dart';
import 'package:calculator_frontend/widgets/LoginWebview.dart';
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
        fontFamily: 'One_Mobile',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(
          MobileHomepage: const MobileHomepage(),
          DesktopHomepage: const DesktopHomepage()),
      routes: {
        '/capgain': (context) => CapitalGainsTaxPage(),
        '/holding': (context) => Resume_HoldingTaxPage(),
        '/capgainres' : (context) => CapGainResult(),
        '/login' : (context) => LoginWebview()
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
