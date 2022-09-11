import 'dart:async';
import 'dart:convert';

import 'package:calculator_frontend/widgets/Address.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Search_Address extends StatefulWidget {
  String? roadAddr;
  String? oldAddr;
  String? pnu;
  List? dong_list;
  String? dong;
  String? ho;
  int? isIndividualHouse;
  int stage;

  Search_Address(
      {Key? key,
      required this.stage,
      this.roadAddr,
      this.pnu,
      this.dong_list,
      this.dong,
      this.ho,
      this.oldAddr,
      this.isIndividualHouse})
      : super(key: key);

  @override
  State<Search_Address> createState() => _Search_AddressState();
}

class _Search_AddressState extends State<Search_Address> {
  final Color mainColor = const Color(0xff80cfd5);
  String addr_hinttext = '서울특별시 서초구 반포대로4(서초동) 101동 206호';
  Color samplecolor = Colors.black38;
  bool isSearchedAddress = false;
  bool isSearchedDong = false;
  bool isSearchedHo = false;
  final TextEditingController _address_keywordEditingController =
      TextEditingController();
  Search_Address _temp_search_addr = Search_Address(stage: 1,);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.stage;
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: widget.stage >= 1
              ? () async {
                  var a = await Search_Address_Dialog(
                      _address_keywordEditingController);
                  setState(() {
                    addr_hinttext = a;
                    samplecolor = Colors.black;
                    widget.stage = 2;
                    _address_keywordEditingController.clear();
                  });
                }
              : () async {
                  return showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        Future.delayed(Duration(milliseconds: 750), () {
                          Navigator.of(context).pop(true);
                        });
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          title: Text('앞의 단계를 먼저 진행해주세요',
                              style: TextStyle(
                                fontSize: 17,
                              ),
                              textAlign: TextAlign.center),
                        );
                      });
                },
          child: address_Container_Desgin(),
        )
      ],
    );
  }

  Container address_Container_Desgin() {
    return Container(
        height: 50,
        width: 750,
        decoration: BoxDecoration(
            border: Border.all(
              color: mainColor,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                addr_hinttext,
                style: TextStyle(fontSize: 17, color: samplecolor),
              ),
            ),
          ],
        ));
  }

  Future<String> Search_Address_Dialog(TextEditingController tc) async {
    int _searchPhase = 0;

    Widget _searchAddressGuide() {
      return Row(
        children: [
          Expanded(
              child: Card(
            elevation: 2.5,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Center(
                child: RichText(
                    text: const TextSpan(children: [
                  TextSpan(
                      text: "찾으시려는 ",
                      style: TextStyle(fontSize: 17, height: 1.5)),
                  TextSpan(
                      text: "도로명 주소",
                      style: TextStyle(
                          fontSize: 17, height: 1.5, color: Colors.redAccent)),
                  TextSpan(
                      text: " 또는 ",
                      style: TextStyle(fontSize: 17, height: 1.5)),
                  TextSpan(
                      text: "지번주소",
                      style: TextStyle(
                          fontSize: 17, height: 1.5, color: Colors.redAccent)),
                  TextSpan(
                      text: "를 입력해주세요.\n",
                      style: TextStyle(fontSize: 17, height: 1.5)),
                  TextSpan(
                      text: "예) 도로명 주소 : 불정로 432번길 / 지번 주소 : 정자동 178-1\n",
                      style: TextStyle(
                          fontSize: 17,
                          height: 1.5,
                          fontStyle: FontStyle.italic)),
                  TextSpan(
                      text:
                          "* 단 도로명 또는 동(읍/면/리)만 검색하시는 경우 정확한 검색결과가 나오지 않을 수 있습니다.",
                      style: TextStyle(fontSize: 17, height: 1.5)),
                ])),
              ),
            ),
          ))
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
                      valueColor: AlwaysStoppedAnimation(mainColor),
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
                            _temp_search_addr = Search_Address(
                              stage: 1,
                                roadAddr: res[idx].roadAddr,
                                isIndividualHouse: isIndividualHouse,
                                oldAddr: res[idx].oldAddr,
                                pnu: res[idx].pnu);
                            if (isIndividualHouse == 1) {
                              Navigator.pop(
                                  context, _temp_search_addr.roadAddr!);
                            } else {
                              dialogSetState(() {
                                tc.clear();
                                _searchPhase = 2;
                              });
                            }
                          },
                        ),
                      );
                    });
              }));
    }

    Widget _dongList(StateSetter dialogSetState) {
      if (_searchPhase == 2) {
        return Expanded(
            child: FutureBuilder(
                future: fetchDong(_temp_search_addr.pnu!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(mainColor),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }
                  List dongList = snapshot.data! as List;
                  _temp_search_addr.dong_list = dongList;
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: dongList.length,
                      itemBuilder: (BuildContext context, int idx) {
                        return ListTile(
                          title: Text(dongList[idx].toString()),
                          onTap: () {
                            if (dongList[idx] == '동 없음') {
                              _temp_search_addr.dong = dongList[idx];
                            } else {
                              _temp_search_addr.dong = dongList[idx];
                            }
                            dialogSetState(() {
                              _searchPhase = 3;
                            });
                          },
                        );
                      });
                }));
      } else {
        return Container();
      }
    }

    Widget _hoList(StateSetter dialogSetState) {
      if (_searchPhase == 3) {
        return Expanded(
            child: FutureBuilder(
                future:
                    fetchHo(_temp_search_addr.pnu!, _temp_search_addr.dong!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(mainColor),
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
                          title: Text(hoList[idx].toString()),
                          onTap: () {
                            _temp_search_addr.ho = hoList[idx];
                            dialogSetState(() {
                              Navigator.pop(
                                  context,
                                  '${_temp_search_addr.roadAddr!} ${(() {
                                    if (_temp_search_addr.dong! == '동 없음') {
                                      return '';
                                    } else {
                                      return _temp_search_addr.dong!;
                                    }
                                  })()} ${_temp_search_addr.ho!}');
                            });
                          },
                        );
                      });
                }));
      } else {
        return Container();
      }
    }

    var res = await showDialog(
        context: context,
        builder: (BuildContext context) {
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
                      color: mainColor,
                      size: 35,
                    )),
              )
            ],
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter dialogSetState) {
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
                                    color: mainColor.withOpacity(.7),
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
                                cursorColor: mainColor,
                                textInputAction: TextInputAction.search,
                                style: const TextStyle(fontSize: 17),
                                decoration: InputDecoration(
                                    hintText: '예) 불정로 432번길',
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: mainColor),
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
        });

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
      List dongList = jsonResponse['results']['field'] as List;
      return dongList;
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
