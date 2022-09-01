import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Address_API{
  String roadAddr;
  String oldAddr;
  String pnu;
  String isIndividualHouse;
  List dong;

  Address_API({
   required this.roadAddr,
   required this.oldAddr,
   required this.pnu,
   required this.isIndividualHouse,
   required this.dong
  });

  factory Address_API.fromJson(Map<String, dynamic> json){
    return Address_API(
        roadAddr: json['roadAddr'],
      oldAddr: json['oldAddr'],
      pnu: json['pnu'],
      isIndividualHouse: json['isIndividualHouse'],
      dong: json['dong']
    );
  }
}


Future fetchAddressList(String keyword) async {
  String urlBase = 'https://96qqvevx72.execute-api.ap-northeast-2.amazonaws.com/default/searchAddress?keyword=';

  final response = await http.get(Uri.parse(urlBase + keyword));

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes)); //한글 깨짐 방지를 위해 json.decode(response.body) 대신

    final addressMap = jsonResponse['results']['field'] as List;

    List address_list = addressMap.map((e) => Address_API.fromJson(e)).toList();

    return address_list;
  } else {
    throw Exception("Fail to fetch address data");
  }
}