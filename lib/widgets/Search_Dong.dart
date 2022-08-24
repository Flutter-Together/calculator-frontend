import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Search_Dong extends StatefulWidget {
  String? road_arr;
  String? pnu;
  List? dong_list;
  Search_Dong(
      {Key? key,
      @required this.road_arr,
      @required this.pnu,
      @required this.dong_list})
      : super(key: key);

  @override
  State<Search_Dong> createState() => _Search_DongState();
}

class _Search_DongState extends State<Search_Dong> {
  final Color mainColor = Color(0xff80cfd5);
  bool isSearchedDongHo = false;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: widget.dong_list?.length,
        itemBuilder: (BuildContext context, int idx) {
          String dong = widget.dong_list?[idx];
          return ListTile(
            visualDensity: VisualDensity(horizontal: 0, vertical: 4),
            title: Text(dong),
            onTap: () {
              isSearchedDongHo = true;
              _donghoList(dong);
            },
          );
        });
  }

  Widget _donghoList(String dong) {
    return Expanded(
        child: FutureBuilder(
            future: fetchDongHO(dong),
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
                        ),
                      );
                    });
              });
            }));
  }

  Future fetchDongHO(String dong) async {
    String urlBase =
        'https://z0hq847m05.execute-api.ap-northeast-2.amazonaws.com/default/detailedAddress?pnu=&dong=201';

    final response = await http
        .get(Uri.parse(urlBase + widget.pnu.toString() + '&dong=' + dong));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(utf8.decode(
          response.bodyBytes)); //한글 깨짐 방지를 위해 json.decode(response.body) 대신
      final dongho_list = jsonResponse['results']['field'] as List;
      return dongho_list;
    } else {
      throw Exception("Fail to fetch address data");
    }
  }
}
