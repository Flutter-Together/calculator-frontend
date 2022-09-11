import 'package:calculator_frontend/widgets/LargeText.dart';
import 'package:flutter/material.dart';

class NavigationBox extends StatefulWidget {
  final String pushNamed;
  final String title_1;
  final String title_2;
  final Color boxColor;
  final Color borderColor;
  final String imagepath;
  final Color? iconColor;
  final bool isMedium;
  final bool? isCalculator;

  const NavigationBox({
    Key? key,
    required this.isMedium,
    required this.pushNamed,
    required this.title_1,
    required this.title_2,
    required this.imagepath,
    required this.isCalculator,
    this.boxColor = Colors.white,
    this.borderColor = Colors.black,
    this.iconColor = Colors.black,
  }) : super(key: key);

  @override
  State<NavigationBox> createState() => _NavigationBoxState();
}

class _NavigationBoxState extends State<NavigationBox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.pushNamed == '/') {
          return showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  title: Text('AI 컨설팅'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('추후 공개 예정입니다.'),
                    ],
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          '확인',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))
                  ],
                );
              });
        } else {
          await Navigator.pushNamed(context, widget.pushNamed);
        }
      },
      child: Card(
        elevation: 1,
        shadowColor: Colors.grey,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          width: 250,
          height: 150,
          padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
          //padding 안쪽 여백
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                        text: widget.title_1 + '\n',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black),
                        children: [TextSpan(text: widget.title_2)])),
              ),
              Spacer(),
              Padding(
                padding: widget.isCalculator == true
                    ? EdgeInsets.fromLTRB(0, 5, 5, 0)
                    : EdgeInsets.only(right: 5),
                child: Image.asset(widget.imagepath,
                    fit: BoxFit.fitWidth,
                    width: widget.isCalculator == true ? 50 : 65),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
