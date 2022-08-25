import 'dart:async';
import 'dart:convert';

import 'package:calculator_frontend/widgets/Address.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Search_Address extends StatefulWidget {
  String? roadAddr;
  String? pnu;
  List? dong_list;
  String? dong;
  String? dongho;

  Search_Address({Key? key, this.roadAddr, this.pnu, this.dong_list, this.dong, this.dongho})
      : super(key: key);

  @override
  State<Search_Address> createState() => _Search_AddressState();
}

class _Search_AddressState extends State<Search_Address> {
  final Color mainColor = const Color(0xff80cfd5);
  String addr_hinttext = '서울특별시 서초구 반포대로4(서초동)';
  String dongho_hinttext = '101동 206호';
  Color samplecolor = Colors.black38;
  bool isSearchedAddress = false;
  bool isSearchedDong = false;
  bool isSearchedHo = false;
  final TextEditingController _address_keywordEditingController =
      TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _back(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
            onTap: () async {
              var addr = await Search_Address_Dialog(
                  _address_keywordEditingController);

              setState(() {
                addr_hinttext = addr;
                samplecolor = Colors.black;
                _address_keywordEditingController.clear();
              });
            },
            child: Address_Container_Design(addr_hinttext + dongho_hinttext)),
      ],
    );
  }

  Container Address_Container_Design( String hintText) {
    return Container(
        height: 50,
        width: 700,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: mainColor.withOpacity(.7),
                blurRadius: 2.0,
                spreadRadius: 1.0,
              )
            ],
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                hintText,
                style: TextStyle(fontSize: 17, color: samplecolor),
              ),
            ),
          ],
        ));
  }

  Future<String> Search_Address_Dialog(TextEditingController tc) async {
    setState(() {
      isSearchedAddress = false;
    });
    var res = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: const Text('주소 검색'),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: IconButton(
                        onPressed: () {
                          _back(context);
                        },
                        icon: Icon(
                          Icons.cancel_outlined,
                          color: mainColor,
                          size: 35,
                        )),
                  )
                ],
                content: Container(
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
                          Container(
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
                                  setState(() {
                                    isSearchedAddress = true;
                                  });
                                },
                                cursorColor: mainColor,
                                textInputAction: TextInputAction.search,
                                style: const TextStyle(fontSize: 17),
                                decoration: InputDecoration(
                                    hintText: '예) 반포대로',
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
                                          setState(() {
                                            isSearchedAddress = true;
                                          });
                                        },
                                      ),
                                    ))),
                          ),
                          StatefulBuilder(builder: (context, setState) {
                            return TextButton(
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    alignment: Alignment.center),
                                onPressed: () {
                                  _address_keywordEditingController.clear();
                                  Navigator.pop(context);
                                  Search_Address_Dialog(
                                      _address_keywordEditingController);
                                  isSearchedDong = false;
                                  isSearchedAddress = false;
                                  isSearchedHo = false;
                                },
                                child: const Text(
                                  '취소',
                                  style: TextStyle(
                                      fontSize: 17, color: Color(0xff80cfd5)),
                                ));
                          })
                        ],
                      ),
                      isSearchedAddress
                          ? Search_Total_Address(tc.text)
                          : const SizedBox(
                              height: 100,
                              child: Center(
                                child: Text(
                                  '주소를 입력해주세요',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            )
                    ],
                  ),
                ));
          });
        });

    return widget.roadAddr.toString() + ' ' + widget.roadAddr.toString();
  }

  Widget Search_Total_Address(String keyword) {
    return isSearchedHo
        ? Search_Ho()
        : Expanded(
            child: FutureBuilder(
                future: fetchAddress(keyword),
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
                  return isSearchedDong
                      ? Search_Dong2()
                      : StatefulBuilder(builder: (context, setState) {
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemCount: res.length,
                              itemBuilder: (BuildContext context, int idx) {
                                widget.roadAddr = res[idx].roadAddr;
                                String oldAddr = res[idx].oldAddr;
                                int isIndividualHouse =
                                    res[idx].isIndividualHouse;
                                widget.dong_list = res[idx].dong_list;
                                return Card(
                                  color: Colors.white,
                                  elevation: 2.5,
                                  child: ListTile(
                                    title: Text(widget.roadAddr.toString()),
                                    subtitle: Text(oldAddr),
                                    onTap: () {
                                      if (isIndividualHouse == 1) {
                                        widget.roadAddr = res[idx].roadAddr;
                                        widget.dongho = '';
                                        Navigator.pop(context, widget.roadAddr);
                                        dongho_hinttext = '';
                                      }else {
                                        Navigator.of(context).pop();
                                        Search_Address_Dialog(
                                            _address_keywordEditingController);
                                        isSearchedAddress = true;
                                        isSearchedDong = true;
                                        widget.roadAddr = res[idx].roadAddr;
                                        widget.pnu = res[idx].pnu;
                                        widget.dong_list = res[idx].dong_list;
                                        widget.dongho = '';
                                      }
                                    },
                                  ),
                                );
                              });
                        });
                }));
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

  Widget Search_Dong2() {
    return ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: widget.dong_list?.length,
        itemBuilder: (BuildContext context, int idx) {
          widget.dong = widget.dong_list?[idx];
          return ListTile(
            title: Text(widget.dong.toString()),
            onTap: () {
              Navigator.of(context).pop();
              Search_Address_Dialog(_address_keywordEditingController);
              isSearchedAddress = true;
              isSearchedDong = true;
              isSearchedHo = true;
              widget.dong = widget.dong_list?[idx];
            },
          );
        });
  }

  Search_Ho() {
    if (widget.dong.toString().lastIndexOf('동') == -1) {
      widget.dongho = widget.dong;
      Navigator.pop(context);
    } else {
      return Expanded(
          child: FutureBuilder(
              future: fetchDongHO(),
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
                var ho_list = snapshot.data! as List;
                return StatefulBuilder(builder: (context, setState) {
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: ho_list.length,
                      itemBuilder: (BuildContext context, int idx) {
                        String ho = ho_list[idx];
                        return GestureDetector(
                          onTap: () {
                            Navigator.pop(context, ho);
                          },
                          child: ListTile(
                            title: Text(ho),
                            onTap: () {
                              widget.dongho = ho_list[idx];
                              Navigator.pop(context);
                            },
                          ),
                        );
                      });
                });
              }));
    }
  }

  Future fetchDongHO() async {
    String urlBase =
        'https://z0hq847m05.execute-api.ap-northeast-2.amazonaws.com/default/detailedAddress?pnu=';
    final response = await http.get(Uri.parse(
        urlBase + widget.pnu.toString() + '&dong=' + widget.dong.toString()));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(utf8.decode(
          response.bodyBytes)); //한글 깨짐 방지를 위해 json.decode(response.body) 대신
      List ho_list = jsonResponse['results']['field'] as List;
      return ho_list;
    } else {
      throw Exception("Fail to fetch address data");
    }
  }
}
