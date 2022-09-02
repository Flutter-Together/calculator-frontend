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

  const NavigationBox(
      {Key? key,
        required this.isMedium,
        required this.pushNamed,
        required this.title_1,
        required this.title_2,
        required this.imagepath,
        this.boxColor = Colors.white,
        this.borderColor = Colors.black,
        this.iconColor = Colors.black,})
      : super(key: key);

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
        elevation: 2,
        shadowColor: Colors.grey,
        color: Colors.white,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          width: widget.isMedium == true
              ? MediaQuery.of(context).size.width / 2.5
              : MediaQuery.of(context).size.width / 5,
          height: widget.isMedium == true
              ? MediaQuery.of(context).size.width / 4.3
              : MediaQuery.of(context).size.width / 8,
          padding: widget.isMedium == true
              ? EdgeInsets.only(
            left: MediaQuery.of(context).size.width / 55,
          )
              : EdgeInsets.only(
            left: MediaQuery.of(context).size.width / 90,
          ),
          //padding 안쪽 여백
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 130,
                    bottom: MediaQuery.of(context).size.height / 160),
                child: Image.asset(
                  widget.imagepath,
                  fit: BoxFit.cover,
                  width: widget.isMedium == true
                      ? MediaQuery.of(context).size.width / 18
                      : MediaQuery.of(context).size.width / 28,
                  height: widget.isMedium == true
                      ? MediaQuery.of(context).size.width / 18
                      : MediaQuery.of(context).size.width / 28,
                  color: widget.iconColor,
                ),
              ),
              LargeText(
                text: widget.title_1,
                weight: FontWeight.bold,
                size: widget.isMedium == true
                    ? MediaQuery.of(context).size.width / 35
                    : MediaQuery.of(context).size.width / 70,
              ),
              LargeText(
                text: widget.title_2,
                weight: FontWeight.bold,
                size: widget.isMedium == true
                    ? MediaQuery.of(context).size.width / 35
                    : MediaQuery.of(context).size.width / 70,
              )
            ],
          ),
        ),
      ),
    );
  }
}