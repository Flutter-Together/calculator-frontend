// ignore_for_file: avoid_unnecessary_containers
import 'dart:convert';
import 'dart:html';
import 'package:calculator_frontend/widgets/LargeText.dart';
import 'package:csv/csv.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

class CapitalGainsTaxPage extends StatefulWidget {
  const CapitalGainsTaxPage({Key? key}) : super(key: key);

  @override
  State<CapitalGainsTaxPage> createState() => _CapitalGainsTaxPageState();
}

class _CapitalGainsTaxPageState extends State<CapitalGainsTaxPage> {

  final mainColor = 0xff80cfd5;

  bool _isSearchedAddress = false; //flase 이면 주소 검색을 아직 안한 상태, 1이면 검색을 한 상태

  String sampleAddress = '서울특별시 서초구 반포대로 4(서초동)';
  Color _color = Colors.black38;
  final backgroundColor = 0xfffafafa;

  final List<List<String>> _reduceTaxHouseList = [
    ['19000101','20001231','취득일','1986.1.1~2000.12.31 신축된 5호 이상의 주택을 5년이상 임대한 국민주택 또는 세액감면대상 주택, 86년이전 신축 공동주택(입주사실 없는)'],
    ['19990101','20991231','취득일','1999.8.20~2001.12.31 신축된 1호이상의 주택을 포함한 2호이상의 주택을 5년이상 임대한 신축임대주택, 세액감면대상 주택'],
    ['19951101','19981231','계약일','1995.11.1~1997.12.31 1998.3.1~1998.12.31 서울외 지방의 미분양 국민주택 취득후 5년이상 임대한후에 양도'],
    ['20081103','20101231','계약일','2008.11.3~2010.12.31 수도권 미분양주택 취득분'],
    ['20090212','20100211','계약일','2009.2.12(비거주자 3.16)~2010.2.11 취득 서울시 밖에 미분양주택, 자기건설신축주택'],
    ['20100211','20110430','계약일','2010.2.11~2011.4.30 취득분 수도권밖 미분양주택'],
    ['20110329','20111231','계약일','2011.3.29현재 준공후 미분양주택을 2011년까지 취득하고 5년이상 임대하고 양도'],
    ['20120924','20121231','계약일','2012.9.24 현재 미분양주택을 2012년안에 취득한 9억원 이하의 주택'],
    ['20150101','20151231','계약일','2015.1.1~12.31 까지 취득(취득가액 6억원 이하, 연면적 135m이하)하여 5년이상 임대한 주택'],
    ['20130401','20131231','계약일','2013.4.1~2013.12.31 신축주택(취득가 6억원 이하 or 85m이하) 미분양주택']
  ];

  List<String?> _reduceTaxHouseChecklist = List.generate(10, (index) => null);

  DateTime? buyDate;
  DateTime? contractDate;

  final TextEditingController _transferDateTC = TextEditingController();
  final TextEditingController _findingAddressTC = TextEditingController();
  final TextEditingController _transferPriceTC = TextEditingController();
  final TextEditingController _acquisitionPriceTC = TextEditingController();
  final TextEditingController _manageDateTC = TextEditingController();
  final TextEditingController _businessStartDateTC = TextEditingController();
  final TextEditingController _rightPriceTC = TextEditingController();
  final TextEditingController _rentalHouseRegistrationDateTC = TextEditingController();

  List acquisitionETCTCList = List.generate(5, (index) => TextEditingController());

  final asyncMemoizer = AsyncMemoizer();

  // 양도시 종류["주택", "조합원 입주권", "분양권(2021년 이전 취득)", "분양권(2022년 이후 취득)"]
  // 취득시 종류["주택", "재건축전 주택", "주거용 오피스텔", "조합원 입주권", "분양권(2021년 이전 취득)", "분양권(2022년 이후 취득)"]
  // 취득 원인["매매", "증여", "상속", "자가신축"]

  List<List<dynamic>> firstFilterCSV = [];
  List<List<dynamic>> currentCSV = [];
  List<List<dynamic>> originCSV = [];

  List<String> _residencePeriod =  List.generate(11, (index){
    if(index == 0){
      return '1년 미만';
    }else {return '$index년 이상';}
  });

  String? _dropDownMenuForResidencePeriod;

  List<String> _typeOfTransfer = [];
  String? _dropDownMenuForTypeOfTransfer;
  List<String> _typeOfAcquisition = [];
  String? _dropDownMenuForTypeOfAcquisition;
  List<String> _reasonOfAquistition = [];
  String? _dropDownMenuForReasonOfAquistition;
  String? _dropDownMenuHavingHome;
  String? _dropDownMenuHavingHome_RentalHouse;

  bool? _shortRent;
  bool? _under85;

  late CustomDropDown _customDropdown;

  late int _stage;

  Future getCSVonce() => asyncMemoizer.runOnce(()async{
    final _rawData1 = await rootBundle.loadString('assets/capgain/firstFilter.CSV');
    final _rawData2 = await rootBundle.loadString('assets/capgain/AcquisitionDate.CSV');

    List<List<dynamic>> listData1 = const CsvToListConverter().convert(_rawData1);
    List<List<dynamic>> listData2 = const CsvToListConverter().convert(_rawData2);


    List<List<dynamic>> res = listData1.where((element) => (element[3] == 1)).toList();

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
                      children: <Widget>[
                        largeTitle(),
                        firstDivider(),
                        Row(
                          children: [
                            _smallTitle('주소'),
                            Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    var a = await _findingAddressDialog(_findingAddressTC);

                                    setState(() {
                                      sampleAddress = a;
                                      _color = Colors.black;
                                      _stage = 2;
                                    });
                                  },
                                  child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black,
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
                                            sampleAddress,
                                            style:
                                            TextStyle(fontSize: 17, color: _color),
                                          ),
                                        ],
                                      )),
                                ))
                          ],
                        ),//주소
                        Row(
                          children: [
                            _smallTitle('양도시 종류'),
                            Expanded(
                                child: Container(
                                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: GestureDetector(
                                    child: LayoutBuilder(
                                      builder: (BuildContext context,
                                          BoxConstraints constraints) {
                                        return DropdownButtonHideUnderline(
                                          child: DropdownButton2(
                                            isExpanded: true,
                                            items: (() {
                                              if (_stage >= 2) {
                                                List<List<dynamic>> temp =
                                                    firstFilterCSV;
                                                currentCSV = temp;
                                                _typeOfTransfer.clear();
                                                for (int i = 0; i < res.length; i++) {
                                                  _typeOfTransfer.add(res[i][2]);
                                                }
                                                _typeOfTransfer =
                                                    _typeOfTransfer.toSet().toList();
                                                return _typeOfTransfer;
                                              } else {
                                                return [];
                                              }
                                            })()
                                                .map((item) => DropdownMenuItem<String>(
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
                                            value: _dropDownMenuForTypeOfTransfer,
                                            onChanged: (value) {
                                              setState(() {
                                                _dropDownMenuForTypeOfTransfer = value as String;
                                                _stage = 3;
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
                                              border: Border.all(),
                                              color: ((){
                                                if(_stage >= 2){
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
                                  ),
                                )
                            ),
                          ],
                        ),//양도시 종류
                        Row(
                          children: [
                            _smallTitle('양도예정일'),
                            _expectedTransferDate(_transferDateTC, '20220725',((){
                              if(_stage >=3 ){return true;} else {return false;}})())
                          ],
                        ),//양도예정일
                        Row(
                          children: [
                            _smallTitle('취득 원인'),
                            Expanded(
                                child: Container(
                                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: LayoutBuilder(
                                    builder: (BuildContext context, BoxConstraints constraints){
                                      return DropdownButtonHideUnderline(
                                        child: DropdownButton2(
                                          isExpanded: true,
                                          items:((){
                                            if(_stage >= 4){
                                              _reasonOfAquistition.clear();
                                              currentCSV = currentCSV.where((element) => element[2] == _dropDownMenuForTypeOfTransfer).toList();

                                              for(int i = 0 ; i < currentCSV.length ; i++){
                                                _reasonOfAquistition.add(currentCSV[i][0]);
                                              }

                                              _reasonOfAquistition = _reasonOfAquistition.toSet().toList();

                                              return _reasonOfAquistition;
                                            }else {
                                              return [];
                                            }})().map((item) => DropdownMenuItem<String>(
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
                                          value: _dropDownMenuForReasonOfAquistition,
                                          onChanged: (value) {
                                            setState(() {
                                              _dropDownMenuForReasonOfAquistition = value as String;
                                              _stage = 5;
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
                                            border: Border.all(),
                                            color: ((){
                                              if(_stage >= 4){
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
                            ),
                          ],
                        ),//취득원인
                        Row(
                          children: [
                            _smallTitle('취득시 종류'),
                            Expanded(child: Container(
                              margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: LayoutBuilder(
                                builder: (BuildContext context, BoxConstraints constraints){
                                  return DropdownButtonHideUnderline(
                                    child: DropdownButton2(
                                      isExpanded: true,
                                      items: ((){
                                        if(_stage >= 5){
                                          _typeOfAcquisition.clear();
                                          currentCSV = currentCSV.where((element) => element[0] == _dropDownMenuForReasonOfAquistition).toList();

                                          for(int i = 0 ; i < currentCSV.length ; i++){
                                            _typeOfAcquisition.add(currentCSV[i][1]);
                                          }

                                          _typeOfAcquisition = _typeOfAcquisition.toSet().toList();

                                          return _typeOfAcquisition;
                                        }else {
                                          return [];
                                        }})()
                                          .map((item) => DropdownMenuItem<String>(
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
                                      value: _dropDownMenuForTypeOfAcquisition,
                                      onChanged: (value) {
                                        setState(() {
                                          _dropDownMenuForTypeOfAcquisition = value as String;
                                          _stage = 6;
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
                                        border: Border.all(),
                                        color:((){
                                          if(_stage >= 5){
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
                            )
                          ],
                        ),//취득시 종류
                        const Divider(),
                        AcquisitionDateETC(),//조건에 맞는 추가 선택란 1
                        const Divider(),
                        Row(
                          children: [
                            _smallTitle('취득후 거주기간'),
                            Expanded(
                                child: Container(
                                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: LayoutBuilder(
                                    builder: (BuildContext context, BoxConstraints constraints){
                                      return DropdownButtonHideUnderline(
                                        child: DropdownButton2(
                                          isExpanded: true,
                                          items:((){
                                            if(_stage >= 6){
                                              return _residencePeriod;
                                            }else {
                                              return [];
                                            }})().map((item) => DropdownMenuItem<String>(
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
                                          value: _dropDownMenuForResidencePeriod,
                                          onChanged: (value) {
                                            setState(() {
                                              _dropDownMenuForResidencePeriod = value as String;
                                              _stage = 7;
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
                                            border: Border.all(),
                                            color: ((){
                                              if(_stage >= 6){
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
                            ),
                          ],
                        ),//취득 후 거주기간
                        Row(
                          children: [
                            _smallTitle('양도가액'),
                            _transferPrice(_transferPriceTC, '700000000',_stage >= 7)
                          ],
                        ),//양도가액
                        Row(
                          children: [
                            _smallTitle('취득가액 및 필요경비'),
                            _acquisitionPrice(_acquisitionPriceTC, '10000000',_stage >= 8)
                          ],
                        ),//취득가액 및 필요경비
                        preReconstructionHouse(),
                        residentialOfficetel(),
                        Container(
                          height: 50,
                          margin: const EdgeInsets.fromLTRB(0, 50, 0, 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                            onPressed: () {
                              if (_checkFormIsCompleted()) {
                                setState(() {});
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

  Widget residentialOfficetel(){
    Widget rentalHouse(){
      return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Row(
            children: [
              _smallTitle('계약일&취득일 당시 무주택 여부'),
              Expanded(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints){
                        return DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            isExpanded: true,
                            items: ['O','X'].map((item) => DropdownMenuItem<String>(
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
                            value: _dropDownMenuHavingHome_RentalHouse,
                            onChanged: (value) {
                              setState(() {
                                _dropDownMenuHavingHome_RentalHouse = value as String;
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
                              border: Border.all(),
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
              )

            ],
          ),//계약일&취득일 당시 무주택 여부
          Row(
            children: [
              _smallTitle('임대주택 등록일'),
              _textField2(_rentalHouseRegistrationDateTC, '20160304', true)
            ],
          ),
          Row(
            children: [
              _smallTitle('임대주택 유형'),
              shortRentCheckBox( )
            ],
          ),
          Row(
            children: [
              _smallTitle('전용면적'),
              myOwnArea()
            ],
          ),
          Row(
            children: [
              _smallTitle('등록시 공시가격'),
              const Text('자동파악(추후 추가)')
            ],
          ),
          Row(
            children: [
              _smallTitle('수도권 유무'),
              const Text('자동파악(추후 추가)')
            ],
          ),
        ],
      );
    }
    Widget ruralHouse(){
      return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Row(
            children: [
              _smallTitle('조특법 농어촌주택'),
              const Text('추후 추가'),
            ],
          ),
          Row(
            children: [
              _smallTitle('소득세법 농어촌주택'),
              const Text('추후 추가'),
            ],
          ),
        ],
      );
    }
    Widget reduceTaxHouse(){
      return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _reduceTaxHouseList.length + 1,
          itemBuilder: (context, index){
            if(index == 0){
              return const Divider();
            }else {
              int _idx = index - 1;
              return Row(
                children: [
                  Expanded(
                      child: Text('$index. ${_reduceTaxHouseList[_idx][3]}',style: const TextStyle(fontSize: 17),)
                  ),
                  Container(
                    width: 150,
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints){
                        return DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            isExpanded: true,
                            items: ['O','X'].map((item) => DropdownMenuItem<String>(
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
                            value: _reduceTaxHouseChecklist[_idx],
                            onChanged: (value) {
                              setState(() {
                                _reduceTaxHouseChecklist[_idx] = value as String;
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
                              border: Border.all(),
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
                ],
              );
            }
          }
      );
    }

    if(_dropDownMenuForTypeOfTransfer == '주택(주거용 오피스텔 포함)'){
      return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const Divider(),
          rentalHouse(),
          ruralHouse(),
          reduceTaxHouse(),
        ],
      );
    }else {
      return Container();
    }
  }

  Widget myOwnArea(){
    List<String> option = ['85㎡이하','85㎡초과'];
    bool a;
    bool b;
    if(_under85 == null){
      a=false;
      b=false;
    }else if(_under85 == true){
      a=true;
      b=false;
    }else{
      a=false;
      b=true;
    }
    return Expanded(
        child: Row(
          children: [
            Checkbox(
                value: a,
                onChanged: (value){
                  setState(() {
                    if(a==true && b==false){
                      _under85 = null;
                    }else{
                      _under85 = value;
                    }
                  });
                }
            ),
            Text(option[0],style: const TextStyle(fontSize: 17),),
            const SizedBox(width: 20,),
            Checkbox(
                value: b,
                onChanged: (value){
                  setState(() {
                    if(a==false && b==true){
                      _under85 = null;
                    }else{
                      _under85 = !value!;
                    }
                  });
                }
            ),
            Text(option[1],style: const TextStyle(fontSize: 17)),
          ],
        )
    );
  }

  Widget shortRentCheckBox(){
    List<String> option = ['단기','장기일반'];
    bool a;
    bool b;
    if(_shortRent == null){
      a=false;
      b=false;
    }else if(_shortRent == true){
      a=true;
      b=false;
    }else{
      a=false;
      b=true;
    }
    return Expanded(
        child: Row(
          children: [
            Checkbox(
                value: a,
                onChanged: (value){
                  setState(() {
                    if(a==true && b==false){
                      _shortRent = null;
                    }else{
                      _shortRent = value;
                    }
                  });
                }
            ),
            Text(option[0],style: const TextStyle(fontSize: 17),),
            const SizedBox(width: 20,),
            Checkbox(
                value: b,
                onChanged: (value){
                  setState(() {
                    if(a==false && b==true){
                      _shortRent = null;
                    }else{
                      _shortRent = !value!;
                    }
                  });
                }
            ),
            Text(option[1],style: const TextStyle(fontSize: 17)),
          ],
        )
    );
  }

  Widget preReconstructionHouse(){
    if(_dropDownMenuForTypeOfAcquisition == '재건축전 주택'){
      return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const Divider(),
          Row(
            children: [
              _smallTitle('관리처분계획인가일'),
              _textField2(_manageDateTC, '20160304', true)
            ],
          ),
          Row(
            children: [
              _smallTitle('사업시행인가일'),
              _textField2(_businessStartDateTC, '19980218', true)
            ],
          ),
          Row(
            children: [
              _smallTitle('입주권 가치'),
              _textField2(_rightPriceTC, '17000000', true)
            ],
          ),
          const Divider(),
        ],
      );
    }else {
      return Container();
    }
  }


  Widget AcquisitionDateETC(){
    Widget whetherHavingHome(){
      return Row(
        children: [
          _smallTitle('계약일 당시 무주택 여부 (o,x)'),
          Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints){
                    return DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        isExpanded: true,
                        items: ['O','X'].map((item) => DropdownMenuItem<String>(
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
                        value: _dropDownMenuHavingHome,
                        onChanged: (value) {
                          setState(() {
                            _dropDownMenuHavingHome = value as String;
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
                          border: Border.all(),
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
          )
        ],
      );
    }
    if(_stage<6){
      return Container();
    }
    else {
      List<List<dynamic>> csv = originCSV.where((element) => (element[0] == _dropDownMenuForTypeOfTransfer) && (element[1] == _dropDownMenuForReasonOfAquistition) && (element[2] == _dropDownMenuForTypeOfAcquisition)).toList();

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: csv.length,
          itemBuilder: (context, index){
            if(csv[index][4] == '계약일 당시 무주택 여부 (o,x)'){
              return whetherHavingHome();
            }else {
              return Row(
                children: [
                  _smallTitle(csv[index][4]),
                  _textField2(acquisitionETCTCList[index],'',true)
                ],
              );
            }

          }
      );
    }


  }


  bool _checkFormIsCompleted() {
    return true;
  }

  Future<String> _findingAddressDialog(TextEditingController tc)async{
    setState((){
      _isSearchedAddress = false;
    });
    var res = await showDialog(
        context: context,
        builder: (BuildContext context){
          return StatefulBuilder(
              builder: (context, setState){
                return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1),
                    ),
                    title: Text('주소검색'),
                    content:Container(
                      width: 600,
                      constraints: const BoxConstraints(
                        minHeight: 500,
                        maxHeight: 800,
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: double.maxFinite,
                            margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: TextField(
                                controller: tc,
                                autofocus: true,
                                onSubmitted: (value){
                                  setState((){
                                    _isSearchedAddress = true;
                                  });
                                },
                                cursorColor: Colors.black,
                                textInputAction: TextInputAction.search,
                                style: const TextStyle(fontSize: 17),
                                decoration: InputDecoration(
                                    hintText: '반포대로',
                                    focusedBorder: _outlineInputBorder(),
                                    enabledBorder: _outlineInputBorder(),
                                    border: _outlineInputBorder(),
                                    suffixIcon: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
                                      child: IconButton(
                                        icon: const Icon(Icons.search, size: 40),
                                        color: Colors.black,
                                        onPressed: () {
                                          setState((){
                                            _isSearchedAddress = true;
                                          });
                                        },
                                      ),
                                    )
                                )
                            ),
                          ),
                          _isSearchedAddress? _addressList(tc.text)
                              : const Center(child: Text('검색어를 입력해주세요'),
                          )
                        ],
                      ),
                    )
                );
              }
          );
        }
    );
    return res;
  }



  Widget _addressList(String keyword){

    return Expanded(child: FutureBuilder(
        future: fetchAddress(keyword),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Color(mainColor)),
              ),
            );
          }else if(snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()));
          }
          List res = snapshot.data as List;
          return ListView.builder(
            itemCount: res.length,
            shrinkWrap: true,
            itemBuilder: (context, index){
              return _selectAddressBox(res[index][0],res[index][1],index);
            },
          );
        }
    ));
  }

  Widget _selectAddressBox(String newAddress, String oldAddress, int index){
    Color backgrouundColor;
    if(index.isEven){
      backgrouundColor = Colors.white;
    }else {backgrouundColor = Colors.black26;}

    return GestureDetector(
      onTap: (){Navigator.pop(context, newAddress);},
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
        decoration: BoxDecoration(
          color: backgrouundColor
        ),
        child: Column(
          children: [
            Text(newAddress),
            Text(oldAddress)
          ],
        ),
      ),
    );
  }


  Future<List> fetchAddress(String keyword) async{
    String baseURL = "https://wu26xy8cqj.execute-api.ap-northeast-2.amazonaws.com/default/juso_api?keyword=";

    final response = await http.get(Uri.parse(baseURL + keyword));

    if(response.statusCode == 200){

      List res = List.from(jsonDecode(utf8.decode(response.bodyBytes)));

      return res;
    }
    else {
      throw Exception("Fail to fetch address data");
    }
  }



  Widget _textField1(TextEditingController tc, String labelText) {
    return Expanded(
        child: Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: TextField(
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        controller: tc,
        cursorColor: Colors.black,
        textInputAction: TextInputAction.search,
        style: const TextStyle(fontSize: 17),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.black),
          focusedBorder: _outlineInputBorder(),
          enabledBorder: _outlineInputBorder(),
          border: _outlineInputBorder(),
        ),
      ),
    ));
  }

  Widget _transferPrice(TextEditingController tc, String hintText,bool able) {
    return Expanded(
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: TextField(
            onChanged: (text){
              if(tc.text.isNotEmpty){
                setState(() {
                  _stage = 8;
                });
              }
              else {
                setState(() {
                  _stage = 7;
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

  Widget _acquisitionPrice (TextEditingController tc, String hintText,bool able) {
    return Expanded(
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: TextField(
            onChanged: (text){
              if(tc.text.isNotEmpty){
                setState(() {
                  _stage = 9;
                });
              }
              else {
                setState(() {
                  _stage = 8;
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

  Widget _expectedTransferDate(TextEditingController tc, String hintText,bool able) {
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

  Widget _textField2(TextEditingController tc, String hintText,bool able) {
    return Expanded(
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: TextField(
            onChanged: (text){
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
    return const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
        borderRadius: BorderRadius.all(Radius.circular(10)));
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
    return Row(children: <Widget>[
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
    );

  }
}

class CustomDropDown extends StatefulWidget {

  final List items;
  final int currentStage;
  final int myStage;

  CustomDropDown({Key? key, required this.items,  required this.currentStage, required this.myStage}) : super(key: key);

  final _CustomDropDownState _state = _CustomDropDownState();

  @override
  State<CustomDropDown> createState() => _state;

  String? getSelectedItem(){
    return _state._selected;
  }
}

class _CustomDropDownState extends State<CustomDropDown> {

  String? _selected;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final backgroundColor = 0xfffafafa;

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints){
          return DropdownButtonHideUnderline(
            child: DropdownButton2(
              isExpanded: true,
              items: ((){
                if(widget.currentStage >= widget.myStage){
                  return widget.items;
                }else {
                  return [];
                }})().map((item) => DropdownMenuItem<String>(
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
              value: _selected,
              onChanged: (value) {
                setState(() {
                  _selected = value as String;
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
                border: Border.all(),
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
    );
  }
}