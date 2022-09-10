import 'package:calculator_frontend/CapGainWidgets/CapGainTaxBody.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CustomDropDown extends StatefulWidget {

  final List<String> items;
  final String? selected;
  final String widgetName;
  final bool activated;

  CustomDropDown({Key? key, required this.items,this.selected, required this.activated, required this.widgetName}) : super(key: key);

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();

}

class _CustomDropDownState extends State<CustomDropDown> {

  final mainColor = 0xff80cfd5;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final backgroundColor = 0xfffafafa;

  @override
  Widget build(BuildContext context) {
    CapGainBodyState? capGainBodyState = context.findRootAncestorStateOfType<CapGainBodyState>();

    return Expanded(
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints){
              return DropdownButtonHideUnderline(
                child: DropdownButton2(
                  isExpanded: true,
                  items: widget.items.map((item) => DropdownMenuItem<String>(
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
                  value: widget.selected,
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
                    border: Border.all(
                      color: Color(mainColor)
                    ),
                    color: Color(backgroundColor),
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