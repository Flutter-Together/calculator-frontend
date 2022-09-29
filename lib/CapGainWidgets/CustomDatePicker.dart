import 'package:calculator_frontend/CapGainWidgets/CapGainTaxBody.dart';
import 'package:flutter/material.dart';

class CustomDatePicker extends StatefulWidget {
  final String widgetName;
  const CustomDatePicker({Key? key, required this.widgetName}) : super(key: key);

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {

  final mainColor = 0xff80cfd5;
  final backgroundColor = 0xfffafafa;
  final shadowTextColor = Colors.black38;
  DateTime? dateTime;
  String example = "날짜를 입력해 주세요";
  late Color color;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CapGainBodyState? capGainBodyState = context.findRootAncestorStateOfType<CapGainBodyState>();

    if(capGainBodyState!.selectedDropDownTable.containsKey(widget.widgetName)){
      color = Colors.black;
      example = capGainBodyState!.selectedDropDownTable[widget.widgetName];
    }else {
      color = shadowTextColor;
    }

    return Expanded(
      child: GestureDetector(
        onTap: ()async{
          dateTime = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
          );

          if(dateTime != null){
            capGainBodyState!.setState(() {
              capGainBodyState.selectedDropDownTable[widget.widgetName] = dateTimeToString(dateTime!);
            });
          }
        },
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(color: Color(mainColor)),
              borderRadius: const BorderRadius.all(Radius.circular(10))
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(example,style: TextStyle(fontSize: 17,color: color),)
            ],
          ),
        ),
      ),
    );

  }

  String dateTimeToString(DateTime dateTime){
    String year = dateTime.year.toString();
    String month = '';
    String day = '';

    if(dateTime.month > 9){
      month = dateTime.month.toString();
    }else {
      month = '0${dateTime.month}';
    }

    if(dateTime.day > 9){
      day = dateTime.day.toString();
    }else {
      day = '0${dateTime.day}';
    }

    return year + month + day;
  }


}
