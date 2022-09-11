import 'package:calculator_frontend/widgets/LargeText.dart';
import 'package:flutter/material.dart';

class CapGainResult extends StatefulWidget {
  const CapGainResult({Key? key}) : super(key: key);

  @override
  State<CapGainResult> createState() => _CapGainResultState();
}

class _CapGainResultState extends State<CapGainResult> {
  final mainColor = 0xff80cfd5;
  final backgroundColor = 0xfffafafa;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints:const BoxConstraints(
            maxWidth: 1200,
          ),
          child: ListView(
              children: [
                largeTitle(),
                Divider(
                  color: Color(mainColor),
                ),
                ElevatedButton(
                  onPressed: ()async{
                    await _showTaxTable();
                  },
                  style: ElevatedButton.styleFrom(primary: Color(mainColor)),
                  child: Text('세율표'),
                ),
              ],
          ),
        ),
      ),
    );
  }

  Future<void> _showTaxTable()async{
    int fontSize = 15;

    Widget _item(String txt){
      return Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
          child: Text(
            txt,
            style: TextStyle(fontSize: 17),
          ),
        ),
      );
    }

    await showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('양도소득세율표'),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.cancel_outlined,
                        color: Color(mainColor),
                        size: 35,
                      )),
                )
              ],
            ),
            content: Container(
                color: Colors.grey[60],
                width: 700,
              child:  Table(
                columnWidths: const <int, TableColumnWidth>{
                  0: IntrinsicColumnWidth(),
                  1: FlexColumnWidth(),
                  2: FlexColumnWidth(),
                  3: FlexColumnWidth(),
                  4: FlexColumnWidth(),
                },
                children:  [
                  TableRow(
                      children: [
                        _item('과세표준'),
                        _item('일반세율'),
                        _item('2주택 중과세율'),
                        _item('3주택 중과세율'),
                        _item('누진공제액'),
                      ]
                  ),
                  TableRow(
                      children: [
                        _item('0 ~ 1,200만'),
                        _item('6%'),
                        _item('26%'),
                        _item('36%'),
                        _item('-'),
                      ]
                  ),
                  TableRow(
                      children: [
                        _item('1,200만 ~ 4,600만'),
                        _item('15%'),
                        _item('35%'),
                        _item('45%'),
                        _item('1,080,000'),
                      ]
                  ),
                  TableRow(
                      children: [
                        _item('4,600만 ~ 8,800만'),
                        _item('24%'),
                        _item('44%'),
                        _item('54%'),
                        _item('5,220,000'),
                      ]
                  ),
                  TableRow(
                      children: [
                        _item('8,800만 ~ 15,000만'),
                        _item('35%'),
                        _item('55%'),
                        _item('65%'),
                        _item('14,900,000'),
                      ]
                  ),
                  TableRow(
                      children: [
                        _item('15,000만 ~ 30,000만'),
                        _item('38%'),
                        _item('58%'),
                        _item('68%'),
                        _item('19,400,000'),
                      ]
                  ),
                  TableRow(
                      children: [
                        _item('30,000만 ~ 50,000만'),
                        _item('40%'),
                        _item('60%'),
                        _item('70%'),
                        _item('25,400,000'),
                      ]
                  ),
                  TableRow(
                      children: [
                        _item('30,000만 ~ 50,000만'),
                        _item('40%'),
                        _item('60%'),
                        _item('70%'),
                        _item('35,400,000'),
                      ]
                  ),
                  TableRow(
                      children: [
                        _item('50,000만 ~ 100,000만'),
                        _item('42%'),
                        _item('62%'),
                        _item('72%'),
                        _item('35,400,000'),
                      ]
                  ),
                  TableRow(
                      children: [
                        _item('100,000만~'),
                        _item('45%'),
                        _item('65%'),
                        _item('75%'),
                        _item('65,400,000'),
                      ]
                  ),
                ],
              ),
            )
          );
        }
    );
  }

  Widget _smallTitle(String txt) {
    return Container(
      width: 140,
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Text(
        txt,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }

  Widget largeTitle(){
    return const Padding(
        padding:  EdgeInsets.only(left: 10, top: 40, bottom: 20),
        child: LargeText(
          text: 'TAXAI 양도소득세 계산 결과',
          size: 25,
        )
    );
  }

  Widget firstDivider(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  margin: const EdgeInsets.only(left: 10, right: 15),
                  child: const Divider(
                    color: Colors.red,
                    height: 20,
                  )),
            ),
            const Text(
              "2022년 7월 세법개정(안) 반영",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Container(
                  margin: const EdgeInsets.only(left: 15, right: 10),
                  child: const Divider(
                    color: Colors.red,
                    height: 20,
                  )),
            ),

          ]
      ),
    );
  }
}
