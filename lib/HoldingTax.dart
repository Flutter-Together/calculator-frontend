import 'package:calculator_frontend/New_HoldingTax.dart';
import 'package:calculator_frontend/widgets/LargeText.dart';
import 'package:calculator_frontend/widgets/MediumText.dart';
import 'package:flutter/material.dart';


class HoldingTaxPage extends StatelessWidget {
  final Widget MobileTaxpage;
  final Widget DesktopTaxpage;


  const HoldingTaxPage(
      {Key? key,
        required this.DesktopTaxpage,
        required this.MobileTaxpage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 900) {
        return DesktopTaxpage;
      } else return MobileTaxpage;
    });
  }
}
