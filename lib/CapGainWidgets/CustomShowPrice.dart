import 'package:calculator_frontend/CapGainWidgets/CapGainTaxBody.dart';
import 'package:flutter/material.dart';

class CustomShowOfficialPrice extends StatefulWidget {
  final String? dateTime;
  final String widgetName;
  final String shownName;
  const CustomShowOfficialPrice({Key? key, this.dateTime, required this.widgetName, required this.shownName}) : super(key: key);

  @override
  State<CustomShowOfficialPrice> createState() => _CustomShowOfficialPriceState();
}

class _CustomShowOfficialPriceState extends State<CustomShowOfficialPrice> {
  final mainColor = 0xff80cfd5;
  final backgroundColor = 0xfffafafa;
  final shadowTextColor = Colors.black38;

  late String sampleText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.dateTime == null){
      sampleText = '아직 ${widget.shownName}이 입력되지 않았습니다.';
    }
  }

  @override
  Widget build(BuildContext context) {
    CapGainBodyState? capGainBodyState = context.findRootAncestorStateOfType<CapGainBodyState>();
    if(capGainBodyState!.selectedDropDownTable.containsKey(widget.widgetName)){

    }else {

    }

    return Expanded(
      child: Container(
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(
                color: Color(mainColor),
              ),
              borderRadius: const BorderRadius.all(
                  Radius.circular(10))),
          margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  sampleText
              ),
            ],
          )),
    );
  }
}
