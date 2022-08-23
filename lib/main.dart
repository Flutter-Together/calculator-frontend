import 'package:calculator_frontend/CapitalGainsTax.dart';
import 'package:calculator_frontend/resume_HoldingTax.dart';
import 'package:calculator_frontend/widgets/HomePage/LargeLayout.dart';
import 'package:calculator_frontend/widgets/HomePage/MediumLayout.dart';
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
      theme: ThemeData(
        primaryColor: Color(0xff80cfd5),
      ),
      home: MyHomePage(
          MediumLayout: const MediumLayout(), LargeLayout: const LargeLayout()),
      routes: {
        '/capgain': (context) => CapitalGainsTaxPage(),
        '/holding': (context) => Resume_HoldingTaxPage()
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  final Widget MediumLayout;
  final Widget LargeLayout;

  const MyHomePage(
      {Key? key, required this.MediumLayout, required this.LargeLayout})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 1200) {
        return MediumLayout;
      } else {
        return LargeLayout;
      }
    });
  }
}
