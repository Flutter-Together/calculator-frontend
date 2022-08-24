import 'dart:async';
import 'dart:convert';

import 'package:calculator_frontend/widgets/Address.dart';
import 'package:calculator_frontend/widgets/Search_Dong.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Search_Address extends StatefulWidget {
  String? address;

  Search_Address({Key? key, this.address}) : super(key: key);

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
  final TextEditingController _findingAddressTC = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _clearText() {
    _findingAddressTC.clear();
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
              var addr = await _findingAddressDialog(_findingAddressTC);

              setState(() {
                addr_hinttext != addr;
                samplecolor = Colors.black;
              });
            },
            child: Address_Container_Design(
                addr_hinttext + ' ' + dongho_hinttext)),
      ],
    );
  }

  Container Address_Container_Design(String hintText) {
    return Container(
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
              hintText,
              style: TextStyle(fontSize: 17, color: samplecolor),
            ),
          ],
        ));
  }

  Future<String> _findingAddressDialog(TextEditingController tc) async {
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
                      isSearchedAddress
                          ? _addressList(tc.text)
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
                    physics: const ScrollPhysics(),
                    itemCount: res.length,
                    itemBuilder: (BuildContext context, int idx) {
                      String roadAddr = res[idx].roadAddr;
                      String oldAddr = res[idx].oldAddr;
                      String pnu = res[idx].pnu;
                      int isIndividualHouse = res[idx].isIndividualHouse;
                      List<dynamic> dong_list = res[idx].dong_list;
                      return isSearchedDong
                          ? Search_Dong(
                              road_arr: roadAddr,
                              pnu: pnu,
                              dong_list: dong_list)
                          : Card(
                              color: Colors.white,
                              elevation: 2.5,
                              child: ListTile(
                                title: Text(roadAddr),
                                subtitle: Text(oldAddr),
                                onTap: () {
                                  if (isIndividualHouse == 1) {
                                    Navigator.pop(context, roadAddr);
                                    dongho_hinttext = '';
                                  } else {
                                    _findingAddressDialog(_findingAddressTC);
                                    isSearchedAddress = true;
                                    isSearchedDong = true;
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
}
