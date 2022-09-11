import 'dart:convert';

import 'package:calculator_frontend/CapGainWidgets/CustomDropDown.dart';
import 'package:calculator_frontend/widgets/HomePage/Search%20Address%20Api.dart';
import 'package:calculator_frontend/widgets/Address.dart';
import 'package:calculator_frontend/widgets/LargeText.dart';
import 'package:csv/csv.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

class CapGainBody extends StatefulWidget {
  final List<List<dynamic>> res;
  final List<List<dynamic>> originCSV;
  const CapGainBody({Key? key, required this.res, required this.originCSV}) : super(key: key);

  @override
  State<CapGainBody> createState() => CapGainBodyState();
}

class CapGainBodyState extends State<CapGainBody> {
  String addr_hinttext = '서울특별시 서초구 반포대로4(서초동) 101동 206호';
  Color samplecolor = Colors.black38;
  bool isSearchedAddress = false;
  bool isSearchedDong = false;
  bool isSearchedHo = false;


  String? _dropDownMenuPriorInheritanceHouse;
  final TextEditingController _address_keywordEditingController = TextEditingController();


  TempAddr _tempAddr = TempAddr();

  final mainColor = 0xff80cfd5;

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

  String? buyDate;
  String? contractDate;

  final TextEditingController _transferDateTC = TextEditingController();
  final TextEditingController _findingAddressTC = TextEditingController();
  final TextEditingController _transferPriceTC = TextEditingController();
  final TextEditingController _acquisitionPriceTC = TextEditingController();
  final TextEditingController _manageDateTC = TextEditingController();
  final TextEditingController _businessStartDateTC = TextEditingController();
  final TextEditingController _evaluatedPriceTC = TextEditingController();
  final TextEditingController _rentalHouseRegistrationDateTC = TextEditingController();
  final TextEditingController _payedMoneyTC = TextEditingController();
  final TextEditingController _getMoneyTC = TextEditingController();

  List acquisitionETCTCList = List.generate(5, (index) => TextEditingController());

  final asyncMemoizer = AsyncMemoizer();

  List<List<dynamic>> firstFilterCSV = [];
  List<List<dynamic>> currentCSV = [];
  List<List<dynamic>> originCSV = [];

  List<String> _residencePeriod =  List.generate(11, (index){
    if(index == 0){
      return '1년 미만';
    }else {return '$index년 이상';}
  });

  Map<String, dynamic> selectedDropDownTable = {
    'TypeOfTransfer':null,
    'TypeOfAcquisition':null,
    'ReasonOfAquistition':null,
    'HavingHome':null,
    'HavingHome_RentalHouse':null,
    'PriorInheritanceHouse':null,
    'reduceTaxHouseChecklist':List.generate(10, (index) => null)
  };

  String? _dropDownMenuForResidencePeriod;
  String? _dropDownMenuForHouseShare;

  List<String> _typeOfTransfer = [];
  String? _dropDownMenuForTypeOfTransfer;
  List<String> _typeOfAcquisition = [];
  String? _dropDownMenuForTypeOfAcquisition;
  List<String> _reasonOfAquistition = [];
  String? _dropDownMenuForReasonOfAquistition;
  String? _dropDownMenuHavingHome;
  String? _dropDownMenuHavingHome_RentalHouse;
  String? _dropDownMenuForKindOfConcession;

  bool? _shortRent;
  bool? _under85;
  bool _donthaveTransferDate = false;
  late int _stage;


  List<List<dynamic>> filterList(List<List<dynamic>> input, int index, String criteria){
    List<List<dynamic>> res = input.where((element) => element[index] == criteria).toList();
    return res;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _stage = 1;
    firstFilterCSV = widget.res;
    currentCSV = widget.res;
    originCSV = widget.originCSV;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children:  [
        Row(
          children: [
            _smallTitle('주소'),
            Expanded(
                child: GestureDetector(
                  onTap: () async {
                    var a = await Search_Address_Dialog2(_findingAddressTC);

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
                                for (int i = 0; i < widget.res.length; i++) {
                                  _typeOfTransfer.add(widget.res[i][2]);
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
                              border: ((){
                                if(_stage >= 2){
                                  return Border.all(color: Color(mainColor));
                                }
                                else {return Border.all(color: Colors.black12);
                                }})(),
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
              if(_stage >=3 && _donthaveTransferDate == false){return true;} else {return false;}})()),
            SizedBox(
              width: 140,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.scale(
                    scale: 1.1,
                    child: Checkbox(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                      side: BorderSide(width: 1, color: ((){
                        if(_stage >= 3){
                          return Color(mainColor);
                        }else {return Colors.black12;}
                      })()),
                      checkColor: Colors.white,
                      activeColor: Color(mainColor),
                      value: _donthaveTransferDate,
                      onChanged: (bool? value){
                        if(_stage<3){
                        }else {
                          setState(() {
                            _donthaveTransferDate = value!;
                            _stage = 4;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 1,
                  ),
                  const Text(
                    '미정',
                    style: TextStyle(fontSize: 17),
                  )
                ],
              ),
            )
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
                            border: ((){
                              if(_stage >= 4){
                                return Border.all(color: Color(mainColor));
                              }
                              else {return Border.all(color: Colors.black12);
                              }})(),
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
        _priorInheritanceHouse(),
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
                        border: ((){
                          if(_stage >= 5){
                            return Border.all(color: Color(mainColor));
                          }
                          else {return Border.all(color: Colors.black12);
                          }})(),
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
        AcquisitionDateETC(),//조건에 맞는 추가 선택란 1
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
                            border: ((){
                              if(_stage >= 6){
                                return Border.all(color: Color(mainColor));
                              }
                              else {return Border.all(color: Colors.black12);
                              }})(),
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
        Row(
          children: [
            _smallTitle('주택지분'),
            Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints){
                      return DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          items:((){
                            if(_stage >= 9){
                              return ["단독명의","공동명의"];
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
                          value: _dropDownMenuForHouseShare,
                          onChanged: (value) {
                            setState(() {
                              _dropDownMenuForHouseShare = value as String;
                              _stage = 10;
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
                              if(_stage >= 9){
                                return Border.all(color: Color(mainColor));
                              }
                              else {return Border.all(color: Colors.black12);
                              }})(),
                            color: ((){
                              if(_stage >= 9){
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
        ),
        preReconstructionHouse(),
        residentialOfficetel(),
      ],
    );
  }
  Widget _priorInheritanceHouse(){
    CustomDropDown priorDropdown = CustomDropDown(items: ['O','X'],selected: selectedDropDownTable['PriorInheritanceHouse'],widgetName: 'PriorInheritanceHouse',activated: _dropDownMenuForReasonOfAquistition == '상속');
    if(_dropDownMenuForReasonOfAquistition == '상속'){
      return Row(
        children: [
          _smallTitle('선순위 상속주택'),
          priorDropdown
        ],
      );
    }
    else{ return Container();}
  }

  Widget residentialOfficetel(){
    Widget rentalHouse(StateSetter _dialogSetState){
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
                              _dialogSetState(() {
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
              officialPriceWidget()
            ],
          ),
          Row(
            children: [
              _smallTitle('수도권 유무'),
              isSeoul()
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
              _smallTitle('조특법 농어촌주택',width: 180),
              const Text('추후 추가'),
            ],
          ),
          Row(
            children: [
              _smallTitle('소득세법 농어촌주택',width: 180),
              const Text('추후 추가'),
            ],
          ),
        ],
      );
    }
    Widget reduceTaxHouse(StateSetter _dialogState){

      List<List<String>> filtered = [];

      for(int i = 0 ; i < _reduceTaxHouseList.length ; i++){
        if(i<2){
          if(buyDate != null && buyDate!.length > 7){
            int _buyDate = int.parse(buyDate!);
            int a = int.parse(_reduceTaxHouseList[i][0]);
            int b = int.parse(_reduceTaxHouseList[i][1]);
            if(_buyDate>=a && _buyDate <= b){
              filtered.add(_reduceTaxHouseList[i]);
            }
          }
        }else{
          if(contractDate != null && contractDate!.length > 7){
            int _contractDate = int.parse(contractDate!);
            int a = int.parse(_reduceTaxHouseList[i][0]);
            int b = int.parse(_reduceTaxHouseList[i][1]);

            if(_contractDate>=a && _contractDate<=b){
              filtered.add(_reduceTaxHouseList[i]);
            }

          }
        }
      }

      return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filtered.length + 1,
          itemBuilder: (context, index){
            if(index == 0){
              return const Divider();
            }else {
              int _idx = index - 1;
              return Row(
                children: [
                  Expanded(
                      child: Text('$index. ${filtered[_idx][3]}',style: const TextStyle(fontSize: 17),)
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
                              _dialogState(() {
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
                              border: Border.all(color: Color(mainColor)),
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

    Future<void> ruralHouseDialog()async{
      await showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: Text('농어촌주택 관련 추가선택'),
              content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter dialogSetState){
                    return Container(
                      width: 600,
                      child: ruralHouse(),
                    );
                  },
              )
            );
          }
      );
    }

    Future<void> rentalHouseDialog()async{
      await showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: Text('임대주택 관련 추가선택'),
              content:StatefulBuilder(
                builder: (BuildContext context,StateSetter dialogSetState){
                  return Container(
                    width: 600,
                    constraints: BoxConstraints(
                      minHeight: 500,
                      maxHeight: 800,
                    ),
                    child: rentalHouse(dialogSetState),
                  );
                },
              ),
            );
          }
      );
    }

    Future<void> reduceTaxHouseDialog()async{
      await showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: Text('조특법상 감면주택 관련 추가선택'),
              content: StatefulBuilder(
                builder: (BuildContext context,StateSetter dialogSetState ){
                  return Container(
                    width: 600,
                    constraints: BoxConstraints(
                      minHeight: 500,
                      maxHeight: 800,
                    ),
                    child: reduceTaxHouse(dialogSetState),
                  );
                },
              ),
            );
          }
      );
    }

    if(_dropDownMenuForTypeOfTransfer == '주택(주거용 오피스텔 포함)'){
      return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: const Text(
                  '임대주택 관련 추가선택',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              IconButton(
                  onPressed: ()async{
                    await rentalHouseDialog();
                  },
                  icon: Icon(Icons.add_circle_outline,color: Color(mainColor),size: 30,)
              )
            ],
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: const Text(
                  '농어촌주택 관련 추가선택',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              IconButton(
                  onPressed: ()async{
                    await ruralHouseDialog();
                  },
                  icon: Icon(Icons.add_circle_outline,color: Color(mainColor),size: 30,)
              )
            ],
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: const Text(
                  '조특법상 감면주택 관련 추가선택',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              IconButton(
                  onPressed: ()async{
                    await reduceTaxHouseDialog();
                  },
                  icon: Icon(Icons.add_circle_outline,color: Color(mainColor),size: 30,)
              )
            ],
          ),
        ],
      );
    }else {
      return Container();
    }
  }

  Widget isSeoul(){
    if(_tempAddr.pnu != null && (_tempAddr.pnu!.substring(0,2) == '11' || _tempAddr.pnu!.substring(0,2) == '28' || _tempAddr.pnu!.substring(0,2) == '41')){
      return Text('O',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),);
    }else return Text('X',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold));
  }

  Widget officialPriceWidget(){
    if(_tempAddr.pnu != null && _transferDateTC.text.length > 7){
      return FutureBuilder(
          future: fetchOfficialPrice(_tempAddr.pnu!,  _transferDateTC.text),
          builder: (BuildContext context, AsyncSnapshot snapshot){

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child:  CircularProgressIndicator(),);
            }
            //error가 발생하게 될 경우 반환하게 되는 부분
            else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '공시가격 fetch error: ${snapshot.error}',
                  style: const TextStyle(fontSize: 15),
                ),
              );
            }
            // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
            else {
              return Text(snapshot.data.toString(),style: const TextStyle(fontSize: 17),);
            }
          }
      );
    }
    else {return Container();}
  }


  Future<String> fetchOfficialPrice(String pnu, String date)async{
    String baseURL = 'https://zxwd1u54il.execute-api.ap-northeast-2.amazonaws.com/default/price_api?';

    final response = await http.get(Uri.parse('${baseURL}pnu=$pnu&year=${date.substring(0,4)}'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes)); //한글 깨짐 방지를 위해 json.decode(response.body) 대신

      final res = jsonResponse['results'];

      if(res['metadata']['errorCode'] == "0"){
        return res['metadata']['field']['price'];
      }else{
        return  res['metadata']['errorMessage'];
      }
    } else {
      throw Exception("Fail to fetch address data");
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
              _smallTitle('종전 주택의 평가액'),
              _textField2(_evaluatedPriceTC, '17000000', true)
            ],
          ),
          Row(
            children: [
              _smallTitle('납부한 분담금'),
              _textField2(_payedMoneyTC, '17000000', true)
            ],
          ),
          Row(
            children: [
              _smallTitle('지원받은 청산금'),
              _textField2(_getMoneyTC, '17000000', true)
            ],
          ),
        ],
      );
    }else {
      return Container();
    }
  }

  Widget AcquisitionDateETC(){
    Widget whetherHavingHomeBody(){
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
                          border: Border.all(color: Color(mainColor)),
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
    Widget whetherHavingHome(){
      if(buyDate != null && buyDate!.length > 7 && contractDate != null && contractDate!.length > 7 && _tempAddr.pnu != null){
        return FutureBuilder(
            future: Future.wait([isConflict(_tempAddr.pnu!, buyDate!),isConflict(_tempAddr.pnu!, contractDate!)]),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if (snapshot.hasData == false) {
                return const Center(child:  CircularProgressIndicator(),);
              }
              //error가 발생하게 될 경우 반환하게 되는 부분
              else if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '조정지역 fetch error: ${snapshot.error}',
                    style: const TextStyle(fontSize: 15),
                  ),
                );
              }
              // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
              else {
                if(snapshot.data[0] && !snapshot.data[1]){
                  return whetherHavingHomeBody();
                }else {return Container();}
              }
            }
        );
      }else{
        return Container();
      }
    }

    Widget kindOfConcession(){
      return Row(
        children: [
          _smallTitle('분양권 종류'),
          Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints){
                    return DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        isExpanded: true,
                        items: ['승계 분양권','최초당첨 분양권'].map((item) => DropdownMenuItem<String>(
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
                        value: _dropDownMenuForKindOfConcession,
                        onChanged: (value) {
                          setState(() {
                            _dropDownMenuForKindOfConcession = value as String;
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
                          border: Border.all(color: Color(mainColor)),
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

    Widget Cession(List<List<dynamic>> _csv){
      if(_dropDownMenuForKindOfConcession == null){
        return Container();
      }
      else {
        List<List<dynamic>> _filtered = _csv.where((element) => element[6] == _dropDownMenuForKindOfConcession!).toList();
        return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _filtered.length,
            itemBuilder: (context, index){
              if(_filtered[index][7] == '취득일'){
                buyDate = acquisitionETCTCList[index].text;
                print('취득일은 : $buyDate');
              }
              if(_filtered[index][7] == '계약일'){
                contractDate = acquisitionETCTCList[index].text;
                print('계약일은 : $contractDate');
              }
              return Row(
                children: [
                  _smallTitle(_filtered[index][4].toString().replaceAll('"', '')),
                  _textField2(acquisitionETCTCList[index],'',true)
                ],
              );
            }
        );
      }
    }

    if(_stage<6){
      return Container();
    }
    else {
      List<List<dynamic>> csv = originCSV.where((element) => (element[0] == _dropDownMenuForTypeOfTransfer) && (element[1] == _dropDownMenuForReasonOfAquistition) && (element[2] == _dropDownMenuForTypeOfAcquisition)).toList();

      String? startInheritance;
      if(_dropDownMenuForTypeOfTransfer == '주택(주거용 오피스텔 포함)' && _dropDownMenuForReasonOfAquistition == '매매' && (_dropDownMenuForTypeOfAcquisition == '분양권(2021년 이전 취득)' || _dropDownMenuForTypeOfAcquisition == '분양권(2022년 이후 취득)')){
        return ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            kindOfConcession(),
            Cession(csv),
          ],
        );
      }else if((_dropDownMenuForTypeOfTransfer == '분양권(2021년 이전 취득)' ||_dropDownMenuForTypeOfTransfer == '분양권(2022년 이후 취득)'  )&& _dropDownMenuForReasonOfAquistition == '매매' && (_dropDownMenuForTypeOfAcquisition == '분양권(2021년 이전 취득)' || _dropDownMenuForTypeOfAcquisition == '분양권(2022년 이후 취득)')){
        return ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            kindOfConcession(),
            Cession(csv),
          ],
        );
      }else {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: csv.length,
          itemBuilder: (context, index){
            if(csv[index][7] == '취득일'){
              buyDate = acquisitionETCTCList[index].text;
              print('취득일은 : $buyDate');
            }
            if(csv[index][7] == '계약일'){
              contractDate = acquisitionETCTCList[index].text;
              print('계약일은 : $contractDate');
            }
            if(csv[index][7]=='취득일&계약일'){
              buyDate = acquisitionETCTCList[index].text;
              contractDate = acquisitionETCTCList[index].text;
            }
            if(csv[index][7].length > 1 && csv[index][7]!='취득일' && csv[index][7]!='계약일'&& csv[index][7]!='취득일&계약일'){
              if(acquisitionETCTCList[0].text.length > 1 && acquisitionETCTCList[1].text.length > 1){
                int _buydate1 = int.parse(acquisitionETCTCList[0].text);
                int _buydate2 = int.parse(acquisitionETCTCList[1].text);

                if(_buydate1 > _buydate2){
                  buyDate = _buydate1.toString();
                  contractDate = _buydate1.toString();
                }else {
                  buyDate = _buydate2.toString();
                  contractDate = _buydate1.toString();
                }
              }
            }
            if(csv[index][4] == '"계약일 당시 무주택 여부 (o,x)"'){
              return whetherHavingHome();
            }else if(csv[index][5] == 1){
              DateTime inheri;
              for(int i = 0 ; i < index ; i++){
                if(csv[i][4].toString().contains('상속개시일')){
                  startInheritance = acquisitionETCTCList[i].text;
                  break;
                }
              }
              if(startInheritance!.length > 7){
                inheri = DateTime.parse(startInheritance!);
              }else {inheri = DateTime.parse('21001231');}
              DateTime transfer = DateTime.parse(_transferDateTC.text);

              int diff = int.parse(inheri.difference(transfer).inDays.toString());
              if(diff <= 731){
                return Row(
                  children: [
                    _smallTitle(csv[index][4].toString().replaceAll('"', '')),
                    _textField2(acquisitionETCTCList[index],'',true)
                  ],
                );
              }else {return Container();}
            }
            else {
              return Row(
                children: [
                  _smallTitle(csv[index][4].toString().replaceAll('"', '')),
                  _textField2(acquisitionETCTCList[index],'',true)
                ],
              );
            }

          }
      );
      }
    }
  }

  Future<bool> isConflict(String pnu, String date)async{
    String baseURL = "https://26mlmqw646.execute-api.ap-northeast-2.amazonaws.com/default/check_reg?";
    final response = await http.get(Uri.parse('${baseURL}pnu=$pnu&date=$date'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes)); //한글 깨짐 방지를 위해 json.decode(response.body) 대신

      final res = jsonResponse['results']['field']['isRegulated'] as bool;

      return res;
    } else {
      throw Exception("Fail to fetch address data");
    }
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
              setState(() {

              });
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


  Widget _smallTitle(String txt,{double? width}) {
    if(width == null){
      return Container(
        width: 140,
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Text(
          txt,
          style: const TextStyle(fontSize: 20),
        ),
      );
    }
    else {
      return Container(
        width: width!,
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Text(
          txt,
          style: const TextStyle(fontSize: 20),
        ),
      );
    }

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

  Future<String> Search_Address_Dialog2(TextEditingController tc)async{

    int _searchPhase = 0;

    Widget _searchAddressGuide(){
      return Row(
        children:  [
          Expanded(
              child:
              Card(
                elevation: 2.5,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Center(
                    child: RichText(
                        text: const TextSpan(
                            children: [
                              TextSpan(text: "찾으시려는 ",style: TextStyle(fontSize: 17, height: 1.5)),
                              TextSpan(text: "도로명 주소",style: TextStyle(fontSize: 17, height: 1.5,color: Colors.redAccent)),
                              TextSpan(text: " 또는 ",style: TextStyle(fontSize: 17, height: 1.5)),
                              TextSpan(text: "지번주소",style: TextStyle(fontSize: 17, height: 1.5,color: Colors.redAccent)),
                              TextSpan(text: "를 입력해주세요.\n",style: TextStyle(fontSize: 17, height: 1.5)),
                              TextSpan(text: "예) 도로명 주소 : 불정로 432번길 / 지번 주소 : 정자동 178-1\n",style: TextStyle(fontSize: 17, height: 1.5,fontStyle: FontStyle.italic)),
                              TextSpan(text: "* 단 도로명 또는 동(읍/면/리)만 검색하시는 경우 정확한 검색결과가 나오지 않을 수 있습니다.",style: TextStyle(fontSize: 17, height: 1.5)),
                            ]
                        )
                    ),
                  ),
                ),
              )
          )
        ],
      );
    }

    Widget _addressList(StateSetter dialogSetState) {
      return Expanded(
          child: FutureBuilder(
              future: fetchAddress(tc.text),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Color(mainColor)),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }
                var res = snapshot.data! as List;
                return ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: res.length,
                    itemBuilder: (BuildContext context, int idx) {
                      int isIndividualHouse = res[idx].isIndividualHouse;
                      return Card(
                        color: Colors.white,
                        elevation: 2.5,
                        child: ListTile(
                          title: Text(res[idx].roadAddr),
                          subtitle: Text(res[idx].oldAddr),
                          onTap: () {
                            print(res[idx].pnu);
                            _tempAddr = TempAddr(roadAddr: res[idx].roadAddr, isIndividualHouse: isIndividualHouse, oldAddr: res[idx].oldAddr,pnu: res[idx].pnu);
                            dialogSetState(() {
                              tc.clear();
                              _searchPhase = 2;
                            });
                          },
                        ),
                      );
                    });
              }));
    }

    Widget _dongList(StateSetter dialogSetState){
      if(_searchPhase == 2){
        return Expanded(
            child: FutureBuilder(
                future: fetchDong(_tempAddr.pnu!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Color(mainColor)),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }
                  List dongList = snapshot.data! as List;
                  if(dongList.isNotEmpty){
                    _tempAddr.dong_list = dongList;
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: dongList.length,
                        itemBuilder: (BuildContext context, int idx) {
                          return ListTile(
                            title: Text( dongList[idx].toString()),
                            onTap: () {
                              if(dongList[idx] == '동 없음'){
                                _tempAddr.dong = dongList[idx];
                              }
                              else {_tempAddr.dong = dongList[idx];}
                              dialogSetState((){
                                _searchPhase = 3;
                              });
                            },
                          );
                        });
                  }
                  else {
                    Navigator.pop(context,_tempAddr.roadAddr);
                    return Container();
                  }
                }
            )
        );
      }else {return Container();}

    }

    Widget _hoList(StateSetter dialogSetState){
      if(_searchPhase == 3){
        return Expanded(
            child: FutureBuilder(
                future: fetchHo(_tempAddr.pnu!, _tempAddr.dong!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Color(mainColor)),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }
                  List hoList = snapshot.data! as List;
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: hoList.length,
                      itemBuilder: (BuildContext context, int idx) {
                        return ListTile(
                          title: Text( hoList[idx].toString()),
                          onTap: () {
                            _tempAddr.ho = hoList[idx];
                            dialogSetState((){
                              Navigator.pop(context, '${_tempAddr.roadAddr!} ${((){if(_tempAddr.dong! == '동 없음'){return '';}else {return _tempAddr.dong!;}})()} ${_tempAddr.ho!}');
                            });
                          },
                        );
                      });
                }
            )
        );
      }else {return Container();}
    }

    var res = await showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text('주소 검색'),
            actions: [
              Padding(
                padding: const EdgeInsets.all(5),
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
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter dialogSetState){

                List<Widget> dialogBody = [
                  _searchAddressGuide(),
                  _addressList(dialogSetState),
                  _dongList(dialogSetState),
                  _hoList(dialogSetState)
                ];
                return Container(
                  color: Colors.grey[60],
                  width: 600,
                  constraints: const BoxConstraints(
                    minHeight: 500,
                    maxHeight: 800,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(mainColor).withOpacity(.7),
                                        blurRadius: 2.0,
                                        spreadRadius: 1.0,
                                      )
                                    ],
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                width: 540,
                                margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: TextField(
                                    controller: tc,
                                    autofocus: true,
                                    onSubmitted: (value) {
                                      dialogSetState(() {
                                        _searchPhase = 1;
                                      });
                                    },
                                    cursorColor: Color(mainColor),
                                    textInputAction: TextInputAction.search,
                                    style: const TextStyle(fontSize: 17),
                                    decoration: InputDecoration(
                                        hintText: '예) 불정로 432번길',
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Color(mainColor)),
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(10))),
                                        enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.transparent),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        suffixIcon: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 15, 10),
                                          child: IconButton(
                                            icon:
                                            const Icon(Icons.search, size: 35),
                                            color: Colors.grey,
                                            onPressed: () {
                                              dialogSetState(() {
                                                _searchPhase = 1;
                                              });
                                            },
                                          ),
                                        ))),
                              )),
                          TextButton(
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  alignment: Alignment.center),
                              onPressed: () {
                                tc.clear();
                                Navigator.pop(context);
                              },
                              child: const Text(
                                '취소',
                                style: TextStyle(
                                    fontSize: 17, color: Color(0xff80cfd5)),
                              ))
                        ],
                      ),
                      dialogBody[_searchPhase]
                    ],
                  ),
                );
              },
            ),
          );
        }
    );

    return res;
  }


  Future fetchAddress(String keyword) async {
    String urlBase =
        'https://96qqvevx72.execute-api.ap-northeast-2.amazonaws.com/default/searchAddress?keyword=';

    final response = await http.get(Uri.parse(urlBase + keyword));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(utf8.decode(
          response.bodyBytes)); //한글 깨짐 방지를 위해 json.decode(response.body) 대신
      final addressMap = jsonResponse['results']['field'] as List;
      List address_list = addressMap.map((e) => Address.fromJson(e)).toList();
      return address_list;
    } else {
      throw Exception("Fail to fetch address data");
    }
  }


  Future fetchDong(String pnu) async {
    String urlBase =
        'https://z0hq847m05.execute-api.ap-northeast-2.amazonaws.com/default/detailedAddress?pnu=';
    final response = await http.get(Uri.parse(urlBase + pnu));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(utf8.decode(
          response.bodyBytes)); //한글 깨짐 방지를 위해 json.decode(response.body) 대신

      if(jsonResponse['results']['metadata']['errorCode'] == "0"){
        List dongList = jsonResponse['results']['field'] as List;
        print(dongList);
        return dongList;
      }
      else {return [];}

    } else {
      throw Exception("Fail to fetch address data");
    }
  }

  Future fetchHo(String pnu, String dong) async {
    String urlBase =
        'https://z0hq847m05.execute-api.ap-northeast-2.amazonaws.com/default/detailedAddress?pnu=';
    final response = await http.get(Uri.parse('$urlBase$pnu&dong=$dong'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(utf8.decode(
          response.bodyBytes)); //한글 깨짐 방지를 위해 json.decode(response.body) 대신
      List hoList = jsonResponse['results']['field'] as List;
      return hoList;
    } else {
      throw Exception("Fail to fetch address data");
    }
  }
}


class TempAddr{
  String? roadAddr;
  String? oldAddr;
  String? pnu;
  int? isIndividualHouse;
  List? dong_list;
  String? dong;
  String? ho;
  TempAddr({this.roadAddr,this.oldAddr,this.isIndividualHouse, this.pnu, this.dong_list, this.dong, this.ho});
}