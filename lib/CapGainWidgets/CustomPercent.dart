import 'package:calculator_frontend/CapGainWidgets/CapGainTaxBody.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomPercentTextBox extends StatefulWidget {
  final String widgetName;
  final bool activated;
  const CustomPercentTextBox({Key? key, required this.activated, required this.widgetName}) : super(key: key);

  @override
  State<CustomPercentTextBox> createState() => _CustomPercentTextBoxState();
}

class _CustomPercentTextBoxState extends State<CustomPercentTextBox> {
  final mainColor = 0xff80cfd5;
  final backgroundColor = 0xfffafafa;
  final shadowTextColor = Colors.black38;


  final tc = TextEditingController();
  String hintText = 'OO%';
  @override
  Widget build(BuildContext context) {
    CapGainBodyState? capGainBodyState = context.findRootAncestorStateOfType<CapGainBodyState>();

    if(capGainBodyState!.selectedDropDownTable.containsKey(widget.widgetName)){
      tc.text = capGainBodyState.selectedDropDownTable[widget.widgetName];
    }
     return Expanded(
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: TextField(
            onChanged: (text){
              capGainBodyState.selectedDropDownTable[widget.widgetName] = text;
            },
            maxLength: 3,
            enabled: widget.activated,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            controller: tc,
            cursorColor: Colors.black,
            textInputAction: TextInputAction.search,
            style: const TextStyle(fontSize: 17),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.black38),
              focusedBorder: _outlineInputBorder(),
              enabledBorder: _outlineInputBorder(),
              border: _outlineInputBorder(),
            ),
          ),
        ));
  }

  OutlineInputBorder _outlineInputBorder() {
    return OutlineInputBorder(
        borderSide: BorderSide(color: Color(mainColor)),
        borderRadius: const BorderRadius.all(Radius.circular(10)));
  }
}
