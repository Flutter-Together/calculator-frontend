import 'package:calculator_frontend/CapGainWidgets/CapGainTaxBody.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CustomOXDropDown extends StatefulWidget {

  final String widgetName;
  final bool activated;

  CustomOXDropDown({Key? key, required this.activated, required this.widgetName}) : super(key: key);

  @override
  State<CustomOXDropDown> createState() => _CustomOXDropDownState();

}

class _CustomOXDropDownState extends State<CustomOXDropDown> {

  final mainColor = 0xff80cfd5;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String? selected;

  final backgroundColor = 0xfffafafa;

  @override
  Widget build(BuildContext context) {
    CapGainBodyState? capGainBodyState = context.findRootAncestorStateOfType<CapGainBodyState>();

    if(capGainBodyState!.selectedDropDownTable.containsKey(widget.widgetName)){
      selected = capGainBodyState!.selectedDropDownTable[widget.widgetName];
    }

    return Expanded(
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints){
              return DropdownButtonHideUnderline(
                child: DropdownButton2(
                  isExpanded: true,
                  items: ((){
                    if(widget.activated){
                      return ['O','X'];
                    }else return [];})().map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 17,
                        //color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )).toList(),
                  value: selected,
                  onChanged: (value) {
                    capGainBodyState!.setState(() {
                     capGainBodyState.selectedDropDownTable[widget.widgetName] = value as String;
                    });
                  },
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                  ),
                  iconSize: 30,
                  buttonHeight: 50,
                  buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                  buttonDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: ((){
                      if(widget.activated){
                        return Border.all(color: Color(mainColor));
                      }
                      else {return Border.all(color: Colors.black12);
                      }})(),
                    color: ((){
                      if(widget.activated){
                        return Color(backgroundColor);
                      }
                      else {return Colors.black12;
                      }})(),
                  ),
                  buttonElevation: 2,
                  itemHeight: 40,
                  itemPadding: const EdgeInsets.only(left: 14, right: 14),
                  dropdownMaxHeight: 200,
                  dropdownWidth: constraints.maxWidth,
                  dropdownPadding: null,
                  dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    // color: Colors.redAccent,
                  ),
                  dropdownElevation: 8,
                  scrollbarRadius: const Radius.circular(40),
                  scrollbarThickness: 6,
                  scrollbarAlwaysShow: true,
                  offset: const Offset(0, 0),
                ),
              );
            },
          ),
        )
    );
  }
}