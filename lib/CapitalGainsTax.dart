// ignore_for_file: avoid_unnecessary_containers
import 'dart:convert';

import 'package:calculator_frontend/CapGainWidgets/CapGainTaxBody.dart';
import 'package:calculator_frontend/widgets/LargeText.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:async/async.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_localizations/flutter_localizations.dart';

class CapitalGainsTaxPage extends StatefulWidget {
  const CapitalGainsTaxPage({Key? key}) : super(key: key);

  @override
  State<CapitalGainsTaxPage> createState() => _CapitalGainsTaxPageState();
}

class _CapitalGainsTaxPageState extends State<CapitalGainsTaxPage> {

  String? houseNum;

  late CapGainBody body1;
  late CapGainBody body2;
  late CapGainBody body3;

  String addr_hinttext = '서울특별시 서초구 반포대로4(서초동) 101동 206호';
  Color samplecolor = Colors.black38;
  bool isSearchedAddress = false;
  bool isSearchedDong = false;
  bool isSearchedHo = false;


  final mainColor = 0xff80cfd5;
  final Color _shadowTextColor = Colors.black38;

  String sampleAddress = '서울특별시 서초구 반포대로 4(서초동)';
  final backgroundColor = 0xfffafafa;

  String? buyDate;
  String? contractDate;

  late int _stage;
  List<String> _houseNumList = ['1주택','2주택','3주택'];
  List<bool> _houseNumBoolList = [true, false, false];

  final TextEditingController _transferDateTC = TextEditingController();
  bool _donthaveTransferDate = false;


  List acquisitionETCTCList = List.generate(5, (index) => TextEditingController());

  final asyncMemoizer = AsyncMemoizer();

  List<List<dynamic>> firstFilterCSV = [];
  List<List<dynamic>> currentCSV = [];
  List<List<dynamic>> originCSV = [];

  DateTime? _expectedTransferDate;

  Future getCSVonce() => asyncMemoizer.runOnce(()async{
    String _rawData1 = await rootBundle.loadString('assets/capgain/firstFilter.CSV');
    String _rawData2 = await rootBundle.loadString('assets/capgain/AcquisitionDate.CSV');

     List<List<dynamic>> listData1 = [];// =  CsvToListConverter().convert(_rawData1);
     List<List<dynamic>> listData2 = []; //=  CsvToListConverter().convert(_rawData2);

    List<String> _l1 = _rawData1.split('\n');
    for(int i = 0 ; i < _l1.length ; i++){
      listData1.add(_l1[i].split(','));
    }

    List<String> _l2 = _rawData2.split('\n');
    for(int i = 0 ; i < _l2.length ;i++){
      List<dynamic> _list = _l2[i].split(',');

      listData2.add(_l2[i].split(','));
    }

    listData1.removeLast();
    listData2.removeLast();

    for(int i = 0 ; i <listData2.length ; i++){
      if(listData2[i][7] != null && listData2[i][7].length > 0){
        listData2[i][7] = listData2[i][7].toString().substring(0,listData2[i][7].length - 1);
      }
    }




    List<List<dynamic>> res = listData1.where((element) => (element[3] == '1')).toList();

    firstFilterCSV = res;
    currentCSV = res;
    originCSV = listData2;


    return res;
  });

  List<List<dynamic>> filterList(List<List<dynamic>> input, int index, String criteria){
    List<List<dynamic>> res = input.where((element) => element[index] == criteria).toList();
    return res;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _stage = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 1200,
            ),
            child: FutureBuilder(
                future: getCSVonce(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    List<List<dynamic>> res = snapshot.data as List<List<dynamic>>;
                    return ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        largeTitle(),
                        firstDivider(),
                        Row(
                          children: [
                            _smallTitle('주택 수 선택'),
                            Expanded(child: Container(
                              height: 80,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 10, 30, 10),
                                    child: buildActionChip1(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 10, 30, 10),
                                    child: buildActionChip2(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 10, 30, 10),
                                    child: buildActionChip3(),
                                  ),
                                ],

                              ),
                            ))

                          ],
                        ),//주택수
                        Row(
                          children: [
                            _smallTitle('양도예정일'),
                            _getDateTime(),
                            // SizedBox(
                            //   width: 140,
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children: [
                            //       Transform.scale(
                            //         scale: 1.1,
                            //         child: Checkbox(
                            //           shape: RoundedRectangleBorder(
                            //             borderRadius: BorderRadius.circular(35),
                            //           ),
                            //           side: BorderSide(width: 1, color: Color(mainColor)),
                            //           checkColor: Colors.white,
                            //           activeColor: Color(mainColor),
                            //           value: _donthaveTransferDate,
                            //           onChanged: (bool? value){
                            //             setState(() {
                            //               _donthaveTransferDate = value!;
                            //               _stage = 4;
                            //             });
                            //           },
                            //         ),
                            //       ),
                            //       const SizedBox(
                            //         width: 1,
                            //       ),
                            //       const Text(
                            //         '미정',
                            //         style: TextStyle(fontSize: 17),
                            //       )
                            //     ],
                            //   ),
                            // ),
                            Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Tooltip(
                                child:Icon(Icons.build_circle, color: Color(mainColor),size: 30),
                                message: '탭하여 양도예정일을 선택해 주세요',
                                textStyle: TextStyle(fontSize: 15,color: Colors.white),
                              ),
                            )
                          ],
                        ),//양도예정일
                        body(res),
                        Container(
                          height: 50,
                          margin: const EdgeInsets.fromLTRB(0, 50, 0, 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(primary: Color(mainColor)),
                            onPressed: () {
                              if (_checkFormIsCompleted()) {
                                //Navigator.pushNamed(context, '/capgainres');
                              } else {
                                setState(() {});
                              }
                            },
                            child: const Text(
                              '계산하기',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                }
            ),
          ),
        )
    );
  }

  Widget _getDateTime(){
    String example = "날짜를 입력해 주세요";
    Color color = _shadowTextColor;
    if(_expectedTransferDate != null){
      example = '${_expectedTransferDate!.year}-${_expectedTransferDate!.month}-${_expectedTransferDate!.day}' ;
      color = Colors.black;
    }

    return Expanded(
        child: GestureDetector(
          onTap: ()async{
            _expectedTransferDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100)
            );
            setState(() {
              _expectedTransferDate;
            });
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

  Widget _expectedTransferDate2(TextEditingController tc, String hintText,bool able) {
    return Expanded(
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: TextField(
            onChanged: (text){
              if(tc.text.length == 8){
                setState(() {
                  _stage = 4;
                });
              }
              else {
                setState(() {
                  _stage = 3;
                });
              }
            },
            enabled: able,
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

  Widget body(List<List<dynamic>> res){
    String? _transferDate;

    if(_expectedTransferDate != null){
      _transferDate = _expectedTransferDate!.year.toString() +  _expectedTransferDate!.month.toString()+_expectedTransferDate!.day.toString();
    }

    if(houseNum == null || houseNum == '1주택'){
      body1 = CapGainBody(res: res,originCSV: originCSV,transferDate: _transferDate);
      return body1;
    }else if( houseNum == '2주택'){
      body1 = CapGainBody(res: res,originCSV: originCSV,transferDate: _transferDate,);
      body2 = CapGainBody(res: res,originCSV: originCSV,transferDate: _transferDate);
      return ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          _middleTitle('첫번째 주택'),
          body1,
          _middleTitle('두번째 주택'),
          body2
        ],
      );
    }else{
      body1 = CapGainBody(res: res,originCSV: originCSV,transferDate: _transferDate);
      body2 = CapGainBody(res: res,originCSV: originCSV,transferDate: _transferDate);
      body3 = CapGainBody(res: res,originCSV: originCSV,transferDate: _transferDate);
      return ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          _middleTitle('첫번째 주택'),
          body1,
          _middleTitle('두번째 주택'),
          body2,
          _middleTitle('세번째 주택'),
          body3
        ],
      );
    }
  }
  ActionChip buildActionChip1() {
    return ActionChip(
        onPressed: () {
          setState(() {
            if(_houseNumBoolList[0] == false){
              _houseNumBoolList[0] = true;
              _houseNumBoolList[1] = false;
              _houseNumBoolList[2] = false;
              houseNum = _houseNumList[0];
            }
          });
        },
        labelPadding: const EdgeInsets.all(5),
        backgroundColor:
        _houseNumBoolList[0] ? Color(mainColor) : Colors.white,
        elevation: 2,
        avatar: CircleAvatar(
          backgroundColor: _houseNumBoolList[0]
              ? Colors.white60
              : Color(mainColor).withOpacity(.6),
          child: Text(_houseNumList[0][0]),
        ),
        shadowColor: Colors.grey[100],
        padding: const EdgeInsets.all(6),
        label: Text(
          _houseNumList[0],
          style: TextStyle(
              color: _houseNumBoolList[0]? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 17),
        ));
  }
  ActionChip buildActionChip2() {
    return ActionChip(
        onPressed: () {
          setState(() {
            if(_houseNumBoolList[1] == false){
              _houseNumBoolList[0] = false;
              _houseNumBoolList[1] = true;
              _houseNumBoolList[2] = false;
              houseNum = _houseNumList[1];
            }
          });
        },
        labelPadding: const EdgeInsets.all(5),
        backgroundColor:
        _houseNumBoolList[1] ? Color(mainColor) : Colors.white,
        elevation: 2,
        avatar: CircleAvatar(
          backgroundColor: _houseNumBoolList[1]
              ? Colors.white60
              : Color(mainColor).withOpacity(.6),
          child: Text(_houseNumList[1][0]),
        ),
        shadowColor: Colors.grey[100],
        padding: const EdgeInsets.all(6),
        label: Text(
          _houseNumList[1],
          style: TextStyle(
              color: _houseNumBoolList[1]? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 17),
        ));
  }
  ActionChip buildActionChip3() {
    return ActionChip(
        onPressed: () {
          setState(() {
            if(_houseNumBoolList[2] == false){
              _houseNumBoolList[0] = false;
              _houseNumBoolList[1] = false;
              _houseNumBoolList[2] = true;
              houseNum = _houseNumList[2];
            }
          });
        },
        labelPadding: const EdgeInsets.all(5),
        backgroundColor:
        _houseNumBoolList[2] ? Color(mainColor) : Colors.white,
        elevation: 2,
        avatar: CircleAvatar(
          backgroundColor: _houseNumBoolList[2]
              ? Colors.white60
              : Color(mainColor).withOpacity(.6),
          child: Text(_houseNumList[2][0]),
        ),
        shadowColor: Colors.grey[100],
        padding: const EdgeInsets.all(6),
        label: Text(
          _houseNumList[2],
          style: TextStyle(
              color: _houseNumBoolList[2]? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 17),
        ));
  }



  bool _checkFormIsCompleted() {
    return true;
  }


  Widget _middleTitle(String txt){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  margin: const EdgeInsets.only(left: 10, right: 15),
                  child: Divider(
                    color: Color(mainColor),
                    height: 20,
                  )),
            ),
            Text(
              txt,
              style: TextStyle(fontSize: 19),
            ),
            Expanded(
              child: Container(
                  margin: const EdgeInsets.only(left: 15, right: 10),
                  child:  Divider(
                    color: Color(mainColor),
                    height: 20,
                  )),
            ),

          ]
      ),
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
        text: '양도소득세 통합 계산',
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




