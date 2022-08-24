import 'dart:async';
import 'dart:convert';

import 'package:calculator_frontend/widgets/Address.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Search_Address extends StatefulWidget {
  String? address;
  Search_Address({Key? key, this.address}) : super(key: key);

  @override
  State<Search_Address> createState() => _Search_AddressState();
}

class _Search_AddressState extends State<Search_Address> {
  final Color mainColor = Color(0xff80cfd5);
  String sampleaddr = '서울특별시 서초구 반포대로4(서초동)';
  Color samplecolor = Colors.black38;
  late int _stage;
  bool _isSearchedAddress = false;
  final TextEditingController _findingAddressTC = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _stage = 1;
  }

  void _clearText() {
    _findingAddressTC.clear();
  }

  void _back(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var a = await _findingAddressDialog(_findingAddressTC);

        setState(() {
          sampleaddr != a;
          samplecolor = Colors.black;
          _stage = 2;
        });
      },
      child: Container(
          height: 40,
          width: 550,
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
              Text(
                sampleaddr,
                style: TextStyle(fontSize: 17, color: samplecolor),
              ),
            ],
          )),
    );
  }

  Future<String> _findingAddressDialog(TextEditingController tc) async {
    setState(() {
      _isSearchedAddress = false;
    });
    var res = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
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
                                    _isSearchedAddress = true;
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    suffixIcon: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 0, 15, 10),
                                      child: IconButton(
                                        icon:
                                            const Icon(Icons.search, size: 35),
                                        color: Colors.grey,
                                        onPressed: () {
                                          setState(() {
                                            _isSearchedAddress = true;
                                          });
                                        },
                                      ),
                                    ))),
                          ),
                          TextButton(
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  alignment: Alignment.center),
                              onPressed: _clearText,
                              child: const Text(
                                '취소',
                                style: TextStyle(
                                    fontSize: 17, color: Color(0xff80cfd5)),
                              ))
                        ],
                      ),
                      _isSearchedAddress
                          ? _addressList(tc.text)
                          : SizedBox(
                              height: 100,
                              child: const Center(
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

    return res;
  }

  Widget _addressList(String keyword) {
    return Expanded(
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
              return StatefulBuilder(builder: (context, setState) {
                return ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: res.length,
                    itemBuilder: (BuildContext context, int idx) {
                      String roadAddr = res[idx].roadAddr;
                      String oldAddr = res[idx].oldAddr;
                      List<dynamic> dong_list = res[idx].dong_list;
                      return GestureDetector(
                        onTap: () {
                          Navigator.pop(context, roadAddr);
                          widget.address = roadAddr;
                        },
                        child: ListTile(
                          title: Text(roadAddr),
                          subtitle: Text(oldAddr),
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

  Widget _selectAddressBox(String newAddress, String oldAddress, int index) {
    Color backgrouundColor;
    if (index.isEven) {
      backgrouundColor = Colors.white;
    } else {
      backgrouundColor = Colors.black26;
    }

    return GestureDetector(
      onTap: () {
        Navigator.pop(context, newAddress);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
        decoration: BoxDecoration(color: backgrouundColor),
        child: Column(
          children: [Text(newAddress), Text(oldAddress)],
        ),
      ),
    );
  }
}
